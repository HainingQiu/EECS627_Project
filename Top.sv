module Top(
    input clk,
    input reset,
    // output logic[1:0] TB_state
    output logic task_complete
);

 Edge_PE
#(parameter PE_tag = 0)(
input clk,													// global clock
input reset,												// sync active high reset
input DP_task2Edge_PE DP_task2Edge_PE_in,					// dispatch task from command buffer
input FV_SRAM2Edge_PE FV_SRAM2Edge_PE_in,					// feature value from FV SRAM (for current computation)
input Output_SRAM2Edge_PE Output_SRAM2Edge_PE_in,			// feature value from output SRAM (last computation)
input NeighborID_SRAM2Edge_PE NeighborID_SRAM2Edge_PE_in,	// neighbor info from neighbor SRAM
input Grant_Bus_arbiter Grant_Bus_arbiter_in,				// grant request signal
input Grant_output_Bus_arbiter_in,                             // grant output sram req
input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
input Grant_WB_Packet,										// write back packet

output Req_Bus_arbiter Req_Bus_arbiter_out,					// request to arbiter
output Edge_PE2DP Edge_PE2DP_out,							// idle flag output to dispatch
output Edge_PE2IMEM_CNTL Edge_PE2IMEM_CNTL_out,				// packet to IMEM
output logic req_WB_Packet,									// request write back packet
output Edge_PE2Bank Edge_PE2Bank_out,						// aggregated output to bank
output Edge_PE2Req_Output_SRAM Req_Output_SRAM_out
);
//-------------------------PACKET_SRAM_integration--------------//
PACKET_CNTL2SRAM  PACKET_CNTL_SRAM_out;
DP_task2Edge_PE [`Num_Edge_PE-1:0]DP_task2Edge_PE_out;
logic [$clog2(`Max_replay_Iter)-1:0]  Current_replay_Iter;
logic [$clog2(16):0 ]    Num_FV;
logic [$clog2(16)-1:0 ] Weights_boundary;
//------------------------Edge_PE_output------------------------//
Req_Bus_arbiter[`Num_Edge_PE-1:0] Req_Bus_arbiter_out;
Edge_PE2DP[`Num_Edge_PE-1:0] Edge_PE2DP_out;
Edge_PE2IMEM_CNTL[`Num_Edge_PE-1:0] Edge_PE2IMEM_CNTL_out;				// packet to IMEM	
Edge_PE2Bank[`Num_Edge_PE-1:0] Edge_PE2Bank_out;
Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_PE_Req_Output_SRAM_out;
//------------------------Bus_arbiter output-------------------------//
Grant_Bus_arbiter[`Num_Edge_PE-1:0] Grant_Bus_arbiter_out;
BUS2FV_info_FIFO BUS2FV_info_MEM_CNTL_out;
BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_out;
// logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants;
//----------------------FV_info_Integration out-------------------------//
FV_info2FV_FIFO FV_info2FV_FIFO_out;
//----------------------S_FV_SRAM_integration out-------------------------//
FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out;
logic wfull_S_FV_SRAM_integration;
FV_FIFO2FV_info_MEM_CNTL V_FIFO2FV_info_MEM_CNTL_in;
//----------------------Neighbor_info_Integration out----------------------//
Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out;
//----------------------S_Neighbor_SRAM_integration-----------------------//
NeighborID_SRAM2Edge_PE[`Num_Edge_PE-1:0] NeighborID_SRAM2Edge_PE_out;
logic wfull_S_Neighbor_SRAM_integration;
//----------------------Output_Bus_arbiter-----------------------//
logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants;
logic[`Num_Edge_PE-1:0] Grant_output_Bus_arbiter_in;// Output Edge_PE grants
Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] Req2Output_SRAM_Bank_out;
FV_bank_CNTL2Edge_PE [`Num_Banks_all_FV-1:0] EdgePE_rd_out ;
Output_Sram2Arbiter Output_Sram2Arbiter_in;
//------------------------WB_packet arbiter---------------------------//
logic [`Num_Edge_PE+1-1:0] WB_packet_grants;
//-----------------------------Vertex_PE------------------------------//
Vertex2Accu_Bank [`Num_Edge_PE-1:0] vertex_data_pkt;
Weight_Cntl2bank Weight_Cntl2bank_out;
Weight_Cntl2RS Weight_Cntl2RS_out;
logic [`FV_size-1:0] Vertex_output;
logic [$clog2(`Max_Node_id)-1:0] Node_id_out;
//---------------------------Vertex accu buffer------------------------//
Bank_Req2Req_Output_SRAM [`Num_Vertex_Unit-1:0] vertex_outbuff_pkt;
logic Vertex_buffer_empty;
//------------------------Wires------------------------------------------//
logic[`packet_size-1:0] Data_SRAM_in;
logic RS_unavailable, RS_empty;
RS2Vertex_PE RS2Vertex_PE_out;
logic Vertex_complete;
FV_MEM2FV_Bank [`Num_Banks_all_FV-1:0] Big_FV2Sm_FV;
logic [`Num_Edge_PE-1:0] Grant_WB_Packet_edge;
logic Grant_WB_Packet_Decoder;
logic Req_CNTL_Packet;
logic[`Num_Edge_PE-1:0] req_WB_Packet_Edge;
logic[`Num_Edge_PE-1+1:0] reqs_WB_Packet;
Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in;
Bank2RS [`Num_Edge_PE-1:0] RS_pkt_out;
logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex;
Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out;
logic edge_buffer_busy;

for(int i=0;i<`Num_Banks_FV-1;i++)begin
assign Output_Sram2Arbiter_in[i].eos=EdgePE_rd_out[i].eos;
end

assign FV_FIFO2FV_info_MEM_CNTL_in.full=wfull_S_FV_SRAM_integration;
assign WB_packet_grants[0];
logic[`Num_Vertex_Unit-1:0] vertex_buffer_grant;
for(int i=0;i<`Num_Edge_PE;i++)begin
    assign Grant_output_Bus_arbiter_in[i]=Ouput_SRAM_Grants[i];
    assign Grant_WB_Packet_edge[i]=WB_packet_grants[i+1:1];
    assign reqs_WB_Packet[i+1]=req_WB_Packet_Edge[i];
    assign edge_req_grant[i]=Ouput_SRAM_Grants[i+`Num_Edge_PE];
    assign vertex_buffer_grant[i]=Ouput_SRAM_Grants[i+`Num_Edge_PE+`Num_Edge_PE];
end

assign Grant_WB_Packet_Decoder=WB_packet_grants[0];
////////////////////////////////////////////////////////////////////////////
PACKET_SRAM_integration PACKET_SRAM_integration_U(
    .clk(clk),														
    .reset(reset),	
    .grant(Grant_WB_Packet_Decoder),
    .PE_IDLE(Edge_PE2DP_out.IDLE_flag),
    .Edge_PE2IMEM_CNTL_in(Edge_PE2IMEM_CNTL_out), // not connected
    .Data_SRAM_in(Data_SRAM_in),
    .bank_busy(edge_buffer_busy),
    .stream_end(EdgePE_rd_out.eos),
    .vertex_done(Vertex_buffer_empty),
    .task_complete(task_complete),
    .PACKET_CNTL_SRAM_out(PACKET_CNTL_SRAM_out),
    .DP_task2Edge_PE_out(DP_task2Edge_PE_out),
    .Req(reqs_WB_Packet[0]),
    .replay_Iter(Current_replay_Iter),
    .Num_FV(Num_FV),
    .Weights_boundary(Weights_boundary),
    .TB_state(TB_state)
);//----------------------------//
//WIDTH=16 Depth 256 for IMEM_SRAM//
IMEM_SRAM IMEM_SRAM(
    .Q(PACKET_CNTL_SRAM_out.SRAM_DATA),
    .CLK(clk),
    .CEN(0),
    .WEN(PACKET_CNTL_SRAM_out.wen),
    .A(PACKET_CNTL_SRAM_out.SRAM_addr),
    .D(Data_SRAM_in)
);
//--------------------------------------------------------------------Edge_PE-----------------------------------------------------------------//
generate
    genvar i;
    for(i=0;i<`Num_Edge_PE;i=i+1)begin: Edge_PE
        Edge_PE
        #(.PE_tag(i))
        Edge_PE_U(
        .clk(clk),													// global clock
        .reset(reset),												// sync active high reset
        .DP_task2Edge_PE_in(DP_task2Edge_PE_out),					// dispatch task from command buffer
        .FV_SRAM2Edge_PE_in(FV_info2FV_FIFO_out),					// feature value from FV SRAM (for current computation)
        .Output_SRAM2Edge_PE_in(Output_SRAM2Edge_PE_out),			// feature value from output SRAM (last computation)
        .NeighborID_SRAM2Edge_PE_in(NeighborID_SRAM2Edge_PE_out),	// neighbor info from neighbor SRAM
        .Grant_Bus_arbiter_in(Grant_Bus_arbiter_out),				// grant request signal
        .Grant_output_Bus_arbiter_in(Grant_output_Bus_arbiter_in),                             // grant output sram req
        .Cur_Replay_Iter(Current_replay_Iter),		// replay iteration count
        // input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
        .Grant_WB_Packet(Grant_WB_Packet_edge),										// write back packet

        .Req_Bus_arbiter_out(Req_Bus_arbiter_out[i]),			    // request to arbiter
        .Edge_PE2DP_out[Edge_PE2DP_out[i]],							// idle flag output to dispatch
        .Edge_PE2IMEM_CNTL_out(Edge_PE2IMEM_CNTL_out[i]),				// packet to IMEM
        .req_WB_Packet(req_WB_Packet[`Num_Edge_PE-1+1:1]),			// request write back packet
        .Edge_PE2Bank_out(Edge_PE2Bank_out[i]),						// aggregated output to bank
        .Req_Output_SRAM_out(Edge_PE_Req_Output_SRAM_out[i]) 
        );
    end 
endgenerate
//--------------------------------------------------------------------Bus_arbiter--------------------------------------------------------------------------//
Bus_Arbiter Req_Bus_Arbiter_U
(
    .clk(clk),															// global clock
    .reset(reset),														// sync active high reset
    .Req_Bus_arbiter_in(Req_Bus_arbiter_out),			// input request from PE

    .Grant_Bus_arbiter_out(Grant_Bus_arbiter_out),
    .BUS2FV_info_MEM_CNTL_out(BUS2FV_info_MEM_CNTL_out),
    .BUS2Neighbor_info_MEM_CNTL_out(BUS2Neighbor_info_MEM_CNTL_out)
);
//--------------------------------------------------------------------FV_info_Integration-----------------------------------------------------------------//
FV_info_Integration FV_info_Integration_U(
    .clk(clk),
    .reset(reset),
    .FV_FIFO2FV_info_MEM_CNTL_in(V_FIFO2FV_info_MEM_CNTL_in),
    .BUS2FV_info_FIFO_in(BUS2FV_info_MEM_CNTL_out),

    .FV_info2FV_FIFO_out(FV_info2FV_FIFO_out)
);
//--------------------------------------------------------------------S_FV_SRAM_integration-----------------------------------------------------------------//
S_FV_SRAM_integration S_FV_SRAM_integration_U (
    .clk(clk),
    .reset(reset),
	.wdata(FV_info2FV_FIFO_out),
    .Num_FV(Num_FV),
    .FV_MEM2FV_Bank_in(Big_FV2Sm_FV),//from large FV_SRAM

    .FV_SRAM2Edge_PE_out(FV_SRAM2Edge_PE_out),
    .wfull(wfull_S_FV_SRAM_integration)
);

//--------------------------------------------------------------------Neighbor_info_Integration-----------------------------------------------------------------//
Neighbor_info_Integration Neighbor_info_Integration_U(
    .clk(clk),
    .reset(reset),
    .Current_replay_Iter(Current_replay_Iter),
    .Neighbor_CNTL2Neighbor_Info_CNTL_full(wfull_S_Neighbor_SRAM_integration),
    .BUS2Neighbor_info_MEM_CNTL_in(BUS2Neighbor_info_MEM_CNTL_out),

    .Neighbor_info2Neighbor_FIFO_out(Neighbor_info2Neighbor_FIFO_out)
);
//--------------------------------------------------------------------S_Neighbor_SRAM_integration-----------------------------------------------------------------//
S_Neighbor_SRAM_integration S_Neighbor_SRAM_integration_U( 
    .clk(clk),
    .reset(reset),
	.wdata(Neighbor_info2Neighbor_FIFO_out),

    .NeighborID_SRAM2Edge_PE_out(NeighborID_SRAM2Edge_PE_out),
    .wfull(wfull_S_Neighbor_SRAM_integration)
);
//--------------------------------------------------------------------Output_Bus_arbiter-----------------------------------------------------------------//
Output_Bus_arbiter Output_Bus_arbiter_U(
    .clk(clk),
    .reset(reset),
    .Edge_PE2Req_Output_SRAM_in(Edge_PE_Req_Output_SRAM_out),
    .Edge_Bank2Req_Output_SRAM_in(Edge_Bank2Req_Output_SRAM_in),
    .Vertex_Bank2Req_Output_SRAM_in(vertex_outbuff_pkt),
    .Output_Sram2Arbiter(Output_Sram2Arbiter),

    .Req2Output_SRAM_Bank_out(Req2Output_SRAM_Bank_out),
    .Ouput_SRAM_Grants(Ouput_SRAM_Grants)
);
//-------------------------------------Edge_acc_buffer----------------------------------------------//
rr_arbiter 
#(.num_reqs(`Num_Edge_PE+1))
WB_packet_arbiter
(
    .clk(clk),
    .reset(reset),
    .reqs(reqs_WB_Packet),
    .grants(WB_packet_grants)
);

//------------------------------------------Vertex_RS----------------------------------------------//

Vertex_RS  Vertex_RS_U(
    .clk(clk),
    .reset(reset),
    .Bank2RS_in(RS_pkt_out),
    .start_idx(Weight_Cntl2RS_out.Cur_FV_num),
    .Vertex_buf_idle(Vertex_buffer_empty),
    .complete(Vertex_complete), 

    .RS2Vertex_PE_out(RS2Vertex_PE_out),
    .unavailable(RS_unavailable),
    .RS_empty(RS_empty)
);
//------------------------------------------Vertex_PE----------------------------------------------//
generate
    genvar i;
    for(i=0;i<`Num_Vertex_PE;i=i+1)begin: Vertex_PE
    Vertex_PE Vertex_PE_U(
    .clk(clk),
    .reset(reset),
    .Weight_data_in(Weight_data2Vertex),
    .FV_RS(RS2Vertex_PE_out[i].FV_data),
    .Node_id(RS2Vertex_PE_out[i].Node_id),

    .Vertex_output(Vertex_output),
    .Node_id_out(Node_id_out)
);
end 
endgenerate
for(int i=0;i<`Num_Edge_PE;i++)begin
assign vertex_data_pkt[i].data=Vertex_output[i];
assign vertex_data_pkt[i].Node_id=Node_id_out[i];
end
//------------------------------------------------------Weight_CNTL-----------------------------------------//
Weight_CNTL Weight_CNTL_U(
    .clk(clk),
    .reset(reset),
    .Num_Weight_layer(Weights_boundary),//Num_Weight_layer-1
    .Num_FV(Num_FV),
    .fire(RS2Vertex_PE_out.fire), //from RS

    .Weight_data2Vertex(Weight_data2Vertex),
    .Weight_Cntl2RS_out(Weight_Cntl2RS_out),
    .Weight_Cntl2bank_out(Weight_Cntl2bank_out),
    .RS_IDLE(Vertex_complete)
);

Big_FV_wrapper_0 Big_FV_wrapper_0(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(Current_replay_Iter),
    .Cur_Update_Iter('d0),
    .FV_num(Num_FV), 
    .req_pkt(Req2Output_SRAM_Bank_out),

    .Big_FV2Sm_FV(Big_FV2Sm_FV),
    .EdgePE_rd_out(EdgePE_rd_out) 
);
Big_FV_wrapper_1 Big_FV_wrapper_1(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(Current_replay_Iter),
    .Cur_Update_Iter('d0),
    .FV_num(Num_FV), 
    .req_pkt(Req2Output_SRAM_Bank_out),

    .Big_FV2Sm_FV(Big_FV2Sm_FV),
    .EdgePE_rd_out(EdgePE_rd_out) 
);
Output_BUS Output_BUS(
    .clk(clk),
    .reset(reset),
    .Output_bank_CNTL2Edge_PE_in(EdgePE_rd_out),
    .Output_SRAM2Edge_PE_out(Output_SRAM2Edge_PE_out)
);
vertex_buffer vertex_buffer(
    .clk(clk),
    .reset(reset),
    .vertex_data_pkt(vertex_data_pkt), 
    .vertex_cntl_pkt(Weight_Cntl2bank_out),
    .req_grant(vertex_buffer_grant),

    //output logic busy,
    .empty(Vertex_buffer_empty),
    .outbuff_pkt(vertex_outbuff_pkt)
);

edge_buffer edge_buffer(
    .clk(clk),
    .reset(reset),
    .edge_pkt(Edge_PE2Bank_out),
    .req_grant(edge_req_grant),
    .RS_busy(RS_unavailable&&RS_empty),

    .RS_pkt_out(RS_pkt_out),
    .busy(edge_buffer_busy),
    .outbuff_pkt(Edge_Bank2Req_Output_SRAM_in)
);
endmodule