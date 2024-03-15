

module vertex_buffer(
    input clk, reset,
    // input Vertex2Accu_Bank [`Num_Vertex_Unit-1:0] vertex_data_pkt, 
    input [`FV_size-1:0] vertex_data_pkt_0_data,
    input [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_0_Node_id,

    input [`FV_size-1:0] vertex_data_pkt_1_data,
    input [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_1_Node_id,

    input [`FV_size-1:0] vertex_data_pkt_2_data,
    input [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_2_Node_id,

    input [`FV_size-1:0] vertex_data_pkt_3_data,
    input [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_3_Node_id,

    // input Weight_Cntl2bank  vertex_cntl_pkt,
    input Weight_Cntl2bank_sos,
    input Weight_Cntl2bank_eos,
    input Weight_Cntl2bank_change,

    input logic [`Num_Vertex_Unit-1:0] req_grant,

    output logic empty,
    // output Bank_Req2Req_Output_SRAM [`Num_Vertex_Unit-1:0] outbuff_pkt
    output logic outbuff_pkt_0_Grant_valid,
    output logic outbuff_pkt_0_sos,
    output logic outbuff_pkt_0_eos,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_0_data,
    output logic outbuff_pkt_0_req,
    output logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_0_Node_id,

    output logic outbuff_pkt_1_Grant_valid,
    output logic outbuff_pkt_1_sos,
    output logic outbuff_pkt_1_eos,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_1_data,
    output logic outbuff_pkt_1_req,
    output logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_1_Node_id,

    output logic outbuff_pkt_2_Grant_valid,
    output logic outbuff_pkt_2_sos,
    output logic outbuff_pkt_3_eos,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_2_data,
    output logic outbuff_pkt_2_req,
    output logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_2_Node_id,

    output logic outbuff_pkt_3_Grant_valid,
    output logic outbuff_pkt_3_sos,
    output logic outbuff_pkt_3_eos,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_3_data,
    output logic outbuff_pkt_3_req,
    output logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_3_Node_id
);
Vertex2Accu_Bank [`Num_Vertex_Unit-1:0] vertex_data_pkt;
Weight_Cntl2bank  vertex_cntl_pkt;
Bank_Req2Req_Output_SRAM [`Num_Vertex_Unit-1:0] outbuff_pkt;
assign vertex_data_pkt[0].data=vertex_data_pkt_0_data;
assign vertex_data_pkt[0].Node_id=vertex_data_pkt_0_Node_id;

assign vertex_data_pkt[1].data=vertex_data_pkt_1_data;
assign vertex_data_pkt[1].Node_id=vertex_data_pkt_1_Node_id;

assign vertex_data_pkt[2].data=vertex_data_pkt_2_data;
assign vertex_data_pkt[2].Node_id=vertex_data_pkt_2_Node_id;

assign vertex_data_pkt[3].data=vertex_data_pkt_3_data;
assign vertex_data_pkt[3].Node_id=vertex_data_pkt_3_Node_id;

assign vertex_cntl_pkt.sos=Weight_Cntl2bank_sos;
assign vertex_cntl_pkt.eos=Weight_Cntl2bank_eos;
assign vertex_cntl_pkt.change=Weight_Cntl2bank_change;

assign outbuff_pkt_0_Grant_valid=outbuff_pkt[0].Grant_valid;
assign outbuff_pkt_0_sos=outbuff_pkt[0].sos;
assign outbuff_pkt_0_eos=outbuff_pkt[0].eos;
assign outbuff_pkt_0_data=outbuff_pkt[0].data;
assign outbuff_pkt_0_req=outbuff_pkt[0].req;
assign outbuff_pkt_0_Node_id=outbuff_pkt[0].Node_id;

assign outbuff_pkt_1_Grant_valid=outbuff_pkt[1].Grant_valid;
assign outbuff_pkt_1_sos=outbuff_pkt[1].sos;
assign outbuff_pkt_1_eos=outbuff_pkt[1].eos;
assign outbuff_pkt_1_data=outbuff_pkt[1].data;
assign outbuff_pkt_1_req=outbuff_pkt[1].req;
assign outbuff_pkt_1_Node_id=outbuff_pkt[1].Node_id;

assign outbuff_pkt_2_Grant_valid=outbuff_pkt[2].Grant_valid;
assign outbuff_pkt_2_sos=outbuff_pkt[2].sos;
assign outbuff_pkt_2_eos=outbuff_pkt[2].eos;
assign outbuff_pkt_2_data=outbuff_pkt[2].data;
assign outbuff_pkt_2_req=outbuff_pkt[2].req;
assign outbuff_pkt_2_Node_id=outbuff_pkt[2].Node_id;

assign outbuff_pkt_3_Grant_valid=outbuff_pkt[3].Grant_valid;
assign outbuff_pkt_3_sos=outbuff_pkt[3].sos;
assign outbuff_pkt_3_eos=outbuff_pkt[3].eos;
assign outbuff_pkt_3_data=outbuff_pkt[3].data;
assign outbuff_pkt_3_req=outbuff_pkt[3].req;
assign outbuff_pkt_3_Node_id=outbuff_pkt[3].Node_id;
logic[`Num_Vertex_Unit-1:0] bank_busy;
    // assign busy = |bank_busy;
    assign empty = ~|bank_busy;

    generate
        genvar i;
        for (i = 0; i < `Num_Vertex_Unit; i++) begin:vertex_buffer_one_DUT
            vertex_buffer_one buffer2 (
                .clk(clk),
                .reset(reset),
                .vertex_data_pkt(vertex_data_pkt[i]), 
                .vertex_cntl_pkt(vertex_cntl_pkt),
                .req_grant(req_grant[i]),
               
                .bank_busy(bank_busy[i]),
                .outbuff_pkt(outbuff_pkt[i])
            );
        end 
    endgenerate

endmodule