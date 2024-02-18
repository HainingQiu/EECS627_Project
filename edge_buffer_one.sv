// `include "sys_defs.svh"

module edge_buffer_one(
    input clk, reset,
    // From Edge PE
    input Edge_PE2Bank edge_pkt,
    input req_grant,
    input rs_req_grant,
    // input RS_busy,

    // To Reservation Station 
    output logic rs_req,
    output Bank2RS rs_pkt,

    // Busy signal
    output logic bank_busy,

    // To Output Buffer
    output Bank_Req2Req_Output_SRAM outbuff_pkt
);

    logic [`MAX_FV_num-1:0][`FV_size-1:0] buffer;
    logic [$clog2(`MAX_FV_num):0] cnt;
    logic [$clog2(`MAX_FV_num):0] iter_FV_num;
    logic [$clog2(`Max_Node_id)-1:0] cur_nodeid;

    typedef enum logic [2:0] {
        // logic [2:0] state;
        IDLE = 'd0,
        STREAM_IN = 'd1,
        COMPLETE = 'd2,
        OUT_RS = 'd3,
        OUT_RS_WAIT = 'd4,
        OUT_FV_WAIT = 'd5,
        OUT_FV = 'd6
    } state_t;

    state_t state;
    // localparam IDLE = 0;
    // localparam STREAM_IN = 1;
    // localparam COMPLETE = 2;
    // localparam OUT_RS = 3;
    // localparam OUT_RS_WAIT = 4;
    // localparam OUT_FV_WAIT = 5;
    // localparam OUT_FV = 6;

    assign bank_busy = !(state == IDLE);

    always_comb begin
        outbuff_pkt.Grant_valid = 1'b0;
        outbuff_pkt.sos = 1'b0;
        outbuff_pkt.eos = 1'b0;
        outbuff_pkt.data[15:8] = 'd0;
        outbuff_pkt.data[7:0] = 'd0;
        outbuff_pkt.Node_id = cur_nodeid;
        outbuff_pkt.req = 1'b0;
        rs_req='d0;


        if(state == COMPLETE)begin
            if (edge_pkt.WB_en) 
                    outbuff_pkt.req = 1'b1;
            if (edge_pkt.Done_aggr)
                    rs_req = 1'b1;

        end else if (state == OUT_FV_WAIT) begin
             if (req_grant) begin
                outbuff_pkt.Grant_valid = 1'b1;
                outbuff_pkt.sos = 1'b1;
                if (cnt + 2 == iter_FV_num) begin // when entering OUT_FV_WAIT, cnt = 0
                    outbuff_pkt.eos = 1'b1;
                end else begin
                    outbuff_pkt.eos = 1'b0;
                end
                outbuff_pkt.data[15:8] = buffer[cnt];
                outbuff_pkt.data[7:0] = buffer[cnt+1];
                outbuff_pkt.req = 1'b0;
            end else begin
                outbuff_pkt.req = 1'b1;
            end
        end else if(state == OUT_FV)begin
            // outbuff_pkt.sos = 1'b0;
            outbuff_pkt.Grant_valid = 1'b1;
            if (cnt + 2 == iter_FV_num) begin
                outbuff_pkt.eos = 1'b1;
            end else begin
                outbuff_pkt.eos = 1'b0;
            end
            outbuff_pkt.data[15:8] = buffer[cnt];
            outbuff_pkt.data[7:0] = buffer[cnt+1];
        end else if (state == OUT_RS_WAIT) begin
            if (!rs_req_grant) begin
                rs_req = 1'b1;
            end
        end
    end

    /*
        Start of Iteration i
        1. Streaming aggregation value of previous iterations
        2. Done streaming the previous output value
        3. Start streaming the feature values of this iteration for node n
        4. done streaming, 
            last iteration ? then done aggregation
            not last iteration ? then do write back to output buffer, wait for grant 
    */

    logic complete_before;

    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < `MAX_FV_num; i++) begin
                buffer[i] <= #1 'd0;
            end
            iter_FV_num <= #1 'd0;
            cur_nodeid <= #1 'd0;
            cnt <= #1 'd0;
            state <= #1 IDLE;
            rs_pkt <= #1 0;
            complete_before <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    rs_pkt <= #1 0;
                    if (edge_pkt.sos) begin
                        buffer[cnt] <= #1 edge_pkt.FV_data[0] + buffer[cnt];
                        buffer[cnt+1] <= #1 edge_pkt.FV_data[1] + buffer[cnt+1];
                        cur_nodeid <= #1 edge_pkt.Node_id;
                        cnt <= #1 cnt + 2;
                        if (edge_pkt.eos) begin
                            state <= #1 COMPLETE;
                            iter_FV_num <= #1 cnt + 2;
                            complete_before <= 1'b1;
                        end else begin
                            state <= #1 STREAM_IN;
                        end
                    end
                end
                STREAM_IN: begin
                     if (edge_pkt.eos) begin
                        if (!complete_before) begin
                            iter_FV_num <= #1 cnt + 2;
                            complete_before <= 1'b1;
                        end
                        cnt <= #1 '0;
                        state <= #1 COMPLETE;
                    end else begin
                        cnt <= #1 cnt + 2;
                    end
                    buffer[cnt] <= #1 edge_pkt.FV_data[0] + buffer[cnt];
                    buffer[cnt+1] <= #1 edge_pkt.FV_data[1] + buffer[cnt+1];
                end
                COMPLETE: begin
                    if (edge_pkt.Done_aggr) begin // finish aggregation of all nodes, send to RS
                        state <= #1 OUT_RS_WAIT;
                    end else if (edge_pkt.WB_en) begin
                        state <= #1 OUT_FV_WAIT;
                    end else if (edge_pkt.sos) begin
                        buffer[cnt] <= #1 edge_pkt.FV_data[0] + buffer[cnt];
                        buffer[cnt+1] <= #1 edge_pkt.FV_data[1] + buffer[cnt+1];
                        cur_nodeid <= #1 edge_pkt.Node_id;
                        cnt <= #1 cnt + 2;
                        if (edge_pkt.eos) begin
                            state <= #1 COMPLETE;
                            cnt <= #1 'd0;
                        end else begin
                            state <= #1 STREAM_IN;
                        end
                    end else begin
                        state <= #1 COMPLETE;
                    end
                end
                OUT_RS_WAIT: begin
                    if (rs_req_grant) begin
                        rs_pkt.sos <= #1 1'b1;
                        rs_pkt.FV_data[0] <= #1 buffer[cnt];
                        rs_pkt.FV_data[1] <= #1 buffer[cnt+1];
                        rs_pkt.Node_id <= #1 cur_nodeid;
                        if (cnt + 2 == iter_FV_num) begin
                            cnt <= #1 'd0;
                            state <= #1 IDLE;
                            buffer <= #1 0;
                            rs_pkt.eos <= #1 1'b1;
                        end else begin
                            cnt <= #1 cnt + 2;
                            state <= #1 OUT_RS;
                            rs_pkt.eos <= #1 1'b0;
                        end
                    end else begin
                        rs_pkt.sos <= #1 1'b0;
                        rs_pkt.FV_data[0] <= #1 'd0;
                        rs_pkt.FV_data[1] <= #1 'd0;
                        rs_pkt.Node_id <= #1 'd0;
                        rs_pkt.eos <= #1 1'b0;
                    end
                end
                OUT_RS: begin
                    rs_pkt.sos <= #1 1'b0;
                    rs_pkt.FV_data[0] <= #1 buffer[cnt];
                    rs_pkt.FV_data[1] <= #1 buffer[cnt+1];
                    rs_pkt.Node_id <= #1 cur_nodeid;
                    if (cnt + 2 == iter_FV_num) begin
                        state <= #1 IDLE;
                        buffer <= #1 0;
                        cnt <= #1 'd0;
                        rs_pkt.eos <= #1 1'b1;
                    end
                    else begin
                        cnt <= #1 cnt + 2;
                        state <= #1 OUT_RS;
                        rs_pkt.eos <= #1 1'b0;
                    end
                end
                OUT_FV_WAIT: begin
                    if (req_grant) begin
                        if (cnt + 2 == iter_FV_num) begin
                            state <= #1 IDLE;
                            cnt <= #1 'd0;
                        end else begin
                            state <= #1 OUT_FV;
                            cnt <= #1 cnt + 2;
                        end
                    end 
                end
                OUT_FV: begin
                    if (cnt + 2 == iter_FV_num) begin
                        state <= #1 IDLE;
                        buffer <= #1 0;
                        cnt <= #1 'd0;
                    end else begin
                        cnt <= #1 cnt + 2;
                    end
                end
            endcase
        end
    end
    
endmodule
