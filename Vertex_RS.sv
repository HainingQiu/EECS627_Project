module Vertex_RS (
    input clk,
    input reset,
    input Bank2RS Bank2RS_in,
    output RS2Vertex_PE RS2Vertex_PE_out
);

    RS2Vertex_PE RS_buffer;
    logic [2:0] count;
    logic counting;

    logic [$clog2(`Num_RS2Vertex_PE):0] eos_cnt;
    logic eos_last; 

    logic [3:0] boundary;
    // logic [$clog2(`Num_RS2Vertex_PE):0] sos_cnt;
    // logic sos_last; 
    assign boundary = count << 1;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 0;
            counting <= 0;
        end else begin
            if (Bank2RS_in.sos) begin
                counting <= 1;
                count <= count + 1;
            end
            if (counting) begin
                if (count == 7 || Bank2RS_in.eos) begin
                    count <= 0;
                    counting <= 0;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            eos_cnt <= 0;
            eos_last <= 0;
        end else begin
            eos_last <= Bank2RS_in.eos; 
            if (Bank2RS_in.eos && !eos_last) begin
                eos_cnt <= (eos_cnt == `Num_RS2Vertex_PE-1) ? 0 : eos_cnt + 1;
            end
        end
    end

    // always_ff @(posedge clk) begin
    //     if (reset) begin
    //         sos_cnt <= 0;
    //         sos_last <= 0;
    //     end else begin
    //         sos_last <= Bank2RS_in.sos; 
    //         if (Bank2RS_in.sos && !sos_last) begin
    //             sos_cnt <= (sos_cnt == `Num_RS2Vertex_PE-1) ? 0 : sos_cnt + 1'b1;
    //         end
    //     end
    // end

    always_ff @(posedge clk) begin
        if (reset) begin
            RS_buffer.FV_data <= 0;
            RS2Vertex_PE_out.Node_id <= 0;
        end
        else begin
            if (Bank2RS_in.sos || counting) begin
                RS_buffer.FV_data[eos_cnt][boundary +: 2] <= Bank2RS_in.FV_data[1:0];
                RS2Vertex_PE_out.Node_id[eos_cnt] <= Bank2RS_in.Node_id;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            RS2Vertex_PE_out.valid <= 0;
        end
        else begin
            if ((eos_cnt == `Num_RS2Vertex_PE-1) && (Bank2RS_in.eos)) begin
                RS2Vertex_PE_out.valid <= 1;
            end
            else begin
                RS2Vertex_PE_out.valid <= 0;
            end
        end
    end

    assign RS2Vertex_PE_out.FV_data = RS2Vertex_PE_out.valid ? RS_buffer.FV_data : 0;
    
endmodule