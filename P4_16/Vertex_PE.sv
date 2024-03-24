module Vertex_PE(
    input clk,
    input reset,
    // input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    input [`FV_size-1:0] Weight_data_in_0,
    input [`FV_size-1:0] Weight_data_in_1,
    // input [`FV_size-1:0] Weight_data_in_2,
    // input [`FV_size-1:0] Weight_data_in_3,

    // input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
        // input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    input [`FV_size-1:0] FV_RS_0,
    input [`FV_size-1:0] FV_RS_1,
    // input [`FV_size-1:0] FV_RS_2,
    // input [`FV_size-1:0] FV_RS_3,

    input [$clog2(`Max_Node_id)-1:0] Node_id,

    output logic [`FV_size-1:0] Vertex_output,
    output logic [$clog2(`Max_Node_id)-1:0] Node_id_out
);
logic[`FV_size-1:0] nx_vertex_output;
logic [`Mult_per_PE-1:0][`FV_size-1:0] Mul_output;
logic [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in;
logic [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS;
assign Weight_data_in[0]=Weight_data_in_0;
assign Weight_data_in[1]=Weight_data_in_1;


always_comb begin
    Mul_output='d0;
    for(int i=0;i<`Mult_per_PE;i++)begin
        Mul_output[i]=Weight_data_in[i]*FV_RS[i];
    end
    for(int i=0;i<`Mult_per_PE-1;i++)begin
        nx_vertex_output=Mul_output[i]+Mul_output[i+1];
    end
end
always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
        Vertex_output<=#1 'd0;
        Node_id_out<=#1 'd0;
    end
    else begin
        Vertex_output<=#1 nx_vertex_output;
        Node_id_out<=#1 Node_id;
    end
end
endmodule