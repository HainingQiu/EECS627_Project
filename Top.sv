                        //  rs_pkt.sos <= 1'b0;
                        //     rs_pkt.eos <= 1'b0;
                        //     rs_pkt.FV_data[0] <= buffer[cnt];
                        //     rs_pkt.FV_data[1] <= buffer[cnt+1];
                        //     rs_pkt.Node_id <= cur_nodeid;
                        // `timescale 1 ns/1 ps
module Top(
    input clk,
    input reset,
    // output logic[1:0] TB_state
    output logic task_complete
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

FV_FIFO2FV_info_MEM_CNTL FV_FIFO2FV_info_MEM_CNTL_in;
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
Output_Sram2Arbiter[`Num_Edge_PE-1:0] Output_Sram2Arbiter_in;
//------------------------WB_packet arbiter---------------------------//
logic [`Num_Edge_PE+1-1:0] WB_packet_grants;
//-----------------------------Vertex_PE------------------------------//
Vertex2Accu_Bank [`Num_Edge_PE-1:0] vertex_data_pkt;
Weight_Cntl2bank Weight_Cntl2bank_out;
Weight_Cntl2RS Weight_Cntl2RS_out;
logic [`Num_Vertex_Unit-1:0][`FV_size-1:0] Vertex_output;
logic [`Num_Vertex_Unit-1:0][$clog2(`Max_Node_id)-1:0] Node_id_out;
//---------------------------Vertex accu buffer------------------------//
Bank_Req2Req_Output_SRAM [`Num_Vertex_Unit-1:0] vertex_outbuff_pkt;
logic Vertex_buffer_empty;
//------------------------Wires------------------------------------------//
logic[`packet_size-1:0] Data_SRAM_in;
logic RS_unavailable, RS_empty;
RS2Vertex_PE RS2Vertex_PE_out;
logic [`Num_RS2Vertex_PE-1:0][`Mult_per_PE-1:0][`FV_size-1:0] FV_data;
logic [`Num_RS2Vertex_PE-1:0][$clog2(`Max_Node_id)-1:0] Node_id;
logic Vertex_complete;
FV_MEM2FV_Bank [`Num_Banks_all_FV-1:0] Big_FV2Sm_FV;
logic [`Num_Edge_PE-1:0] Grant_WB_Packet_edge;
logic Grant_WB_Packet_Decoder;
logic Req_CNTL_Packet;
logic[`Num_Edge_PE-1:0] req_WB_Packet_Edge;
logic[`Num_Edge_PE-1+1:0] reqs_WB_Packet;
Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in;
Bank2RS  RS_pkt_out;
logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex;
Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out;
logic edge_buffer_busy;
logic [`Num_Edge_PE-1:0]edge_req_grant;
logic [`Num_Vertex_Unit-1:0] vertex_buffer_grant;
logic[`Num_Edge_PE-1:0] PE_IDLE;
logic stream_end;
FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0] Big_FV2Sm_FV_1;
FV_bank_CNTL2Edge_PE[`Num_Banks_all_FV-1:0] EdgePE_rd_out_0;
// generate 
//     genvar i,j,k,l;

always_comb begin
// genvar j,i,k,l;
    for(int j=0;j<`Num_Banks_FV;j++)begin
         Output_Sram2Arbiter_in[j].eos=EdgePE_rd_out[j].eos;
         stream_end=stream_end&Big_FV2Sm_FV[j].eos;
    end

    for(int i=0;i<`Num_Edge_PE;i++)begin
        Grant_output_Bus_arbiter_in[i]=Ouput_SRAM_Grants[i];
        Grant_WB_Packet_edge[i]=WB_packet_grants[i+1];
        reqs_WB_Packet[i+1]=req_WB_Packet_Edge[i];
        edge_req_grant[i]=Ouput_SRAM_Grants[i+`Num_Edge_PE];
        PE_IDLE[i]=Edge_PE2DP_out[i].IDLE_flag;
        
    end
    for(int l=0;l<`Num_Vertex_Unit;l++)begin
        vertex_buffer_grant[l]=Ouput_SRAM_Grants[l+`Num_Edge_PE+`Num_Edge_PE];
        FV_data[l]=RS2Vertex_PE_out.FV_data[l];
        Node_id[l]=RS2Vertex_PE_out.Node_id[l];
    end

    for(int k=0;k<`Num_Edge_PE;k++)begin
        vertex_data_pkt[k].data=Vertex_output[k];
        vertex_data_pkt[k].Node_id=Node_id_out[k];
    end

end

    // for(j=0;i<`Num_Banks_FV;j++)begin
    //     assign Output_Sram2Arbiter_in[j].eos=EdgePE_rd_out[j].eos;
    // end

    // for(i=0;i<`Num_Edge_PE;i++)begin
    //     assign Grant_output_Bus_arbiter_in[i]=Ouput_SRAM_Grants[i];
    //     assign Grant_WB_Packet_edge[i]=WB_packet_grants[i+1:1];
    //     assign reqs_WB_Packet[i+1]=req_WB_Packet_Edge[i];
    //     assign edge_req_grant[i]=Ouput_SRAM_Grants[i+`Num_Edge_PE];
        
    // end
    // for(l=0;i<`Num_Vertex_Unit;l++)begin
    //     assign vertex_buffer_grant[l]=Ouput_SRAM_Grants[l+`Num_Edge_PE+`Num_Edge_PE];
        
    // end

    // for(k=0;i<`Num_Edge_PE;k++)begin
    //     assign vertex_data_pkt[k].data=Vertex_output[k];
    //     assign vertex_data_pkt[k].Node_id=Node_id_out[k];
    // end

// endgenerate
assign FV_FIFO2FV_info_MEM_CNTL_in.full=wfull_S_FV_SRAM_integration;

// logic[`Num_Vertex_Unit-1:0] vertex_buffer_grant;

assign Grant_WB_Packet_Decoder=WB_packet_grants[0];
////////////////////////////////////////////////////////////////////////////
PACKET_SRAM_integration PACKET_SRAM_integration_U(
    .clk(clk),														
    .reset(reset),	
    .grant(Grant_WB_Packet_Decoder),
    .PE_IDLE(PE_IDLE),
    .Edge_PE2IMEM_CNTL_in(Edge_PE2IMEM_CNTL_out), // not connected
    .Data_SRAM_in(Data_SRAM_in),
    .bank_busy(edge_buffer_busy),
    .stream_end(stream_end),
    .vertex_done(Vertex_buffer_empty),
    .task_complete(task_complete),
    .PACKET_CNTL_SRAM_out(PACKET_CNTL_SRAM_out),
    .DP_task2Edge_PE_out(DP_task2Edge_PE_out),
    .Req(reqs_WB_Packet[0]),
    .replay_Iter(Current_replay_Iter),
    .Num_FV(Num_FV),
    .Weights_boundary(Weights_boundary)
    // .TB_state(TB_state)
);//----------------------------//
//WIDTH=16 Depth 256 for IMEM_SRAM//
IMem_Sram IMem_Sram_U(
    .Q(Data_SRAM_in ),
    .CLK(clk),
    .CEN(1'b0),
    .WEN(PACKET_CNTL_SRAM_out.wen),
    .A(PACKET_CNTL_SRAM_out.SRAM_addr),
    .D(PACKET_CNTL_SRAM_out.SRAM_DATA)
);
//--------------------------------------------------------------------Edge_PE-----------------------------------------------------------------//
generate
    genvar l;
    for(l=0;l<`Num_Edge_PE;l=l+1)begin: Edge_PE
        Edge_PE
        #(.PE_tag(l))
        Edge_PE_U(
        .clk(clk),													// global clock
        .reset(reset),												// sync active high reset
        .DP_task2Edge_PE_in(DP_task2Edge_PE_out[l]),					// dispatch task from command buffer
        .FV_SRAM2Edge_PE_in(FV_SRAM2Edge_PE_out[l]),					// feature value from FV SRAM (for current computation)
        .Output_SRAM2Edge_PE_in(Output_SRAM2Edge_PE_out[l]),			// feature value from output SRAM (last computation)
        .NeighborID_SRAM2Edge_PE_in(NeighborID_SRAM2Edge_PE_out[l]),	// neighbor info from neighbor SRAM
        .Grant_Bus_arbiter_in(Grant_Bus_arbiter_out[l]),				// grant request signal
        .Grant_output_Bus_arbiter_in(Grant_output_Bus_arbiter_in[l]),                             // grant output sram req
        .Cur_Replay_Iter(Current_replay_Iter),		// replay iteration count
        // input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
        .Grant_WB_Packet(Grant_WB_Packet_edge[l]),										// write back packet

        .Req_Bus_arbiter_out(Req_Bus_arbiter_out[l]),			    // request to arbiter
        .Edge_PE2DP_out(Edge_PE2DP_out[l]),							// idle flag output to dispatch
        .Edge_PE2IMEM_CNTL_out(Edge_PE2IMEM_CNTL_out[l]),				// packet to IMEM
        .req_WB_Packet(req_WB_Packet_Edge[l]),			// request write back packet
        .Edge_PE2Bank_out(Edge_PE2Bank_out[l]),						// aggregated output to bank
        .Req_Output_SRAM_out(Edge_PE_Req_Output_SRAM_out[l]) 
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
    .FV_FIFO2FV_info_MEM_CNTL_in(wfull_S_FV_SRAM_integration),
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
    genvar m;
    for(m=0;m<`Num_Vertex_Unit;m=m+1)begin: Vertex_PE
    Vertex_PE Vertex_PE_U(
    .clk(clk),
    .reset(reset),
    .Weight_data_in(Weight_data2Vertex),
    .FV_RS(FV_data[m]),
    .Node_id(Node_id[m]),

    .Vertex_output(Vertex_output[m]),
    .Node_id_out(Node_id_out[m])
);
end 
endgenerate

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

Big_FV_wrapper_0 Big_FV_wrapper_0_U(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(Current_replay_Iter),
    .Cur_Update_Iter({$clog2(`Max_update_Iter){1'b0}}),
    .FV_num(Num_FV), 
    .req_pkt(Req2Output_SRAM_Bank_out),

    .Big_FV2Sm_FV(Big_FV2Sm_FV),
    .EdgePE_rd_out(EdgePE_rd_out_0) 
);
Big_FV_wrapper_1 Big_FV_wrapper_1_U(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(Current_replay_Iter),
    .Cur_Update_Iter({$clog2(`Max_update_Iter){1'b0}}),
    .FV_num(Num_FV), 
    .req_pkt(Req2Output_SRAM_Bank_out),

    .Big_FV2Sm_FV(Big_FV2Sm_FV_1),
    .EdgePE_rd_out(EdgePE_rd_out) 
);
Output_BUS Output_BUS_U(
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