`include "sys_defs.svh"

module edge_buffer_one(
    input clk, reset,
    // From Edge PE
    input Edge_PE2Bank edge_pkt,
    input req_grant,
    input rs_req_grant,

    // To Reservation Station 

    output rs_req,
    output Bank2RS rs_pkt,

    // Busy signal
    output bank_busy,

    // To Output Buffer
    output Bank_Req2Req_Output_SRAM outbuff_pkt
);

    logic [`MAX_FV_num-1:0][`FV_size-1:0] buffer;
    logic [$clog2(`MAX_FV_num):0] cnt;
    logic [$clog2(`MAX_FV_num):0] iter_FV_num;
    logic [$clog2(`Max_Node_id)-1:0] cur_nodeid;

    logic [2:0] state;
    localparam IDLE = 0;
    localparam STREAM_IN = 1;
    localparam COMPLETE = 2;
    localparam OUT_RS = 3;
    localparam OUT_RS_WAIT = 4;
    localparam OUT_FV_WAIT = 5;
    localparam OUT_FV = 6;

    assign busy = !(state == IDLE);

    always_comb begin
        outbuff_pkt.Grant_valid = 1'b0;
        outbuff_pkt.sos = 1'b0;
        outbuff_pkt.eos = 1'b0;
        outbuff_pkt.data[0] = 'd0
        outbuff_pkt.data[1] = 'd0;
        outbuff_pkt.nodeid = cur_nodeid;
        outbuff_pkt.req = 1'b0;

        case (state)
            COMPLETE: begin
                if (edge_pkt.WB_en)
                    outbuff_pkt.req = 1'b1;
            end
            OUT_FV_WAIT: begin
                 if (req_grant) begin
                    outbuff_pkt.Grant_valid = 1'b1;
                    outbuff_pkt.sos = 1'b1;
                    outbuff_pkt.eos = 1'b0;
                    outbuff_pkt.data[0] = buffer[cnt];
                    outbuff_pkt.data[1] = buffer[cnt+1];
                    outbuff_pkt.req = 1'b0;
                end else begin
                    outbuff_pkt.req = 1'b1;
                end
            end
            OUT_FV: begin
                outbuff_pkt.sos = 1'b0;
                outbuff_pkt.Grant_valid = 1'b1;
                if (cnt + 2 == iter_FV_num) begin
                    outbuff_pkt.eos = 1'b1;
                end else begin
                    outbuff_pkt.eos = 1'b0;
                end
                outbuff_pkt.data[0] = buffer[cnt];
                outbuff_pkt.data[1] = buffer[cnt+1];
            end
        endcase
    end

    always_comb begin

        case (state)
            COMPLETE: begin
                if (edge_pkt.Done_aggr)
                    rs_req = 1'b1;
            end
            OUT_RS_WAIT: begin
                if (rs_req_grant) begin
                    rs_pkt.sos = 1'b1;
                    rs_pkt.FV_data[0] = buffer[cnt];
                    rs_pkt.FV_data[1] = buffer[cnt+1];
                    rs_pkt.nodeid = cur_nodeid;
                    if (cnt + 2 == iter_FV_num) begin
                        rs_pkt.eos = 1'b1;
                    end else begin
                        rs_pkt.eos <= 1'b0;
                        cnt <= cnt + 2;
                        state <= OUT_RS;
                    end
                end else begin
                    rs_req = 1'b1;
                end
            end
            OUT_RS: begin
                rs_pkt.sos = 1'b0;
                if (cnt + 2 == iter_FV_num) begin
                    rs_pkt.eos = 1'b1;
                end else begin
                    rs_pkt.eos = 1'b0;
                end
                rs_pkt.FV_data[0] = buffer[cnt];
                rs_pkt.FV_data[1] = buffer[cnt+1];
            end
            default: begin
                rs_pkt.sos = 1'b0;
                rs_pkt.eos = 1'b0;
                rs_pkt.FV_data = 'd0;
                rs_pkt.nodeid = 'd0;
            end
        endcase
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

    always_ff @(posedge clk) begin
        if (!reset) begin
            for (int i = 0; i < `MAX_FV_num; i++) begin
                buffer[i] <= 'd0;
            end
            iter_FV_num <= 'd0;
            cur_nodeid <= 'd0;
            cnt <= 'd0;
            state <= IDLE;
            rs_pkt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    rs_pkt <= 0;
                    if (edge_pkt.sos) begin
                        buffer[cnt] <= edge_pkt.FV_data[0] + buffer[cnt];
                        buffer[cnt+1] <= edge_pkt.FV_data[1] + buffer[cnt+1];
                        cur_nodeid <= edge_pkt.nodeid;
                        cnt <= cnt + 2;
                        if (edge_pkt.eos) begin
                            state <= COMPLETE;
                            iter_FV_num <= cnt + 2;
                        end else begin
                            state <= STREAM_IN;
                        end
                    end
                end
                STREAM_IN: begin
                     if (edge_pkt.eos) begin
                        iter_FV_num <= cnt + 2;
                        cnt <= '0;
                        state <= COMPLETE;
                    end else begin
                        cnt <= cnt + 2;
                    end
                    buffer[cnt] <= edge_pkt.FV_data[0] + buffer[cnt];
                    buffer[cnt+1] <= edge_pkt.FV_data[1] + buffer[cnt+1];
                end
                COMPLETE: begin
                    if (edge_pkt.Done_aggr) begin // finish aggregation of all nodes, send to RS
                        state <= OUT_RS_WAIT;
                    end else if (edge_pkt.WB_en) begin
                        state <= OUT_FV_WAIT;
                    end else begin
                        state <= IDLE;
                    end
                end
                OUT_RS_WAIT: begin
                    if (rs_req_grant) begin
                        if (cnt + 2 == iter_FV_num) begin
                            cnt <= 'd0;
                            state <= IDLE;
                            buffer <= 0;
                        end else begin
                            cnt <= cnt + 2;
                            state <= OUT_RS;
                        end
                    end
                end
                OUT_RS: begin
                    if (cnt + 2 == iter_FV_num) begin
                        state <= IDLE;
                        buffer <= 0;
                        cnt <= 'd0;
                    end
                end
                OUT_FV_WAIT: begin
                    if (req_grant) begin
                        cnt <= cnt + 2;
                        state <= OUT_FV;
                    end
                end
                OUT_FV: begin
                    if (cnt + 2 == iter_FV_num) begin
                        state <= IDLE;
                        buffer <= 0;
                        cnt <= 'd0;
                    end 
                end
            endcase
        end
    end
    
endmodule
