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

    logic [1:0] state;
    localparam IDLE = 0;
    localparam STREAM_IN = 1;
    localparam OUT_FV_WAIT = 2;
    localparam OUT_FV = 3; 

    assign busy = !(state == IDLE);


    always_comb begin
        outbuff_pkt.Grant_valid = 1'b0;
        outbuff_pkt.sos = 1'b0;
        outbuff_pkt.eos = 1'b0;
        outbuff_pkt.data[0] = 'd0;
        outbuff_pkt.data[1] = 'd0;
        outbuff_pkt.Node_id = cur_nodeid;
        outbuff_pkt.req = 1'b0;

        if (state == IDLE && vertex_cntl_pkt.sos && vertex_cntl_pkt.eos) begin
            outbuff_pkt.req = 1'b1;
        end

        if ((state == STREAM_IN) && vertex_cntl_pkt.eos) 
            outbuff_pkt.req = 1'b1;

        if (state == OUT_FV_WAIT) begin
            if (req_grant) begin
                outbuff_pkt.Grant_valid = 1'b1;
                outbuff_pkt.sos = 1'b1;
                outbuff_pkt.eos = 1'b0;
                outbuff_pkt.data[0] = buffer[cnt];
                outbuff_pkt.data[1] = buffer[cnt+1];
                outbuff_pkt.req = 1'b0;
            end
        end
        
        if (state == OUT_FV) begin
            outbuff_pkt.Grant_valid = 1'b1;
            outbuff_pkt.sos = 1'b0;
            if (cnt + 2 >= output_FV_num) begin
                outbuff_pkt.eos = 1'b1;
            end else begin
                outbuff_pkt.eos = 1'b0;
            end
            outbuff_pkt.data[0] = buffer[cnt];
            outbuff_pkt.data[1] = buffer[cnt+1];
        end
    end


    always_ff @(posedge clk) begin
        if (reset) begin
            buffer <= 0;
            state <= IDLE;
            cnt <= 'd0;
            output_FV_num <= 'd0;
            cur_nodeid <= 'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (vertex_cntl_pkt.sos) begin
                        buffer[cnt] <= vertex_data_pkt.data + buffer[cnt];
                        cur_nodeid <= vertex_data_pkt.Node_id;
                        if (vertex_cntl_pkt.eos) begin
                            state <= OUT_FV_WAIT;
                            // output pkt request
                            output_FV_num <= cnt + 1;
                        end else begin
                            state <= STREAM_IN;
                            if (vertex_cntl_pkt.change) begin
                                cnt <= cnt++;
                            end
                        end
                    end
                end
                
                STREAM_IN: begin
                    if (vertex_cntl_pkt.eos) begin
                        // output_pkt.req = 1'b1;
                        state <= OUT_FV_WAIT;
                        output_FV_num <= cnt + 1;
                    end else if (vertex_cntl_pkt.change) begin
                        cnt <= cnt++;
                    end
                    buffer[cnt] <= vertex_data_pkt.data + buffer[cnt];
                end

                OUT_FV_WAIT: begin
                    if (req_grant) begin
                        state <= OUT_FV;
                        cnt <= cnt + 2;
                    end
                end

                OUT_FV: begin
                    if (cnt + 2 >= output_FV_num) begin
                        state <= IDLE;
                        buffer <= 0;
                        cnt <= 'd0;
                    end
                end
            endcase
        
        end
        
    end

    
endmodule