module Vertex_RS (
    input clk,
    input reset,
    input Bank2RS Bank2RS_in,
    input logic [$clog2(`Max_FV_num)-1:0] start_idx,
    input logic Vertex_buf_idle,
    input logic complete, 

    output RS2Vertex_PE RS2Vertex_PE_out,
    output logic unavailable,
    output logic RS_empty
);

    logic [`Num_RS2Vertex_PE-1:0][`Max_FV_num-1:0][`FV_size-1:0] RS_FV_data;
    logic [`Num_RS2Vertex_PE-1:0][$clog2(`Max_Node_id)-1:0] RS_Node_id;

    logic [2:0] count;
    logic counting;

    logic [$clog2(`Num_RS2Vertex_PE):0] eos_cnt;
    logic eos_last; 
    logic [$clog2(`Num_RS2Vertex_PE):0] sos_cnt;
    logic sos_last; 

    logic [3:0] boundary;
    logic RS_ready; // RS is ready to issue, but need Vertex_buf_idle = 1 currently
    logic fire, fire_last;

    assign boundary = count << 1;
    assign RS_empty = complete;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= #1 0;
            counting <= #1 0;
        end else begin
            if (Bank2RS_in.sos) begin
                counting <= #1 1;
                count <= #1 count + 1;
            end
            if (counting) begin
                if (count == 7 || Bank2RS_in.eos) begin
                    count <= #1 0;
                    counting <= #1 0;
                end else begin
                    count <= #1 count + 1;
                end
            end
        end
    end

// Counter the number of eos
    always_ff @(posedge clk) begin
        if (reset) begin
            eos_cnt <= #1 0;
            eos_last <= #1 0;
        end else begin
            eos_last <= #1 Bank2RS_in.eos; 
            if (Bank2RS_in.eos && !eos_last) begin
                eos_cnt <= #1 (eos_cnt == `Num_RS2Vertex_PE-1) ? 0 : eos_cnt + 1;
            end
        end
    end

// Counter the number of sos
    always_ff @(posedge clk) begin
        if (reset) begin
            sos_cnt <= #1 0;
            sos_last <= #1 0;
        end else begin
            sos_last <= #1 Bank2RS_in.sos; 
            if (Bank2RS_in.sos && !sos_last) begin
                sos_cnt <= #1 (sos_cnt == `Num_RS2Vertex_PE-1) ? 0 : sos_cnt + 1'b1;
            end
        end
    end

// Write data into RS
    always_ff @(posedge clk) begin
        if (reset) begin
            RS_FV_data <= #1 0;
            RS_Node_id <= #1 0;
        end
        else begin
            if (Bank2RS_in.sos || counting) begin
                RS_FV_data[eos_cnt][boundary +: 2] <= #1 Bank2RS_in.FV_data[1:0];
                RS_Node_id[eos_cnt] <= #1 Bank2RS_in.Node_id;
            end
        end
    end

// Inform Edge buffer that RS is unavailable once the last entry of RS is being written
    always_ff @(posedge clk) begin
        if (reset) begin
            unavailable <= #1 0;
        end
        else begin
            if ((sos_cnt == `Num_RS2Vertex_PE-1) && (Bank2RS_in.sos)) begin // is the unavailable signal one cycle late? also why does it only last for one cycle
                unavailable <= #1 1;
            end
            else begin
                unavailable <= #1 0;
            end
        end
    end

// Output
    always_ff @(posedge clk) begin
        if (reset) begin
            RS2Vertex_PE_out.FV_data <= #1 0;
            RS2Vertex_PE_out.Node_id <= #1 0;
        end
        else begin
            for (int i=0; i<`Num_RS2Vertex_PE; i=i+1) begin
                RS2Vertex_PE_out.FV_data[i] <= #1 RS_FV_data[i][start_idx +: 2];
            end
            RS2Vertex_PE_out.Node_id <= #1 RS_Node_id;
        end
    end

// Determine if RS is ready for fire
    always @(posedge clk) begin
        if (reset) begin
            RS_ready <= #1 0;
        end
        else begin
            if ((eos_cnt == `Num_RS2Vertex_PE-1) && (Bank2RS_in.eos)) begin
                RS_ready <= #1 1;
            end
            else begin
                if (Bank2RS_in.sos)
                RS_ready <= #1 0;
            end
        end
    end

// Fire when both RS_ready and Vertex_buf_idle
    always @(posedge clk) begin
        if (reset) begin
            fire <= #1 0;
        end
        else begin
            if (RS_ready && Vertex_buf_idle) begin
                fire <= #1 1;
            end
            else begin
                fire <= #1 0;
            end
        end
    end

// Transfer pulse fire to level fire
    always @(posedge clk) begin
        if (reset) begin
            RS2Vertex_PE_out.fire <= #1 0;
            fire_last <= #1 0;
        end else begin
            RS2Vertex_PE_out.fire <= #1 (fire && !fire_last);
            fire_last <= #1 fire;
        end
    end

endmodule