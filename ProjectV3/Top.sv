module Top(
    input clk,
    input reset,
    output logic task_complete
);

// //-------------------------PACKET_SRAM_integration--------------//
// PACKET_CNTL2SRAM  PACKET_CNTL_SRAM_out;
// DP_task2Edge_PE [`Num_Edge_PE-1:0]DP_task2Edge_PE_out;
// logic [$clog2(`Max_replay_Iter)-1:0]  Current_replay_Iter;
// logic [$clog2(`MAX_FV_num):0 ]    Num_FV;
// logic [$clog2(`Max_Num_Weight_layer)-1:0 ] Weights_boundary;
// //------------------------Edge_PE_output------------------------//
// Req_Bus_arbiter[`Num_Edge_PE-1:0] Req_Bus_arbiter_out;
// Edge_PE2DP[`Num_Edge_PE-1:0] Edge_PE2DP_out;
// Edge_PE2IMEM_CNTL[`Num_Edge_PE-1:0] Edge_PE2IMEM_CNTL_out;				// packet to IMEM	
// Edge_PE2Bank[`Num_Edge_PE-1:0] Edge_PE2Bank_out;
// Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_PE_Req_Output_SRAM_out;
// //------------------------Bus_arbiter output-------------------------//
// Grant_Bus_arbiter[`Num_Edge_PE-1:0] Grant_Bus_arbiter_out;
// BUS2FV_info_FIFO BUS2FV_info_MEM_CNTL_out;
// BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_out;
// // logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants;
// //----------------------FV_info_Integration out-------------------------//
// FV_info2FV_FIFO FV_info2FV_FIFO_out;
// //----------------------S_FV_SRAM_integration out-------------------------//
// FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out;
// logic wfull_S_FV_SRAM_integration;

// FV_FIFO2FV_info_MEM_CNTL FV_FIFO2FV_info_MEM_CNTL_in;
// //----------------------Neighbor_info_Integration out----------------------//
// Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out;
// //----------------------S_Neighbor_SRAM_integration-----------------------//
// NeighborID_SRAM2Edge_PE[`Num_Edge_PE-1:0] NeighborID_SRAM2Edge_PE_out;
// logic wfull_S_Neighbor_SRAM_integration;
// //----------------------Output_Bus_arbiter-----------------------//
// logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants;
// logic[`Num_Edge_PE-1:0] Grant_output_Bus_arbiter_in;// Output Edge_PE grants
// Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] Req2Output_SRAM_Bank_out;
// FV_bank_CNTL2Edge_PE [`Num_Banks_all_FV-1:0] EdgePE_rd_out ;
// Output_Sram2Arbiter[`Num_Edge_PE-1:0] Output_Sram2Arbiter_in;
// //------------------------WB_packet arbiter---------------------------//
// logic [`Num_Edge_PE+1-1:0] WB_packet_grants;
// //-----------------------------Vertex_PE------------------------------//
// Vertex2Accu_Bank [`Num_Edge_PE-1:0] vertex_data_pkt;
// Weight_Cntl2bank Weight_Cntl2bank_out;
// Weight_Cntl2RS Weight_Cntl2RS_out;
// logic [`Num_Vertex_Unit-1:0][`FV_size-1:0] Vertex_output;
// logic [`Num_Vertex_Unit-1:0][$clog2(`Max_Node_id)-1:0] Node_id_out;
// //---------------------------Vertex accu buffer------------------------//
// Bank_Req2Req_Output_SRAM [`Num_Vertex_Unit-1:0] vertex_outbuff_pkt;
// logic Vertex_buffer_empty;
// //------------------------Wires------------------------------------------//
// logic stream_begin;
// logic[`packet_size-1:0] Data_SRAM_in;
// logic RS_fire;
// // logic RS_unavailable, RS_empty;
// logic RS_available;
// RS2Vertex_PE RS2Vertex_PE_out;
// logic [`Num_RS2Vertex_PE-1:0][`Mult_per_PE-1:0][`FV_size-1:0] FV_data;
// logic [`Num_RS2Vertex_PE-1:0][$clog2(`Max_Node_id)-1:0] Node_id;
// logic Vertex_complete;
// FV_MEM2FV_Bank [`Num_Banks_all_FV-1:0] Big_FV2Sm_FV;
// logic [`Num_Edge_PE-1:0] Grant_WB_Packet_edge;
// logic Grant_WB_Packet_Decoder;
// logic Req_CNTL_Packet;
// logic[`Num_Edge_PE-1:0] req_WB_Packet_Edge;
// logic[`Num_Edge_PE-1+1:0] reqs_WB_Packet;
// Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in;
// Bank2RS  RS_pkt_out;
// logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex;
// Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out;
// logic [`Num_Edge_PE-1:0]edge_buffer_busy;
// logic [`Num_Edge_PE-1:0]edge_req_grant;
// logic [`Num_Vertex_Unit-1:0] vertex_buffer_grant;
// logic[`Num_Edge_PE-1:0] PE_IDLE;
// logic stream_end;
// FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0] Big_FV2Sm_FV_1;
// FV_bank_CNTL2Edge_PE[`Num_Banks_all_FV-1:0] EdgePE_rd_out_0;

// logic outbuff_available;
// logic inbuff_available;
// logic Vertex_RS_empty;

// always_comb begin
// stream_end='d1;
//     for(int j=0;j<`Num_Banks_FV;j++)begin
//          Output_Sram2Arbiter_in[j].eos=EdgePE_rd_out[j].eos;
//          stream_end=stream_end&Big_FV2Sm_FV[j].eos;
//     end

//     for(int i=0;i<`Num_Edge_PE;i++)begin
//         Grant_output_Bus_arbiter_in[i]=Ouput_SRAM_Grants[i];
//         Grant_WB_Packet_edge[i]=WB_packet_grants[i+1];
//         reqs_WB_Packet[i+1]=req_WB_Packet_Edge[i];
//         edge_req_grant[i]=Ouput_SRAM_Grants[i+`Num_Edge_PE];
//         PE_IDLE[i]=Edge_PE2DP_out[i].IDLE_flag;
        
//     end
//     for(int l=0;l<`Num_Vertex_Unit;l++)begin
//         vertex_buffer_grant[l]=Ouput_SRAM_Grants[l+`Num_Edge_PE+`Num_Edge_PE];
//         FV_data[l]=RS2Vertex_PE_out.FV_data[l];
//         Node_id[l]=RS2Vertex_PE_out.Node_id[l];
//     end

//     for(int k=0;k<`Num_Edge_PE;k++)begin
//         vertex_data_pkt[k].data=Vertex_output[k];
//         vertex_data_pkt[k].Node_id=Node_id_out[k];
//     end

// end

// assign FV_FIFO2FV_info_MEM_CNTL_in.full=wfull_S_FV_SRAM_integration;

// assign Grant_WB_Packet_Decoder=WB_packet_grants[0];
////////////////////////////////////////////////////////////////////////////
// PACKET_SRAM_integration PACKET_SRAM_integration_U(
//     .clk(clk),														
//     .reset(reset),	
//     .grant(Grant_WB_Packet_Decoder),
//     .PE_IDLE(PE_IDLE),
//     .Edge_PE2IMEM_CNTL_in(Edge_PE2IMEM_CNTL_out), // not connected
//     // .Data_SRAM_in(Data_SRAM_in),
//     .bank_busy(edge_buffer_busy),
//     .stream_end(stream_end),
//     .vertex_done(Vertex_buffer_empty&&Vertex_RS_empty),
//     .outbuff_available(outbuff_available),
//     .task_complete(task_complete),
//     // .PACKET_CNTL_SRAM_out(PACKET_CNTL_SRAM_out),
//     .DP_task2Edge_PE_out(DP_task2Edge_PE_out),
//     .Req(reqs_WB_Packet[0]),
//     .replay_Iter(Current_replay_Iter),
//     .Num_FV(Num_FV),
//     .Weights_boundary(Weights_boundary),
//     .stream_begin(stream_begin)
    
// );//----------------------------//
logic[`packet_size-1:0] Edge_PE2IMEM_CNTL_out_0_packet;
logic[`packet_size-1:0] Edge_PE2IMEM_CNTL_out_1_packet;
logic[`packet_size-1:0] Edge_PE2IMEM_CNTL_out_2_packet;
logic[`packet_size-1:0] Edge_PE2IMEM_CNTL_out_3_packet;
logic [`Num_Edge_PE-1:0]  Edge_PE2IMEM_CNTL_in_valid;
logic Edge_PE2IMEM_CNTL_out_0_valid;
logic Edge_PE2IMEM_CNTL_out_1_valid;
logic Edge_PE2IMEM_CNTL_out_2_valid;
logic Edge_PE2IMEM_CNTL_out_3_valid;
logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_0;
logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_1;
logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_2;
logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_3;
logic [`Num_Edge_PE-1:0] DP_task2Edge_PE_out_valid;
logic Req_Bus_arbiter_out_0_req;
logic[$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_out_0_PE_tag;
logic Req_Bus_arbiter_out_0_req_type,;
logic[$clog2(`Max_Node_id)-1:0] Req_Bus_arbiter_out_0_Node_id;	

logic Req_Bus_arbiter_out_1_req;
logic[$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_out_1_PE_tag;
logic Req_Bus_arbiter_out_1_req_type,;
logic[$clog2(`Max_Node_id)-1:0] Req_Bus_arbiter_out_1_Node_id;	

logic Req_Bus_arbiter_out_2_req;
logic[$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_out_2_PE_tag;
logic Req_Bus_arbiter_out_2_req_type,;
logic[$clog2(`Max_Node_id)-1:0] Req_Bus_arbiter_out_2_Node_id;	

logic Req_Bus_arbiter_out_3_req;
logic[$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_out_3_PE_tag;
logic Req_Bus_arbiter_out_3_req_type,;
logic[$clog2(`Max_Node_id)-1:0] Req_Bus_arbiter_out_3_Node_id;	

logic Grant_Bus_arbiter_out_0_Grant;
logic Grant_Bus_arbiter_out_1_Grant;
logic Grant_Bus_arbiter_out_2_Grant;
logic Grant_Bus_arbiter_out_3_Grant;

logic BUS2FV_info_MEM_CNTL_out_valid;
logic [$clog2(`Max_Node_id)-1:0] BUS2FV_info_MEM_CNTL_out_Node_id;
logic [$clog2(`Num_Edge_PE)-1:0] BUS2FV_info_MEM_CNTL_out_PE_tag;

logic BUS2Neighbor_info_MEM_CNTL_out_valid;
logic [$clog2(`Max_Node_id)-1:0] BUS2Neighbor_info_MEM_CNTL_out_Node_id;
logic [$clog2(`Num_Edge_PE)-1:0] BUS2Neighbor_info_MEM_CNTL_out_PE_tag;

logic FV_FIFO2FV_info_MEM_CNTL_in_full;

logic FV_info2FV_FIFO_out_valid;
logic [`FV_info_bank_width-1:0] FV_info2FV_FIFO_out_FV_addr;
logic [$clog2(`Num_Edge_PE)-1:0] FV_info2FV_FIFO_out_PE_tag;

logic FV_SRAM2Edge_PE_out_0_sos;
logic FV_SRAM2Edge_PE_out_0_eos;
logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_0_FV_data;

logic FV_SRAM2Edge_PE_out_1_sos;
logic FV_SRAM2Edge_PE_out_1_eos;
logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_1_FV_data;

logic FV_SRAM2Edge_PE_out_2_sos;
logic FV_SRAM2Edge_PE_out_2_eos;
logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_2_FV_data;

logic FV_SRAM2Edge_PE_out_3_sos;
logic FV_SRAM2Edge_PE_out_3_eos;
logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_3_FV_data;

assign Edge_PE2IMEM_CNTL_in_valid[0]=Edge_PE2IMEM_CNTL_out_0_valid;
assign Edge_PE2IMEM_CNTL_in_valid[1]=Edge_PE2IMEM_CNTL_out_1_valid;
assign Edge_PE2IMEM_CNTL_in_valid[2]=Edge_PE2IMEM_CNTL_out_2_valid;
assign Edge_PE2IMEM_CNTL_in_valid[3]=Edge_PE2IMEM_CNTL_out_3_valid;


PACKET_SRAM_integration PACKET_SRAM_integration_U(
    .clk(clk),														
    .reset(reset),	
    .grant(Grant_WB_Packet_Decoder),
    .PE_IDLE(PE_IDLE),
    .Edge_PE2IMEM_CNTL_in_packet_0(Edge_PE2IMEM_CNTL_out_0_packet),
    .Edge_PE2IMEM_CNTL_in_packet_1(Edge_PE2IMEM_CNTL_out_1_packet),
    .Edge_PE2IMEM_CNTL_in_packet_2(Edge_PE2IMEM_CNTL_out_2_packet),
    .Edge_PE2IMEM_CNTL_in_packet_3(Edge_PE2IMEM_CNTL_out_3_packet),
    .Edge_PE2IMEM_CNTL_in_valid(Edge_PE2IMEM_CNTL_in_valid),
    input [`Num_Edge_PE-1:0]bank_busy,
    input stream_end,
    input vertex_done,
    input outbuff_available,

    output logic task_complete,

    .DP_task2Edge_PE_out_packet_0(DP_task2Edge_PE_out_packet_0),
    .DP_task2Edge_PE_out_packet_1(DP_task2Edge_PE_out_packet_1),
    .DP_task2Edge_PE_out_packet_2(DP_task2Edge_PE_out_packet_2),
    .DP_task2Edge_PE_out_packet_3(DP_task2Edge_PE_out_packet_3),
    .DP_task2Edge_PE_out_valid(DP_task2Edge_PE_out_valid),
    output logic Req,
    output logic [$clog2(`Max_replay_Iter)-1:0]  replay_Iter,
    output logic [$clog2(`MAX_FV_num):0 ]    Num_FV ,
    output logic [$clog2(`Max_Num_Weight_layer)-1:0 ] Weights_boundary,
    output logic stream_begin
);

//--------------------------------------------------------------------Edge_PE-----------------------------------------------------------------//
Edge_PE
#(.PE_tag(0))
Edge_PE_0(
    .clk(clk),													// global clock
    .reset(reset),												// sync active high reset
    .DP_task2Edge_PE_in_packet(DP_task2Edge_PE_out_packet_0),					// dispatch task from command buffer
    .DP_task2Edge_PE_in_valid(DP_task2Edge_PE_out_valid[0]),	
    .FV_SRAM2Edge_PE_in_sos(FV_SRAM2Edge_PE_out_0_sos),					// feature value from FV SRAM (for current computation)
    .FV_SRAM2Edge_PE_in_eos(FV_SRAM2Edge_PE_out_0_eos),	
    .FV_SRAM2Edge_PE_in_FV_data(FV_SRAM2Edge_PE_out_0_FV_data),	
input Output_SRAM2Edge_PE_in_sos,			// feature value from output SRAM (last computation)
input Output_SRAM2Edge_PE_in_eos,	
input [`FV_bandwidth-1:0] Output_SRAM2Edge_PE_in_FV_data,	

input NeighborID_SRAM2Edge_PE_in_sos,	// neighbor info from neighbor SRAM
input NeighborID_SRAM2Edge_PE_in_eos,
input [$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter,
input [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_ids,

    .Grant_Bus_arbiter_in(Grant_Bus_arbiter_out_0_Grant),				// grant request signal
input Grant_output_Bus_arbiter_in,                             // grant output sram req
input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
input Grant_WB_Packet,										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_0_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_0_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_0_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_0_Node_id),			

output logic Edge_PE2DP_out,							// idle flag output to dispatch
.Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_0_packet),				// packet to IMEM
.Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_0_valid),		

output logic req_WB_Packet,									// request write back packet

output logic Edge_PE2Bank_out_sos, // start of streaming
output logic Edge_PE2Bank_out_eos,//  end of streaming
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_0,//64/16
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_1,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_2,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_3,
output logic Edge_PE2Bank_out_Done_aggr,
output logic Edge_PE2Bank_out_WB_en,
output logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Bank_out_Node_id,
				// aggregated output to bank
output logic Req_Output_SRAM_out_Grant_valid,
output logic[$clog2(`Num_Edge_PE)-1:0] Req_Output_SRAM_out_PE_tag,
output logic Req_Output_SRAM_out_req,
output logic[$clog2(`Max_Node_id)-1:0]Req_Output_SRAM_out_Node_id
);

Edge_PE
#(.PE_tag(1))
Edge_PE_1(
    .clk(clk),													// global clock
    .reset(reset),												// sync active high reset
    .DP_task2Edge_PE_in_packet(DP_task2Edge_PE_out_packet_1),					// dispatch task from command buffer
    .DP_task2Edge_PE_in_valid(DP_task2Edge_PE_out_valid[1]),

    .FV_SRAM2Edge_PE_in_sos(FV_SRAM2Edge_PE_out_1_sos),					// feature value from FV SRAM (for current computation)
    .FV_SRAM2Edge_PE_in_eos(FV_SRAM2Edge_PE_out_1_eos),	
    .FV_SRAM2Edge_PE_in_FV_data(FV_SRAM2Edge_PE_out_1_FV_data),

input Output_SRAM2Edge_PE_in_sos,			// feature value from output SRAM (last computation)
input Output_SRAM2Edge_PE_in_eos,	
input [`FV_bandwidth-1:0] Output_SRAM2Edge_PE_in_FV_data,	

input NeighborID_SRAM2Edge_PE_in_sos,	// neighbor info from neighbor SRAM
input NeighborID_SRAM2Edge_PE_in_eos,
input [$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter,
input [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_ids,

    .Grant_Bus_arbiter_in(Grant_Bus_arbiter_out_1_Grant),				// grant request signal
input Grant_output_Bus_arbiter_in,                             // grant output sram req
input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
input Grant_WB_Packet,										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_1_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_1_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_1_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_1_Node_id),			


output logic Edge_PE2DP_out,							// idle flag output to dispatch
.Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_1_packet),				// packet to IMEM
.Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_1_valid),	

output logic req_WB_Packet,									// request write back packet

output logic Edge_PE2Bank_out_sos, // start of streaming
output logic Edge_PE2Bank_out_eos,//  end of streaming
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_0,//64/16
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_1,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_2,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_3,
output logic Edge_PE2Bank_out_Done_aggr,
output logic Edge_PE2Bank_out_WB_en,
output logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Bank_out_Node_id,
				// aggregated output to bank
output logic Req_Output_SRAM_out_Grant_valid,
output logic[$clog2(`Num_Edge_PE)-1:0] Req_Output_SRAM_out_PE_tag,
output logic Req_Output_SRAM_out_req,
output logic[$clog2(`Max_Node_id)-1:0]Req_Output_SRAM_out_Node_id
);
Edge_PE
#(.PE_tag(2))
Edge_PE_2(
    .clk(clk),													// global clock
    .reset(reset),												// sync active high reset
    .DP_task2Edge_PE_in_packet(DP_task2Edge_PE_out_packet_2),					// dispatch task from command buffer
    .DP_task2Edge_PE_in_valid(DP_task2Edge_PE_out_valid[2]),	

    .FV_SRAM2Edge_PE_in_sos(FV_SRAM2Edge_PE_out_2_sos),					// feature value from FV SRAM (for current computation)
    .FV_SRAM2Edge_PE_in_eos(FV_SRAM2Edge_PE_out_2_eos),	
    .FV_SRAM2Edge_PE_in_FV_data(FV_SRAM2Edge_PE_out_2_FV_data),	

input Output_SRAM2Edge_PE_in_sos,			// feature value from output SRAM (last computation)
input Output_SRAM2Edge_PE_in_eos,	
input [`FV_bandwidth-1:0] Output_SRAM2Edge_PE_in_FV_data,	

input NeighborID_SRAM2Edge_PE_in_sos,	// neighbor info from neighbor SRAM
input NeighborID_SRAM2Edge_PE_in_eos,
input [$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter,
input [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_ids,

    .Grant_Bus_arbiter_in(Grant_Bus_arbiter_out_2_Grant),				// grant request signal
input Grant_output_Bus_arbiter_in,                             // grant output sram req
input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
input Grant_WB_Packet,										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_2_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_2_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_2_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_2_Node_id),			


output logic Edge_PE2DP_out,							// idle flag output to dispatch
.Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_2_packet),				// packet to IMEM
.Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_2_valid),	

output logic req_WB_Packet,									// request write back packet

output logic Edge_PE2Bank_out_sos, // start of streaming
output logic Edge_PE2Bank_out_eos,//  end of streaming
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_0,//64/16
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_1,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_2,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_3,
output logic Edge_PE2Bank_out_Done_aggr,
output logic Edge_PE2Bank_out_WB_en,
output logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Bank_out_Node_id,
				// aggregated output to bank
output logic Req_Output_SRAM_out_Grant_valid,
output logic[$clog2(`Num_Edge_PE)-1:0] Req_Output_SRAM_out_PE_tag,
output logic Req_Output_SRAM_out_req,
output logic[$clog2(`Max_Node_id)-1:0]Req_Output_SRAM_out_Node_id
);

Edge_PE
#(.PE_tag(3))
Edge_PE_3(
    .clk(clk),													// global clock
    .reset(reset),												// sync active high reset
    .DP_task2Edge_PE_in_packet(DP_task2Edge_PE_out_packet_3),					// dispatch task from command buffer
    .DP_task2Edge_PE_in_valid(DP_task2Edge_PE_out_valid[3]),

    .FV_SRAM2Edge_PE_in_sos(FV_SRAM2Edge_PE_out_3_sos),					// feature value from FV SRAM (for current computation)
    .FV_SRAM2Edge_PE_in_eos(FV_SRAM2Edge_PE_out_3_eos),	
    .FV_SRAM2Edge_PE_in_FV_data(FV_SRAM2Edge_PE_out_3_FV_data),	
    
input Output_SRAM2Edge_PE_in_sos,			// feature value from output SRAM (last computation)
input Output_SRAM2Edge_PE_in_eos,	
input [`FV_bandwidth-1:0] Output_SRAM2Edge_PE_in_FV_data,	

input NeighborID_SRAM2Edge_PE_in_sos,	// neighbor info from neighbor SRAM
input NeighborID_SRAM2Edge_PE_in_eos,
input [$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter,
input [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_in_Neighbor_ids,

    .Grant_Bus_arbiter_in(Grant_Bus_arbiter_out_3_Grant),				// grant request signal
input Grant_output_Bus_arbiter_in,                             // grant output sram req
input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
input Grant_WB_Packet,										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_3_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_3_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_3_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_3_Node_id),			


output logic Edge_PE2DP_out,							// idle flag output to dispatch
.Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_3_packet),				// packet to IMEM
.Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_3_valid),	

output logic req_WB_Packet,									// request write back packet

output logic Edge_PE2Bank_out_sos, // start of streaming
output logic Edge_PE2Bank_out_eos,//  end of streaming
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_0,//64/16
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_1,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_2,
output logic [`FV_size-1:0] Edge_PE2Bank_out_FV_data_3,
output logic Edge_PE2Bank_out_Done_aggr,
output logic Edge_PE2Bank_out_WB_en,
output logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Bank_out_Node_id,
				// aggregated output to bank
output logic Req_Output_SRAM_out_Grant_valid,
output logic[$clog2(`Num_Edge_PE)-1:0] Req_Output_SRAM_out_PE_tag,
output logic Req_Output_SRAM_out_req,
output logic[$clog2(`Max_Node_id)-1:0]Req_Output_SRAM_out_Node_id
);
//--------------------------------------------------------------------Bus_arbiter--------------------------------------------------------------------------//
Bus_Arbiter Req_Bus_Arbiter_U
(
input clk,															// global clock
input reset,														// sync active high reset
// input Req_Bus_arbiter[`Num_Edge_PE-1:0] Req_Bus_arbiter_in,			// input request from PE
//Req_Bus_arbiter_in
    .Req_Bus_arbiter_in_0_req(Req_Bus_arbiter_out_0_req),
    .Req_Bus_arbiter_in_0_PE_tag(Req_Bus_arbiter_out_0_PE_tag),
    .Req_Bus_arbiter_in_0_req_type(Req_Bus_arbiter_out_0_req_type),
    .Req_Bus_arbiter_in_0_Node_id(Req_Bus_arbiter_out_0_Node_id),

    .Req_Bus_arbiter_in_1_req(Req_Bus_arbiter_out_1_req),
    .Req_Bus_arbiter_in_1_PE_tag(Req_Bus_arbiter_out_1_PE_tag),
    .Req_Bus_arbiter_in_1_req_type(Req_Bus_arbiter_out_1_req_type),
    .Req_Bus_arbiter_in_1_Node_id(Req_Bus_arbiter_out_1_Node_id),

    .Req_Bus_arbiter_in_2_req(Req_Bus_arbiter_out_2_req),
    .Req_Bus_arbiter_in_2_PE_tag(Req_Bus_arbiter_out_2_PE_tag),
    .Req_Bus_arbiter_in_2_req_type(Req_Bus_arbiter_out_2_req_type),
    .Req_Bus_arbiter_in_2_Node_id(Req_Bus_arbiter_out_2_Node_id),

    .Req_Bus_arbiter_in_3_req(Req_Bus_arbiter_out_3_req),
    .Req_Bus_arbiter_in_3_PE_tag(Req_Bus_arbiter_out_3_PE_tag),
    .Req_Bus_arbiter_in_3_req_type(Req_Bus_arbiter_out_3_req_type),
    .Req_Bus_arbiter_in_3_Node_id(Req_Bus_arbiter_out_3_Node_id),
//Req_Bus_arbiter_in

// output Grant_Bus_arbiter[`Num_Edge_PE-1:0] Grant_Bus_arbiter_out,
    .Grant_Bus_arbiter_out_0_Grant(Grant_Bus_arbiter_out_0_Grant),
    .Grant_Bus_arbiter_out_1_Grant(Grant_Bus_arbiter_out_1_Grant),
    .Grant_Bus_arbiter_out_2_Grant(Grant_Bus_arbiter_out_2_Grant),
    .Grant_Bus_arbiter_out_3_Grant(Grant_Bus_arbiter_out_3_Grant),
// output BUS2FV_info_FIFO BUS2FV_info_MEM_CNTL_out,
    .BUS2FV_info_MEM_CNTL_out_valid(BUS2FV_info_MEM_CNTL_out_valid),
    .BUS2FV_info_MEM_CNTL_out_Node_id(BUS2FV_info_MEM_CNTL_out_Node_id),
    .BUS2FV_info_MEM_CNTL_out_PE_tag(BUS2FV_info_MEM_CNTL_out_PE_tag),

// output BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_out
    .BUS2Neighbor_info_MEM_CNTL_out_valid(BUS2Neighbor_info_MEM_CNTL_out_valid),
    .BUS2Neighbor_info_MEM_CNTL_out_Node_id(BUS2Neighbor_info_MEM_CNTL_out_Node_id),
    .BUS2Neighbor_info_MEM_CNTL_out_PE_tag(BUS2Neighbor_info_MEM_CNTL_out_PE_tag)
);
//--------------------------------------------------------------------FV_info_Integration-----------------------------------------------------------------//
FV_info_Integration FV_info_Integration_U(
    .clk(clk),
    .reset(reset),

    .FV_FIFO2FV_info_MEM_CNTL_in_full(FV_FIFO2FV_info_MEM_CNTL_in_full),
    .BUS2FV_info_FIFO_in_valid(BUS2FV_info_MEM_CNTL_out_valid),
    .BUS2FV_info_FIFO_in_Node_id(BUS2FV_info_MEM_CNTL_out_Node_id),
    .BUS2FV_info_FIFO_in_PE_tag(BUS2FV_info_MEM_CNTL_out_PE_tag),


    .FV_info2FV_FIFO_out_valid(FV_info2FV_FIFO_out_valid),
    .FV_info2FV_FIFO_out_FV_addr(FV_info2FV_FIFO_out_FV_addr),
    .FV_info2FV_FIFO_out_PE_tag(FV_info2FV_FIFO_out_PE_tag)
);


//--------------------------------------------------------------------S_FV_SRAM_integration-----------------------------------------------------------------//
S_FV_SRAM_integration S_FV_SRAM_integration_U (
    .clk(clk),
    .reset(reset),
	// input FV_info2FV_FIFO	wdata,
    .wdata_valid(FV_info2FV_FIFO_out_valid),
    .wdata_FV_addr(FV_info2FV_FIFO_out_FV_addr),
    .wdata_PE_tag(FV_info2FV_FIFO_out_PE_tag),

    input [$clog2(`Max_FV_num):0] Num_FV,

    // input FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0]  FV_MEM2FV_Bank_in,
    input FV_MEM2FV_Bank_in_0_sos,
    input FV_MEM2FV_Bank_in_0_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_0_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_0_A,

    input FV_MEM2FV_Bank_in_1_sos,
    input FV_MEM2FV_Bank_in_1_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_1_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_1_A,

    input FV_MEM2FV_Bank_in_2_sos,
    input FV_MEM2FV_Bank_in_2_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_2_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_2_A,

    input FV_MEM2FV_Bank_in_3_sos,
    input FV_MEM2FV_Bank_in_3_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_3_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_3_A,

    // output FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out,
    .FV_SRAM2Edge_PE_out_0_sos(FV_SRAM2Edge_PE_out_0_sos),
    .FV_SRAM2Edge_PE_out_0_eos(FV_SRAM2Edge_PE_out_0_eos),
    .FV_SRAM2Edge_PE_out_0_FV_data(FV_SRAM2Edge_PE_out_0_FV_data),

    .FV_SRAM2Edge_PE_out_1_sos(FV_SRAM2Edge_PE_out_1_sos),
    .FV_SRAM2Edge_PE_out_1_eos(FV_SRAM2Edge_PE_out_1_eos),
    .FV_SRAM2Edge_PE_out_1_FV_data(FV_SRAM2Edge_PE_out_1_FV_data),

    .FV_SRAM2Edge_PE_out_2_sos(FV_SRAM2Edge_PE_out_2_sos),
    .FV_SRAM2Edge_PE_out_2_eos(FV_SRAM2Edge_PE_out_2_eos),
    .FV_SRAM2Edge_PE_out_2_FV_data(FV_SRAM2Edge_PE_out_2_FV_data),

    .FV_SRAM2Edge_PE_out_3_sos(FV_SRAM2Edge_PE_out_3_sos),
    .FV_SRAM2Edge_PE_out_3_eos(FV_SRAM2Edge_PE_out_3_eos),
    .FV_SRAM2Edge_PE_out_3_FV_data(FV_SRAM2Edge_PE_out_3_FV_data),

    .wfull(FV_FIFO2FV_info_MEM_CNTL_in_full)
);
//--------------------------------------------------------------------Neighbor_info_Integration-----------------------------------------------------------------//

Neighbor_info_Integration Neighbor_info_Integration_U(
    .clk(clk),
    .reset(reset),
    input [$clog2(`Max_replay_Iter)-1:0]  Current_replay_Iter,//from current_replay_iteration
    input Neighbor_CNTL2Neighbor_Info_CNTL_full,
    .BUS2Neighbor_info_MEM_CNTL_in_valid(BUS2Neighbor_info_MEM_CNTL_out_valid),
    .BUS2Neighbor_info_MEM_CNTL_in_Node_id(BUS2Neighbor_info_MEM_CNTL_out_Node_id),
    .BUS2Neighbor_info_MEM_CNTL_PE_tag(BUS2Neighbor_info_MEM_CNTL_out_PE_tag),

    output 	logic Neighbor_info2Neighbor_FIFO_out_valid, // If low, the data in this struct is garbage
    output  logic [`Neighbor_info_bandwidth-1:0] Neighbor_info2Neighbor_FIFO_out_addr,
    output  logic [$clog2(`Num_Edge_PE)-1:0] Neighbor_info2Neighbor_FIFO_out_PE_tag
);
//--------------------------------------------------------------------S_Neighbor_SRAM_integration-----------------------------------------------------------------//

S_Neighbor_SRAM_integration S_Neighbor_SRAM_integration_U( 
    input clk,
    input reset,
    // input winc,
	input 	wdata_valid,
	input 	[`Neighbor_info_bandwidth-1:0]wdata_addr,
    input 	[$clog2(`Num_Edge_PE)-1:0]wdata_PE_tag,


	output logic NeighborID_SRAM2Edge_PE_out_sos_0, // start of streaming
    output logic NeighborID_SRAM2Edge_PE_out_eos_0,//  end of streaming
    output logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_0,
    output logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_0,
	output logic NeighborID_SRAM2Edge_PE_out_sos_1, // start of streaming
    output logic NeighborID_SRAM2Edge_PE_out_eos_1,//  end of streaming
    output logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_1,
    output logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_1,
	output logic NeighborID_SRAM2Edge_PE_out_sos_2, // start of streaming
    output logic NeighborID_SRAM2Edge_PE_out_eos_2,//  end of streaming
    output logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_2,
    output logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_2,
	output logic NeighborID_SRAM2Edge_PE_out_sos_3, // start of streaming
    output logic NeighborID_SRAM2Edge_PE_out_eos_3,//  end of streaming
    output logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_3,
    output logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_3,

    output logic wfull
);

//--------------------------------------------------------------------Output_Bus_arbiter-----------------------------------------------------------------//
Output_Bus_arbiter Output_Bus_arbiter_U(
    .clk(clk),
    .reset(reset),
    .Edge_PE2Req_Output_SRAM_in(Edge_PE_Req_Output_SRAM_out),
    .Edge_Bank2Req_Output_SRAM_in(Edge_Bank2Req_Output_SRAM_in),
    .Vertex_Bank2Req_Output_SRAM_in(vertex_outbuff_pkt),
    .Output_Sram2Arbiter(Output_Sram2Arbiter_in),

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
Vertex_RS  Vertex_RS_DUT(
    .clk(clk),
    .reset(reset),
    .Bank2RS_in(RS_pkt_out),
    .start_idx(Weight_Cntl2RS_out.Cur_FV_num),
    .Vertex_buf_idle(Vertex_buffer_empty),
    .complete(Vertex_complete), 

    .RS2Vertex_PE_out(RS2Vertex_PE_out),
    .fire(RS_fire),
    .RS_available(RS_available),
    .Vertex_RS_empty(Vertex_RS_empty)

);
//------------------------------------------Vertex_PE----------------------------------------------//
// generate
//     genvar m;
//     for(m=0;m<`Num_Vertex_Unit;m=m+1)begin: Vertex_PE
//     Vertex_PE Vertex_PE_U(
//     .clk(clk),
//     .reset(reset),
//     .Weight_data_in(Weight_data2Vertex),
//     .FV_RS(FV_data[m]),
//     .Node_id(Node_id[m]),

//     .Vertex_output(Vertex_output[m]),
//     .Node_id_out(Node_id_out[m])
// );
// end 
// endgenerate
Vertex_PE Vertex_PE_0(
    input clk,
    input reset,
    input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    input [$clog2(`Max_Node_id)-1:0] Node_id,

    output logic [`FV_size-1:0] Vertex_output,
    output logic [$clog2(`Max_Node_id)-1:0] Node_id_out
);
Vertex_PE Vertex_PE_1(
    input clk,
    input reset,
    input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    input [$clog2(`Max_Node_id)-1:0] Node_id,

    output logic [`FV_size-1:0] Vertex_output,
    output logic [$clog2(`Max_Node_id)-1:0] Node_id_out
);
Vertex_PE Vertex_PE_2(
    input clk,
    input reset,
    input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    input [$clog2(`Max_Node_id)-1:0] Node_id,

    output logic [`FV_size-1:0] Vertex_output,
    output logic [$clog2(`Max_Node_id)-1:0] Node_id_out
);
Vertex_PE Vertex_PE_3(
    input clk,
    input reset,
    input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    input [$clog2(`Max_Node_id)-1:0] Node_id,

    output logic [`FV_size-1:0] Vertex_output,
    output logic [$clog2(`Max_Node_id)-1:0] Node_id_out
);
//------------------------------------------------------Weight_CNTL-----------------------------------------//
// Weight_CNTL Weight_CNTL_U(
//     .clk(clk),
//     .reset(reset),
//     .Num_Weight_layer(Weights_boundary),//Num_Weight_layer-1
//     .Num_FV(Num_FV),
//     .fire(RS_fire), //from RS

//     .Weight_data2Vertex(Weight_data2Vertex),
//     .Weight_Cntl2RS_out(Weight_Cntl2RS_out),
//     .Weight_Cntl2bank_out(Weight_Cntl2bank_out),
//     .RS_IDLE(Vertex_complete)
// );
Weight_CNTL Weight_CNTL_U(
    input clk,
    input reset,
    input[$clog2(`Max_Num_Weight_layer)-1:0] Num_Weight_layer,//Num_Weight_layer-1
    input[$clog2(`Max_FV_num):0]  Num_FV,
    input fire, //from RS

    output logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex,
    // output Weight_Cntl2RS Weight_Cntl2RS_out,
    output logic [$clog2(`Max_FV_num)-1:0] Weight_Cntl2RS_out_Cur_FV_num,
    // output Weight_Cntl2bank Weight_Cntl2bank_out,
    output logic Weight_Cntl2bank_out_sos,
    output logic Weight_Cntl2bank_out_eos,
    output logic Weight_Cntl2bank_out_change,   
    output logic RS_IDLE
);
Big_FV_wrapper_0 Big_FV_wrapper_0_U(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(Current_replay_Iter),
    .Cur_Update_Iter({$clog2(`Max_update_Iter){1'b0}}),
    .FV_num(Num_FV), 
    .req_pkt(Req2Output_SRAM_Bank_out),
    .stream_begin(stream_begin),

    .Big_FV2Sm_FV(Big_FV2Sm_FV),
    .EdgePE_rd_out(EdgePE_rd_out_0),
    .available(inbuff_available)
);
Big_FV_wrapper_1 Big_FV_wrapper_1_U(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(Current_replay_Iter),
    .Cur_Update_Iter({$clog2(`Max_update_Iter){1'b0}}),
    .FV_num(Num_FV), 
    .req_pkt(Req2Output_SRAM_Bank_out),
    .stream_begin(stream_begin),

    .Big_FV2Sm_FV(Big_FV2Sm_FV_1),
    .EdgePE_rd_out(EdgePE_rd_out),
    .available(outbuff_available)
);
// Output_BUS Output_BUS_U(
//     .clk(clk),
//     .reset(reset),
//     .Output_bank_CNTL2Edge_PE_in(EdgePE_rd_out),
//     .Output_SRAM2Edge_PE_out(Output_SRAM2Edge_PE_out)
// );
Output_BUS Output_BUS_U(
    input clk,
    input reset,
    // input FV_bank_CNTL2Edge_PE[`Num_Banks_FV-1:0] Output_bank_CNTL2Edge_PE_in,
    input Output_bank_CNTL2Edge_PE_in_0_sos,
    input Output_bank_CNTL2Edge_PE_in_0_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_0_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_0_FV_data,
    input Output_bank_CNTL2Edge_PE_in_0_valid,

    input Output_bank_CNTL2Edge_PE_in_1_sos,
    input Output_bank_CNTL2Edge_PE_in_1_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_1_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_1_FV_data,
    input Output_bank_CNTL2Edge_PE_in_1_valid,

    input Output_bank_CNTL2Edge_PE_in_2_sos,
    input Output_bank_CNTL2Edge_PE_in_2_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_2_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_2_FV_data,
    input Output_bank_CNTL2Edge_PE_in_2_valid,

    input Output_bank_CNTL2Edge_PE_in_3_sos,
    input Output_bank_CNTL2Edge_PE_in_3_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_3_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_3_FV_data,
    input Output_bank_CNTL2Edge_PE_in_3_valid,


    // output Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out
    output logic Output_SRAM2Edge_PE_out_0_sos,
    output logic Output_SRAM2Edge_PE_out_0_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_0_FV_data,

    output logic Output_SRAM2Edge_PE_out_1_sos,
    output logic Output_SRAM2Edge_PE_out_1_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_1_FV_data,

    output logic Output_SRAM2Edge_PE_out_2_sos,
    output logic Output_SRAM2Edge_PE_out_2_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_2_FV_data,

    output logic Output_SRAM2Edge_PE_out_3_sos,
    output logic Output_SRAM2Edge_PE_out_3_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_3_FV_data

);
// vertex_buffer vertex_buffer(
//     .clk(clk),
//     .reset(reset),
//     .vertex_data_pkt(vertex_data_pkt), 
//     .vertex_cntl_pkt(Weight_Cntl2bank_out),
//     .req_grant(vertex_buffer_grant),

//     //output logic busy,
//     .empty(Vertex_buffer_empty),
//     .outbuff_pkt(vertex_outbuff_pkt)
// );

vertex_buffer vertex_buffer(
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
edge_buffer edge_buffer(
    .clk(clk),
    .reset(reset),
    .edge_pkt(Edge_PE2Bank_out),
    .req_grant(edge_req_grant),
    .RS_available(RS_available),

    .RS_pkt_out(RS_pkt_out),
    .bank_busy(edge_buffer_busy),
    .outbuff_pkt(Edge_Bank2Req_Output_SRAM_in)
);
endmodule