module vertex_buffer_one(
    input clk, reset,
    // From Vertex PE
    input Vertex2Accu_Bank vertex_data_pkt, 
    input Weight_Cntl2bank vertex_cntl_pkt,
    input req_grant,
 
    // Busy signal
    output bank_busy,
    // To Output Buffer
    output Bank_Req2Req_Output_SRAM outbuff_pkt
);

    logic [`MAX_FV_num-1:0][`FV_size-1:0] buffer;
    logic [$clog2(`MAX_FV_num):0] cnt;
    logic [$clog2(`MAX_FV_num):0] output_FV_num;
    logic [$clog2(`Max_Node_id)-1:0] cur_nodeid;

    // logic [1:0] state;
    // localparam IDLE = 0;
    // localparam STREAM_IN = 1;
    // localparam OUT_FV_WAIT = 2;
    // localparam OUT_FV = 3; 

    typedef enum logic [1:0] {
        // logic [2:0] state;
        IDLE = 'd0,
        STREAM_IN = 'd1,
        COMPLETE = 'd2,
        OUT_FV_WAIT = 'd3,
        OUT_FV = 'd4
    } state_t;

    state_t state;


    assign bank_busy = !(state == IDLE);


    always_comb begin
        outbuff_pkt.Grant_valid = 1'b0;
        outbuff_pkt.sos = 1'b0;
        outbuff_pkt.eos = 1'b0;
        // for (int i = 0; i < (`FV_bandwidth/`FV_size); i++) begin
        //     outbuff_pkt.data[((i+1)*`FV_size-1):i] = buffer[cnt];
        //     outbuff_pkt.data[15:8] = buffer[cnt+1];
        // end
        outbuff_pkt.data[15:8] = 'd0;
        outbuff_pkt.data[7:0] = 'd0;
        outbuff_pkt.Node_id = cur_nodeid;
        outbuff_pkt.req = 1'b0;

        if (state == IDLE && vertex_cntl_pkt.sos && vertex_cntl_pkt.eos) begin
            outbuff_pkt.req = 1'b1;
        end else if ((state == STREAM_IN) && vertex_cntl_pkt.eos) begin
            outbuff_pkt.req = 1'b1;
        end else if (state == OUT_FV_WAIT) begin
            if (req_grant) begin
                outbuff_pkt.Grant_valid = 1'b1;
                outbuff_pkt.sos = 1'b1;
                if (cnt + 2 >= output_FV_num) begin
                    outbuff_pkt.eos = 1'b1;
                end else begin
                    outbuff_pkt.eos = 1'b0;
                end
                outbuff_pkt.eos = 1'b0;
                outbuff_pkt.data[7:0] = buffer[cnt];
                outbuff_pkt.data[15:8] = buffer[cnt+1];
                outbuff_pkt.req = 1'b0;
            end else begin
                outbuff_pkt.req = 1'b1;
            end
        end else if (state == OUT_FV) begin
            outbuff_pkt.Grant_valid = 1'b1;
            outbuff_pkt.sos = 1'b0;
            if (cnt + 2 >= output_FV_num) begin
                outbuff_pkt.eos = 1'b1;
            end else begin
                outbuff_pkt.eos = 1'b0;
            end
            outbuff_pkt.data[7:0] = buffer[cnt];
            outbuff_pkt.data[15:8] = buffer[cnt+1];
        end
    end


    always_ff @(posedge clk) begin
        if (reset) begin
            buffer <= #1  0;
            state <= #1  IDLE;
            cnt <= #1  'd0;
            output_FV_num <= #1 'd0;
            cur_nodeid <= #1  'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (vertex_cntl_pkt.sos) begin
                        buffer[cnt] <= #1 vertex_data_pkt.data + buffer[cnt];
                        cur_nodeid <= #1 vertex_data_pkt.Node_id;
                        if (vertex_cntl_pkt.eos) begin
                            state <= #1 OUT_FV_WAIT;
                            // output pkt request
                            output_FV_num <= #1 cnt + 1;
                        end else begin
                            state <= #1 STREAM_IN;
                            if (vertex_cntl_pkt.change) begin
                                cnt <= #1 cnt+1;
                            end
                        end
                    end
                end
                
                STREAM_IN: begin
                    if (vertex_cntl_pkt.eos) begin
                        // output_pkt.req = 1'b1;
                        state <= #1 OUT_FV_WAIT;
                        output_FV_num <= #1 cnt + 1;
                        cnt <= 'd0;
                    end else if (vertex_cntl_pkt.change) begin
                        cnt <= #1 cnt+1;
                    end
                    buffer[cnt] <= #1 vertex_data_pkt.data + buffer[cnt];
                end

                OUT_FV_WAIT: begin
                    if (req_grant) begin
                        if (cnt + 2 >= output_FV_num) begin
                            state <= #1 IDLE;
                            buffer <= #1 0;
                            cnt <= #1 'd0;
                        end else begin
                            state <= #1 OUT_FV;
                            cnt <= #1 cnt + 2;
                        end
                    end
                end

                OUT_FV: begin
                    if (cnt + 2 >= output_FV_num) begin
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