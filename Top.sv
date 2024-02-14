module Top(
    input clk,
    input reset,
    output logic[1:0] TB_state
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
logic [$clog2(16)-1:0 ]    Num_FV;
//------------------------Edge_PE_output------------------------//
Req_Bus_arbiter[`Num_Edge_PE-1:0] Req_Bus_arbiter_out;
Edge_PE2DP[`Num_Edge_PE-1:0] Edge_PE2DP_out;
Edge_PE2IMEM_CNTL[`Num_Edge_PE-1:0] Edge_PE2IMEM_CNTL_out;				// packet to IMEM	
Edge_PE2Bank Edge_PE2Bank_out;
//------------------------Bus_arbiter output-------------------------//
Grant_Bus_arbiter[`Num_Edge_PE-1:0] Grant_Bus_arbiter_out;
BUS2FV_info_FIFO BUS2FV_info_MEM_CNTL_out;
BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_out;
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
//------------------------WB_packet arbiter---------------------------//
logic [`Num_Edge_PE+1-1:0] WB_packet_grants;

//------------------------Wires------------------------------------------//
logic [`Num_Edge_PE-1:0] Grant_WB_Packet_edge;
logic Grant_WB_Packet_Decoder;
logic Req_CNTL_Packet;
logic[`Num_Edge_PE-1:0] req_WB_Packet_Edge;
logic[`Num_Edge_PE-1+1:0] reqs_WB_Packet;
Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in;
Bank2RS [`Num_Edge_PE-1:0] rs_pkt;
logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex;


assign FV_FIFO2FV_info_MEM_CNTL_in.full=wfull_S_FV_SRAM_integration;
assign WB_packet_grants[0];
for(int i=0;i<`Num_Edge_PE;i++)begin
    assign Grant_output_Bus_arbiter_in[i]=Ouput_SRAM_Grants[i];
    assign Grant_WB_Packet_edge[i]=WB_packet_grants[i+1:1];
    assign reqs_WB_Packet[i+1]=req_WB_Packet_Edge[i];
end

assign Grant_WB_Packet_Decoder=WB_packet_grants[0];
////////////////////////////////////////////////////////////////////////////
PACKET_SRAM_integration PACKET_SRAM_integration_U(
    .clk(clk),														
    .reset(reset),	
    .grant(Grant_WB_Packet_Decoder),
    .PE_IDLE(Edge_PE2DP_out.IDLE_flag),
    .Edge_PE2IMEM_CNTL_in(Edge_PE2IMEM_CNTL_out), // not connected
    input [`packet_size-1:0] Data_SRAM_in,
    .PACKET_CNTL_SRAM_out(PACKET_CNTL_SRAM_out),
    .DP_task2Edge_PE_out(DP_task2Edge_PE_out),
    .Req(reqs_WB_Packet[0]),
    .replay_Iter(Current_replay_Iter),
    .Num_FV(Num_FV),
    output logic [$clog2(16)-1:0 ] Weights_boundary,
    .TB_state(TB_state)
);//----------------------------//
//WIDTH=16 Depth 256 for IMEM_SRAM//
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
        .FV_SRAM2Edge_PE_in(FV_SRAM2Edge_PE_out),					// feature value from FV SRAM (for current computation)
        input Output_SRAM2Edge_PE Output_SRAM2Edge_PE_in,			// feature value from output SRAM (last computation)
        .NeighborID_SRAM2Edge_PE_in(NeighborID_SRAM2Edge_PE_out),	// neighbor info from neighbor SRAM
        .Grant_Bus_arbiter_in(Grant_Bus_arbiter_out),				// grant request signal
        .Grant_output_Bus_arbiter_in(),                             // grant output sram req
        input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,		// replay iteration count
        // input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
        .Grant_WB_Packet(Grant_WB_Packet_edge),										// write back packet

        .Req_Bus_arbiter_out(Req_Bus_arbiter_out[i]),			    // request to arbiter
        .Edge_PE2DP_out[Edge_PE2DP_out[i]],							// idle flag output to dispatch
        .Edge_PE2IMEM_CNTL_out(Edge_PE2IMEM_CNTL_out[i]),				// packet to IMEM
        .req_WB_Packet(req_WB_Packet[`Num_Edge_PE-1+1:1]),			// request write back packet
        output Edge_PE2Bank Edge_PE2Bank_out,						// aggregated output to bank
        output Edge_PE2Req_Output_SRAM Req_Output_SRAM_out  
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
    input FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0]  FV_MEM2FV_Bank_in,//from large FV_SRAM

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
    input Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0]  Edge_PE2Req_Output_SRAM_in,
    .Edge_Bank2Req_Output_SRAM_in(Edge_Bank2Req_Output_SRAM_in),
    input Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Vertex_Bank2Req_Output_SRAM_in,
    input Output_Sram2Arbiter[`Num_Banks_FV-1:0] Output_Sram2Arbiter,

    .Req2Output_SRAM_Bank_out(Req2Output_SRAM_Bank_out),
    output logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants
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

// acc_buffer Edge_acc_buffer(
//     .clk(clk),
//     .reset(reset),
//     .edge_pkt(Edge_PE2Bank_out),
//     input logic [`Num_Edge_PE-1:0] req_grant,

//     output Bank2RS [`Num_Edge_PE-1:0] rs_pkt, // TODO: might need to chagne the parameter here
//     .outbuff_pkt(Edge_Bank2Req_Output_SRAM_in)
// );

// Big_FV_wrapper Big_FV_wrapper_U(
//     .clk(clk),
//     .reset(reset),
//     .Cur_Replay_Iter(Current_replay_Iter),
//     .Cur_Update_Iter('d0),
//     input [$clog2(Max_FV_num)-1:0] FV_num, 

//     output FV_MEM2FV_Bank [`Num_Banks_all_FV-1:0] Big_FV2Sm_FV, 
// );
//------------------------------------------Vertex_RS----------------------------------------------//


//------------------------------------------Vertex_PE----------------------------------------------//
generate
    genvar i;
    for(i=0;i<`Num_Vertex_PE;i=i+1)begin: Vertex_PE
    Vertex_PE Vertex_PE_U(
    .clk(clk),
    .reset(reset),
    .Weight_data_in(Weight_data2Vertex),
    input [`Mult_per_PE-1:0][FV_size-1:0] FV_RS,
    input [$clog2(`Max_Node_id)-1:0] Node_id,

    output logic [`FV_size-1:0] Vertex_output,
    output logic [$clog2(`Max_Node_id)-1:0] Node_id_out
);
    end 
endgenerate
//------------------------------------------------------Weight_CNTL-----------------------------------------//
Weight_CNTL Weight_CNTL_U(
    .clk(clk),
    .reset(reset),
    input[$clog2(`Max_Num_Weight_layer)-1:0] Num_Weight_layer,//Num_Weight_layer-1
    .Num_FV(Num_FV),
    input fire, //from RS

    .Weight_data2Vertex(Weight_data2Vertex),
    output Weight_Cntl2RS Weight_Cntl2RS_out,
    output Weight_Cntl2bank Weight_Cntl2bank_out,
    output logic RS_IDLE
);

Big_FV_wrapper Big_FV_wrapper(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(Current_replay_Iter),
    .Cur_Update_Iter('d0),
    .FV_num(Num_FV), 
    .req_pkt(Req2Output_SRAM_Bank_out),

    output FV_MEM2FV_Bank [`Num_Banks_all_FV-1:0] Big_FV2Sm_FV,
    output FV_bank_CNTL2Edge_PE [`Num_Banks_all_FV-1:0] EdgePE_rd_out 
);
vertex_buffer vertex_buffer(
    .clk(clk),
    .reset(reset),
    input Vertex_PE2Bank [`Num_Edge_PE-1:0] vertex_data_pkt, 
    input Weight_Cntl2bank [`Num_Edge_PE-1:0] vertex_cntl_pkt,
    input logic [`Num_Edge_PE-1:0] req_grant,

    output logic busy,
    output logic empty,
    output Bank2out_buff [`Num_Edge_PE-1:0] outbuff_pkt
);

edge_buffer edge_buffer(
    .clk(clk),
    .reset(reset),
    input Edge_PE2Bank [`Num_Edge_PE-1:0] edge_pkt,
    input [`Num_Edge_PE-1:0] req_grant,
    input RS_busy,

    output Bank2RS RS_pkt_out,
    output logic busy,
    output Bank2out_buff [`Num_Edge_PE-1:0] outbuff_pkt
);
endmodule