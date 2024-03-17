module Top(
    input clk,
    input reset,
    output logic task_complete
);

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
logic Req_Bus_arbiter_out_0_req_type;
logic[$clog2(`Max_Node_id)-1:0] Req_Bus_arbiter_out_0_Node_id;	

logic Req_Bus_arbiter_out_1_req;
logic[$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_out_1_PE_tag;
logic Req_Bus_arbiter_out_1_req_type;
logic[$clog2(`Max_Node_id)-1:0] Req_Bus_arbiter_out_1_Node_id;	

logic Req_Bus_arbiter_out_2_req;
logic[$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_out_2_PE_tag;
logic Req_Bus_arbiter_out_2_req_type;
logic[$clog2(`Max_Node_id)-1:0] Req_Bus_arbiter_out_2_Node_id;	

logic Req_Bus_arbiter_out_3_req;
logic[$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_out_3_PE_tag;
logic Req_Bus_arbiter_out_3_req_type;
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

logic [$clog2(`Max_replay_Iter)-1:0]  replay_Iter;
logic Neighbor_CNTL2Neighbor_Info_CNTL_full;
logic Neighbor_info2Neighbor_FIFO_out_valid; // If low, the data in this struct is garbage
logic [`Neighbor_info_bandwidth-1:0] Neighbor_info2Neighbor_FIFO_out_addr;
logic [$clog2(`Num_Edge_PE)-1:0] Neighbor_info2Neighbor_FIFO_out_PE_tag;

logic NeighborID_SRAM2Edge_PE_out_sos_0; // start of streaming
logic NeighborID_SRAM2Edge_PE_out_eos_0;//  end of streaming
logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_0;
logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_0;

logic NeighborID_SRAM2Edge_PE_out_sos_1; // start of streaming
logic NeighborID_SRAM2Edge_PE_out_eos_1;//  end of streaming
logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_1;
logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_1;

logic NeighborID_SRAM2Edge_PE_out_sos_2; // start of streaming
logic NeighborID_SRAM2Edge_PE_out_eos_2;//  end of streaming
logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_2;
logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_2;

logic NeighborID_SRAM2Edge_PE_out_sos_3; // start of streaming
logic NeighborID_SRAM2Edge_PE_out_eos_3;//  end of streaming
logic[$clog2(`max_degree_Iter)-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_3;
logic [`Neighbor_ID_bandwidth-1:0] NeighborID_SRAM2Edge_PE_out_Neighbor_id_3;

logic [`FV_size-1:0] edge_pkt_FV_data_0_0;
logic [`FV_size-1:0] edge_pkt_FV_data_0_1;
logic [`FV_size-1:0] edge_pkt_FV_data_0_2;
logic [`FV_size-1:0] edge_pkt_FV_data_0_3;

logic [`FV_size-1:0] edge_pkt_FV_data_1_0;
logic [`FV_size-1:0] edge_pkt_FV_data_1_1;
logic [`FV_size-1:0] edge_pkt_FV_data_1_2;
logic [`FV_size-1:0] edge_pkt_FV_data_1_3;

logic [`FV_size-1:0] edge_pkt_FV_data_2_0;
logic [`FV_size-1:0] edge_pkt_FV_data_2_1;
logic [`FV_size-1:0] edge_pkt_FV_data_2_2;
logic [`FV_size-1:0] edge_pkt_FV_data_2_3;

logic [`FV_size-1:0] edge_pkt_FV_data_3_0;
logic [`FV_size-1:0] edge_pkt_FV_data_3_1;
logic [`FV_size-1:0] edge_pkt_FV_data_3_2;
logic [`FV_size-1:0] edge_pkt_FV_data_3_3;

logic[`Num_Edge_PE-1:0] edge_pkt_Done_aggr;
logic[`Num_Edge_PE-1:0] edge_pkt_WB_en;

logic Edge_PE2Bank_out_Done_aggr_0;
logic Edge_PE2Bank_out_WB_en_0;
logic Edge_PE2Bank_out_Done_aggr_1;
logic Edge_PE2Bank_out_WB_en_1;
logic Edge_PE2Bank_out_Done_aggr_2;
logic Edge_PE2Bank_out_WB_en_2;
logic Edge_PE2Bank_out_Done_aggr_3;
logic Edge_PE2Bank_out_WB_en_3;

logic [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_0;
logic [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_1;
logic [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_2;
logic [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_3;

logic [`Num_Edge_PE-1:0] edge_pkt_sos;
logic [`Num_Edge_PE-1:0] edge_pkt_eos;
logic Edge_PE2Bank_out_sos_0; // start of streaming
logic Edge_PE2Bank_out_eos_0;//  end of streaming
logic Edge_PE2Bank_out_sos_1; // start of streaming
logic Edge_PE2Bank_out_eos_1;//  end of streaming
logic Edge_PE2Bank_out_sos_2; // start of streaming
logic Edge_PE2Bank_out_eos_2;//  end of streaming
logic Edge_PE2Bank_out_sos_3; // start of streaming
logic Edge_PE2Bank_out_eos_3;//  end of streaming

logic Edge_PE2Req_Output_SRAM_in_Grant_valid_0;
logic[$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_0;
logic Edge_PE2Req_Output_SRAM_in_req_0;
logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_0;

logic Edge_PE2Req_Output_SRAM_in_Grant_valid_1;
logic[$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_1;
logic Edge_PE2Req_Output_SRAM_in_req_1;
logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_1;

logic Edge_PE2Req_Output_SRAM_in_Grant_valid_2;
logic[$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_2;
logic Edge_PE2Req_Output_SRAM_in_req_2;
logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_2;

logic Edge_PE2Req_Output_SRAM_in_Grant_valid_3;
logic[$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_3;
logic Edge_PE2Req_Output_SRAM_in_req_3;
logic[$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_3;

logic [$clog2(`MAX_FV_num):0 ]    Num_FV ;

logic [`Num_Edge_PE-1:0] outbuff_pkt_Grant_valid;
logic [`Num_Edge_PE-1:0] outbuff_pkt_sos;
logic [`Num_Edge_PE-1:0] outbuff_pkt_eos;
logic [`FV_bandwidth-1:0] outbuff_pkt_data_0;
logic [`FV_bandwidth-1:0] outbuff_pkt_data_1;
logic [`FV_bandwidth-1:0] outbuff_pkt_data_2;
logic [`FV_bandwidth-1:0] outbuff_pkt_data_3;
logic [`Num_Edge_PE-1:0] outbuff_pkt_req;
logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_0;
logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_1;
logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_2;
logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_3;

logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants;

logic RS_pkt_out_sos;
logic RS_pkt_out_eos;
logic [`FV_size-1:0] RS_pkt_out_FV_data_0;
logic [`FV_size-1:0] RS_pkt_out_FV_data_1;
logic [`FV_size-1:0] RS_pkt_out_FV_data_2;
logic [`FV_size-1:0] RS_pkt_out_FV_data_3;
logic [$clog2(`Max_Node_id)-1:0] RS_pkt_out_Node_id;

logic RS_available;
logic [`Num_Edge_PE-1:0] bank_busy;

logic outbuff_pkt_0_Grant_valid;
logic outbuff_pkt_0_sos;
logic outbuff_pkt_0_eos;
logic [`FV_bandwidth-1:0] outbuff_pkt_0_data;
logic outbuff_pkt_0_req;
logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_0_Node_id;

logic outbuff_pkt_1_Grant_valid;
logic outbuff_pkt_1_sos;
logic outbuff_pkt_1_eos;
logic [`FV_bandwidth-1:0] outbuff_pkt_1_data;
logic outbuff_pkt_1_req;
logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_1_Node_id;

logic outbuff_pkt_2_Grant_valid;
logic outbuff_pkt_2_sos;
logic outbuff_pkt_2_eos;
logic [`FV_bandwidth-1:0] outbuff_pkt_2_data;
logic outbuff_pkt_2_req;
logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_2_Node_id;

logic outbuff_pkt_3_Grant_valid;
logic outbuff_pkt_3_sos;
logic outbuff_pkt_3_eos;
logic [`FV_bandwidth-1:0] outbuff_pkt_3_data;
logic outbuff_pkt_3_req;
logic[$clog2(`Max_Node_id)-1:0] outbuff_pkt_3_Node_id;

logic Vertex_empty,Vertex_RS_empty;

logic Req2Output_SRAM_Bank_out_valid_0;
logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_0;
logic Req2Output_SRAM_Bank_out_rd_wr_0;
logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_0;
logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_0;
logic Req2Output_SRAM_Bank_out_wr_sos_0;
logic Req2Output_SRAM_Bank_out_wr_eos_0;

logic Req2Output_SRAM_Bank_out_valid_1;
logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_1;
logic Req2Output_SRAM_Bank_out_rd_wr_1;
logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_1;
logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_1;
logic Req2Output_SRAM_Bank_out_wr_sos_1;
logic Req2Output_SRAM_Bank_out_wr_eos_1;

logic Req2Output_SRAM_Bank_out_valid_2;
logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_2;
logic Req2Output_SRAM_Bank_out_rd_wr_2;
logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_2;
logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_2;
logic Req2Output_SRAM_Bank_out_wr_sos_2;
logic Req2Output_SRAM_Bank_out_wr_eos_2;

logic Req2Output_SRAM_Bank_out_valid_3;
logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_3;
logic Req2Output_SRAM_Bank_out_rd_wr_3;
logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_3;
logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_3;
logic Req2Output_SRAM_Bank_out_wr_sos_3;
logic Req2Output_SRAM_Bank_out_wr_eos_3;

logic [`FV_size-1:0] RS2Vertex_PE_out_0_0;
logic [`FV_size-1:0] RS2Vertex_PE_out_0_1;
logic [`FV_size-1:0] RS2Vertex_PE_out_0_2;
logic [`FV_size-1:0] RS2Vertex_PE_out_0_3;
logic [`FV_size-1:0] RS2Vertex_PE_out_1_0;
logic [`FV_size-1:0] RS2Vertex_PE_out_1_1;
logic [`FV_size-1:0] RS2Vertex_PE_out_1_2;
logic [`FV_size-1:0] RS2Vertex_PE_out_1_3;
logic [`FV_size-1:0] RS2Vertex_PE_out_2_0;
logic [`FV_size-1:0] RS2Vertex_PE_out_2_1;
logic [`FV_size-1:0] RS2Vertex_PE_out_2_2;
logic [`FV_size-1:0] RS2Vertex_PE_out_2_3;
logic [`FV_size-1:0] RS2Vertex_PE_out_3_0;
logic [`FV_size-1:0] RS2Vertex_PE_out_3_1;
logic [`FV_size-1:0] RS2Vertex_PE_out_3_2;
logic [`FV_size-1:0] RS2Vertex_PE_out_3_3;

logic[`FV_size-1:0] Weight_data2Vertex_0;
logic[`FV_size-1:0] Weight_data2Vertex_1;
logic[`FV_size-1:0] Weight_data2Vertex_2;
logic[`FV_size-1:0] Weight_data2Vertex_3;

logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_0;
logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_1;
logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_2;
logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_3;

logic fire;
logic [$clog2(`Max_Num_Weight_layer)-1:0 ] Weights_boundary;
logic Vertex_complete;
logic [$clog2(`Max_FV_num)-1:0] Weight_Cntl2RS_out_Cur_FV_num;
logic Weight_Cntl2bank_out_sos;
logic Weight_Cntl2bank_out_eos;
logic Weight_Cntl2bank_out_change;   

logic [`FV_size-1:0] vertex_data_pkt_0_data;
logic [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_0_Node_id;

logic [`FV_size-1:0] vertex_data_pkt_1_data;
logic [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_1_Node_id;

logic [`FV_size-1:0] vertex_data_pkt_2_data;
logic [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_2_Node_id;

logic [`FV_size-1:0] vertex_data_pkt_3_data;
logic [$clog2(`Max_Node_id)-1:0] vertex_data_pkt_3_Node_id;

logic EdgePE_rd_out_sos_0;
logic EdgePE_rd_out_eos_0;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_0;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_0;
logic EdgePE_rd_out_valid_0;

logic EdgePE_rd_out_sos_1;
logic EdgePE_rd_out_eos_1;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_1;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_1;
logic EdgePE_rd_out_valid_1;

logic EdgePE_rd_out_sos_2;
logic EdgePE_rd_out_eos_2;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_2;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_2;
logic EdgePE_rd_out_valid_2;

logic EdgePE_rd_out_sos_3;
logic EdgePE_rd_out_eos_3;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_3;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_3;
logic EdgePE_rd_out_valid_3;


logic EdgePE_rd_out_sos_0_1;
logic EdgePE_rd_out_eos_0_1;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_0_1;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_0_1;
logic EdgePE_rd_out_valid_0_1;

logic EdgePE_rd_out_sos_1_1;
logic EdgePE_rd_out_eos_1_1;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_1_1;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_1_1;
logic EdgePE_rd_out_valid_1_1;

logic EdgePE_rd_out_sos_2_1;
logic EdgePE_rd_out_eos_2_1;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_2_1;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_2_1;
logic EdgePE_rd_out_valid_2_1;

logic EdgePE_rd_out_sos_3_1;
logic EdgePE_rd_out_eos_3_1;
logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_3_1;
logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_3_1;
logic EdgePE_rd_out_valid_3_1;

logic Big_FV2Sm_FV_sos_0;
logic Big_FV2Sm_FV_eos_0;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_0;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_0;

logic Big_FV2Sm_FV_sos_1;
logic Big_FV2Sm_FV_eos_1;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_1;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_1;

logic Big_FV2Sm_FV_sos_2;
logic Big_FV2Sm_FV_eos_2;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_2;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_2;

logic Big_FV2Sm_FV_sos_3;
logic Big_FV2Sm_FV_eos_3;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_3;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_3;

logic Big_FV2Sm_FV_sos_0_1;
logic Big_FV2Sm_FV_eos_0_1;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_0_1;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_0_1;

logic Big_FV2Sm_FV_sos_1_1;
logic Big_FV2Sm_FV_eos_1_1;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_1_1;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_1_1;

logic Big_FV2Sm_FV_sos_2_1;
logic Big_FV2Sm_FV_eos_2_1;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_2_1;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_2_1;

logic Big_FV2Sm_FV_sos_3_1;
logic Big_FV2Sm_FV_eos_3_1;
logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_3_1;
logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_3_1;

logic stream_begin;
logic outbuff_available;
logic inbuff_available;
logic stream_end;

logic Output_SRAM2Edge_PE_out_0_sos;
logic Output_SRAM2Edge_PE_out_0_eos;
logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_0_FV_data;

logic Output_SRAM2Edge_PE_out_1_sos;
logic Output_SRAM2Edge_PE_out_1_eos;
logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_1_FV_data;

logic Output_SRAM2Edge_PE_out_2_sos;
logic Output_SRAM2Edge_PE_out_2_eos;
logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_2_FV_data;

logic Output_SRAM2Edge_PE_out_3_sos;
logic Output_SRAM2Edge_PE_out_3_eos;
logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_3_FV_data;

logic[`Num_Edge_PE-1:0] PE_IDLE;
logic Edge_PE2DP_out_IDLE_flag_0;
logic Edge_PE2DP_out_IDLE_flag_1;
logic Edge_PE2DP_out_IDLE_flag_2;
logic Edge_PE2DP_out_IDLE_flag_3;

// logic task_complete;

logic[`Num_Edge_PE-1+1:0] reqs_WB_Packet;
logic [`Num_Edge_PE+1-1:0] WB_packet_grants;

logic [`Num_Banks_FV-1:0] Output_Sram2Arbiter_eos;

assign Output_Sram2Arbiter_eos[0]=EdgePE_rd_out_eos_0_1;
assign Output_Sram2Arbiter_eos[1]=EdgePE_rd_out_eos_1_1;
assign Output_Sram2Arbiter_eos[2]=EdgePE_rd_out_eos_2_1;
assign Output_Sram2Arbiter_eos[3]=EdgePE_rd_out_eos_3_1;
assign stream_end=Big_FV2Sm_FV_eos_3&Big_FV2Sm_FV_eos_2&Big_FV2Sm_FV_eos_1&Big_FV2Sm_FV_eos_0;
assign Edge_PE2IMEM_CNTL_in_valid[0]=Edge_PE2IMEM_CNTL_out_0_valid;
assign Edge_PE2IMEM_CNTL_in_valid[1]=Edge_PE2IMEM_CNTL_out_1_valid;
assign Edge_PE2IMEM_CNTL_in_valid[2]=Edge_PE2IMEM_CNTL_out_2_valid;
assign Edge_PE2IMEM_CNTL_in_valid[3]=Edge_PE2IMEM_CNTL_out_3_valid;

assign edge_pkt_Done_aggr[0]=Edge_PE2Bank_out_Done_aggr_0;
assign edge_pkt_Done_aggr[1]=Edge_PE2Bank_out_Done_aggr_1;
assign edge_pkt_Done_aggr[2]=Edge_PE2Bank_out_Done_aggr_2;
assign edge_pkt_Done_aggr[3]=Edge_PE2Bank_out_Done_aggr_3;

assign edge_pkt_WB_en[0]=Edge_PE2Bank_out_WB_en_0;
assign edge_pkt_WB_en[1]=Edge_PE2Bank_out_WB_en_1;
assign edge_pkt_WB_en[2]=Edge_PE2Bank_out_WB_en_2;
assign edge_pkt_WB_en[3]=Edge_PE2Bank_out_WB_en_3;

assign edge_pkt_sos[0]=Edge_PE2Bank_out_sos_0;
assign edge_pkt_sos[1]=Edge_PE2Bank_out_sos_1;
assign edge_pkt_sos[2]=Edge_PE2Bank_out_sos_2;
assign edge_pkt_sos[3]=Edge_PE2Bank_out_sos_3;

assign edge_pkt_eos[0]=Edge_PE2Bank_out_eos_0;
assign edge_pkt_eos[1]=Edge_PE2Bank_out_eos_1;
assign edge_pkt_eos[2]=Edge_PE2Bank_out_eos_2;
assign edge_pkt_eos[3]=Edge_PE2Bank_out_eos_3;

assign PE_IDLE[0]=Edge_PE2DP_out_IDLE_flag_0;
assign PE_IDLE[1]=Edge_PE2DP_out_IDLE_flag_1;
assign PE_IDLE[2]=Edge_PE2DP_out_IDLE_flag_2;
assign PE_IDLE[3]=Edge_PE2DP_out_IDLE_flag_3;

PACKET_SRAM_integration PACKET_SRAM_integration_U(
    .clk(clk),														
    .reset(reset),	
    .grant(WB_packet_grants[0]),
    .PE_IDLE(PE_IDLE),
    .Edge_PE2IMEM_CNTL_in_packet_0(Edge_PE2IMEM_CNTL_out_0_packet),
    .Edge_PE2IMEM_CNTL_in_packet_1(Edge_PE2IMEM_CNTL_out_1_packet),
    .Edge_PE2IMEM_CNTL_in_packet_2(Edge_PE2IMEM_CNTL_out_2_packet),
    .Edge_PE2IMEM_CNTL_in_packet_3(Edge_PE2IMEM_CNTL_out_3_packet),
    .Edge_PE2IMEM_CNTL_in_valid(Edge_PE2IMEM_CNTL_in_valid),
    .bank_busy(bank_busy),
    .stream_end(stream_end),
    .vertex_done(Vertex_empty&&Vertex_RS_empty),
    .outbuff_available(outbuff_available),

    .task_complete(task_complete),

    .DP_task2Edge_PE_out_packet_0(DP_task2Edge_PE_out_packet_0),
    .DP_task2Edge_PE_out_packet_1(DP_task2Edge_PE_out_packet_1),
    .DP_task2Edge_PE_out_packet_2(DP_task2Edge_PE_out_packet_2),
    .DP_task2Edge_PE_out_packet_3(DP_task2Edge_PE_out_packet_3),
    .DP_task2Edge_PE_out_valid(DP_task2Edge_PE_out_valid),
    .Req(reqs_WB_Packet[0]),
    .replay_Iter(replay_Iter),
    .Num_FV(Num_FV),
    .Weights_boundary(Weights_boundary),
    .stream_begin(stream_begin)
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

    .Output_SRAM2Edge_PE_in_sos(Output_SRAM2Edge_PE_out_0_sos),			// feature value from output SRAM (last computation)
    .Output_SRAM2Edge_PE_in_eos(Output_SRAM2Edge_PE_out_0_eos),	
    .Output_SRAM2Edge_PE_in_FV_data(Output_SRAM2Edge_PE_out_0_FV_data),	

    .NeighborID_SRAM2Edge_PE_in_sos(NeighborID_SRAM2Edge_PE_out_sos_0),	// neighbor info from neighbor SRAM
    .NeighborID_SRAM2Edge_PE_in_eos(NeighborID_SRAM2Edge_PE_out_eos_0),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_0),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_ids(NeighborID_SRAM2Edge_PE_out_Neighbor_id_0),

    .Grant_Bus_arbiter_in_signal(Grant_Bus_arbiter_out_0_Grant),				// grant request signal
    .Grant_output_Bus_arbiter_in(Ouput_SRAM_Grants[0]),                             // grant output sram req
    .Cur_Replay_Iter(replay_Iter),		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
    .Grant_WB_Packet(WB_packet_grants[1]),										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_0_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_0_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_0_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_0_Node_id),			

    .Edge_PE2DP_out_IDLE_flag(Edge_PE2DP_out_IDLE_flag_0),							// idle flag output to dispatch
    .Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_0_packet),				// packet to IMEM
    .Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_0_valid),		

    .req_WB_Packet(reqs_WB_Packet[1]),									// request write back packet

    .Edge_PE2Bank_out_sos(Edge_PE2Bank_out_sos_0), // start of streaming
    .Edge_PE2Bank_out_eos(Edge_PE2Bank_out_eos_0),//  end of streaming

    .Edge_PE2Bank_out_FV_data_0(edge_pkt_FV_data_0_0),//64/16
    .Edge_PE2Bank_out_FV_data_1(edge_pkt_FV_data_0_1),
    .Edge_PE2Bank_out_FV_data_2(edge_pkt_FV_data_0_2),
    .Edge_PE2Bank_out_FV_data_3(edge_pkt_FV_data_0_3),

    .Edge_PE2Bank_out_Done_aggr(Edge_PE2Bank_out_Done_aggr_0),
    .Edge_PE2Bank_out_WB_en(Edge_PE2Bank_out_WB_en_0),
    .Edge_PE2Bank_out_Node_id(edge_pkt_Node_id_0),

    .Req_Output_SRAM_out_Grant_valid(Edge_PE2Req_Output_SRAM_in_Grant_valid_0),
    .Req_Output_SRAM_out_PE_tag(Edge_PE2Req_Output_SRAM_in_PE_tag_0),
    .Req_Output_SRAM_out_req(Edge_PE2Req_Output_SRAM_in_req_0),
    .Req_Output_SRAM_out_Node_id(Edge_PE2Req_Output_SRAM_in_Node_id_0)
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

    .Output_SRAM2Edge_PE_in_sos(Output_SRAM2Edge_PE_out_1_sos),			// feature value from output SRAM (last computation)
    .Output_SRAM2Edge_PE_in_eos(Output_SRAM2Edge_PE_out_1_eos),	
    .Output_SRAM2Edge_PE_in_FV_data(Output_SRAM2Edge_PE_out_1_FV_data),	


    .NeighborID_SRAM2Edge_PE_in_sos(NeighborID_SRAM2Edge_PE_out_sos_1),	// neighbor info from neighbor SRAM
    .NeighborID_SRAM2Edge_PE_in_eos(NeighborID_SRAM2Edge_PE_out_eos_1),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_1),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_ids(NeighborID_SRAM2Edge_PE_out_Neighbor_id_1),

    .Grant_Bus_arbiter_in_signal(Grant_Bus_arbiter_out_1_Grant),				// grant request signal
    .Grant_output_Bus_arbiter_in(Ouput_SRAM_Grants[1]),                             // grant output sram req
    .Cur_Replay_Iter(replay_Iter),		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
    .Grant_WB_Packet(WB_packet_grants[2]),										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_1_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_1_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_1_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_1_Node_id),			


    .Edge_PE2DP_out_IDLE_flag(Edge_PE2DP_out_IDLE_flag_1),								// idle flag output to dispatch
    .Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_1_packet),				// packet to IMEM
    .Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_1_valid),	

   .req_WB_Packet(reqs_WB_Packet[2]),								// request write back packet

    .Edge_PE2Bank_out_sos(Edge_PE2Bank_out_sos_1), // start of streaming
    .Edge_PE2Bank_out_eos(Edge_PE2Bank_out_eos_1),//  end of streaming

    .Edge_PE2Bank_out_FV_data_0(edge_pkt_FV_data_1_0),//64/16
    .Edge_PE2Bank_out_FV_data_1(edge_pkt_FV_data_1_1),
    .Edge_PE2Bank_out_FV_data_2(edge_pkt_FV_data_1_2),
    .Edge_PE2Bank_out_FV_data_3(edge_pkt_FV_data_1_3),

    .Edge_PE2Bank_out_Done_aggr(Edge_PE2Bank_out_Done_aggr_1),
    .Edge_PE2Bank_out_WB_en(Edge_PE2Bank_out_WB_en_1),
    .Edge_PE2Bank_out_Node_id(edge_pkt_Node_id_1),

    .Req_Output_SRAM_out_Grant_valid(Edge_PE2Req_Output_SRAM_in_Grant_valid_1),
    .Req_Output_SRAM_out_PE_tag(Edge_PE2Req_Output_SRAM_in_PE_tag_1),
    .Req_Output_SRAM_out_req(Edge_PE2Req_Output_SRAM_in_req_1),
    .Req_Output_SRAM_out_Node_id(Edge_PE2Req_Output_SRAM_in_Node_id_1)
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

    .Output_SRAM2Edge_PE_in_sos(Output_SRAM2Edge_PE_out_2_sos),			// feature value from output SRAM (last computation)
    .Output_SRAM2Edge_PE_in_eos(Output_SRAM2Edge_PE_out_2_eos),	
    .Output_SRAM2Edge_PE_in_FV_data(Output_SRAM2Edge_PE_out_2_FV_data),	
	

    .NeighborID_SRAM2Edge_PE_in_sos(NeighborID_SRAM2Edge_PE_out_sos_2),	// neighbor info from neighbor SRAM
    .NeighborID_SRAM2Edge_PE_in_eos(NeighborID_SRAM2Edge_PE_out_eos_2),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_2),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_ids(NeighborID_SRAM2Edge_PE_out_Neighbor_id_2),

    .Grant_Bus_arbiter_in_signal(Grant_Bus_arbiter_out_2_Grant),				// grant request signal
    .Grant_output_Bus_arbiter_in(Ouput_SRAM_Grants[2]),                             // grant output sram req
    .Cur_Replay_Iter(replay_Iter),		// replay iteration count
    .Grant_WB_Packet(WB_packet_grants[3]),										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_2_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_2_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_2_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_2_Node_id),			


    .Edge_PE2DP_out_IDLE_flag(Edge_PE2DP_out_IDLE_flag_2),							// idle flag output to dispatch
    .Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_2_packet),				// packet to IMEM
    .Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_2_valid),	

   .req_WB_Packet(reqs_WB_Packet[3]),									// request write back packet

    .Edge_PE2Bank_out_sos(Edge_PE2Bank_out_sos_2), // start of streaming
    .Edge_PE2Bank_out_eos(Edge_PE2Bank_out_eos_2),//  end of streaming

    .Edge_PE2Bank_out_FV_data_0(edge_pkt_FV_data_2_0),//64/16
    .Edge_PE2Bank_out_FV_data_1(edge_pkt_FV_data_2_1),
    .Edge_PE2Bank_out_FV_data_2(edge_pkt_FV_data_2_2),
    .Edge_PE2Bank_out_FV_data_3(edge_pkt_FV_data_2_3),
    
    .Edge_PE2Bank_out_Done_aggr(Edge_PE2Bank_out_Done_aggr_2),
    .Edge_PE2Bank_out_WB_en(Edge_PE2Bank_out_WB_en_2),
    .Edge_PE2Bank_out_Node_id(edge_pkt_Node_id_2),

    .Req_Output_SRAM_out_Grant_valid(Edge_PE2Req_Output_SRAM_in_Grant_valid_2),
    .Req_Output_SRAM_out_PE_tag(Edge_PE2Req_Output_SRAM_in_PE_tag_2),
    .Req_Output_SRAM_out_req(Edge_PE2Req_Output_SRAM_in_req_2),
    .Req_Output_SRAM_out_Node_id(Edge_PE2Req_Output_SRAM_in_Node_id_2)
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
    
    .Output_SRAM2Edge_PE_in_sos(Output_SRAM2Edge_PE_out_3_sos),			// feature value from output SRAM (last computation)
    .Output_SRAM2Edge_PE_in_eos(Output_SRAM2Edge_PE_out_3_eos),	
    .Output_SRAM2Edge_PE_in_FV_data(Output_SRAM2Edge_PE_out_3_FV_data),	


    .NeighborID_SRAM2Edge_PE_in_sos(NeighborID_SRAM2Edge_PE_out_sos_3),	// neighbor info from neighbor SRAM
    .NeighborID_SRAM2Edge_PE_in_eos(NeighborID_SRAM2Edge_PE_out_eos_3),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_num_Iter(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_3),
    .NeighborID_SRAM2Edge_PE_in_Neighbor_ids(NeighborID_SRAM2Edge_PE_out_Neighbor_id_3),

    .Grant_Bus_arbiter_in_signal(Grant_Bus_arbiter_out_3_Grant),				// grant request signal
    .Grant_output_Bus_arbiter_in(Ouput_SRAM_Grants[3]),                             // grant output sram req
    .Cur_Replay_Iter(replay_Iter),		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
    .Grant_WB_Packet(WB_packet_grants[4]),										// write back packet

    .Req_Bus_arbiter_out_req(Req_Bus_arbiter_out_3_req),
    .Req_Bus_arbiter_out_PE_tag(Req_Bus_arbiter_out_3_PE_tag),
    .Req_Bus_arbiter_out_req_type(Req_Bus_arbiter_out_3_req_type), 
    .Req_Bus_arbiter_out_Node_id(Req_Bus_arbiter_out_3_Node_id),			


    .Edge_PE2DP_out_IDLE_flag(Edge_PE2DP_out_IDLE_flag_3),							// idle flag output to dispatch
    .Edge_PE2IMEM_CNTL_out_packet(Edge_PE2IMEM_CNTL_out_3_packet),				// packet to IMEM
    .Edge_PE2IMEM_CNTL_out_valid(Edge_PE2IMEM_CNTL_out_3_valid),	

   .req_WB_Packet(reqs_WB_Packet[4]),									// request write back packet

    .Edge_PE2Bank_out_sos(Edge_PE2Bank_out_sos_3), // start of streaming
    .Edge_PE2Bank_out_eos(Edge_PE2Bank_out_eos_3),//  end of streaming

    .Edge_PE2Bank_out_FV_data_0(edge_pkt_FV_data_3_0),//64/16
    .Edge_PE2Bank_out_FV_data_1(edge_pkt_FV_data_3_1),
    .Edge_PE2Bank_out_FV_data_2(edge_pkt_FV_data_3_2),
    .Edge_PE2Bank_out_FV_data_3(edge_pkt_FV_data_3_3),

    .Edge_PE2Bank_out_Done_aggr(Edge_PE2Bank_out_Done_aggr_3),
    .Edge_PE2Bank_out_WB_en(Edge_PE2Bank_out_WB_en_3),
    .Edge_PE2Bank_out_Node_id(edge_pkt_Node_id_3),

    .Req_Output_SRAM_out_Grant_valid(Edge_PE2Req_Output_SRAM_in_Grant_valid_3),
    .Req_Output_SRAM_out_PE_tag(Edge_PE2Req_Output_SRAM_in_PE_tag_3),
    .Req_Output_SRAM_out_req(Edge_PE2Req_Output_SRAM_in_req_3),
    .Req_Output_SRAM_out_Node_id(Edge_PE2Req_Output_SRAM_in_Node_id_3)
);

edge_buffer edge_buffer_DUT(
    .clk(clk),													// global clock
    .reset(reset),	

    //input Edge_PE2Bank [`Num_Edge_PE-1:0] edge_pkt,
    .edge_pkt_sos(edge_pkt_sos),
    .edge_pkt_eos(edge_pkt_eos),
    .edge_pkt_FV_data_0_0(edge_pkt_FV_data_0_0),
    .edge_pkt_FV_data_0_1(edge_pkt_FV_data_0_1),
    .edge_pkt_FV_data_0_2(edge_pkt_FV_data_0_2),
    .edge_pkt_FV_data_0_3(edge_pkt_FV_data_0_3),

    .edge_pkt_FV_data_1_0(edge_pkt_FV_data_1_0),
    .edge_pkt_FV_data_1_1(edge_pkt_FV_data_1_1),
    .edge_pkt_FV_data_1_2(edge_pkt_FV_data_1_2),
    .edge_pkt_FV_data_1_3(edge_pkt_FV_data_1_3),

    .edge_pkt_FV_data_2_0(edge_pkt_FV_data_2_0),
    .edge_pkt_FV_data_2_1(edge_pkt_FV_data_2_1),
    .edge_pkt_FV_data_2_2(edge_pkt_FV_data_2_2),
    .edge_pkt_FV_data_2_3(edge_pkt_FV_data_2_3),
    
    .edge_pkt_FV_data_3_0(edge_pkt_FV_data_3_0),
    .edge_pkt_FV_data_3_1(edge_pkt_FV_data_3_1),
    .edge_pkt_FV_data_3_2(edge_pkt_FV_data_3_2),
    .edge_pkt_FV_data_3_3(edge_pkt_FV_data_3_3),

    .edge_pkt_Done_aggr(edge_pkt_Done_aggr),
    .edge_pkt_WB_en(edge_pkt_WB_en),
    .edge_pkt_Node_id_0(edge_pkt_Node_id_0),
    .edge_pkt_Node_id_1(edge_pkt_Node_id_1),
    .edge_pkt_Node_id_2(edge_pkt_Node_id_2),
    .edge_pkt_Node_id_3(edge_pkt_Node_id_3),


    .req_grant(Ouput_SRAM_Grants[7:4]),
    .RS_available(RS_available), // 1 is available , 0 is not available

    //output Bank2RS RS_pkt_out,
    .RS_pkt_out_sos(RS_pkt_out_sos),
    .RS_pkt_out_eos(RS_pkt_out_eos),
    .RS_pkt_out_FV_data_0(RS_pkt_out_FV_data_0),
    .RS_pkt_out_FV_data_1(RS_pkt_out_FV_data_1),
    .RS_pkt_out_FV_data_2(RS_pkt_out_FV_data_2),
    .RS_pkt_out_FV_data_3(RS_pkt_out_FV_data_3),
    .RS_pkt_out_Node_id(RS_pkt_out_Node_id),

   .bank_busy(bank_busy),

    //output Bank_Req2Req_Output_SRAM [`Num_Edge_PE-1:0] outbuff_pkt,
    .outbuff_pkt_Grant_valid(outbuff_pkt_Grant_valid),
    .outbuff_pkt_sos(outbuff_pkt_sos),
    .outbuff_pkt_eos(outbuff_pkt_eos),
    .outbuff_pkt_data_0(outbuff_pkt_data_0),
    .outbuff_pkt_data_1(outbuff_pkt_data_1),
    .outbuff_pkt_data_2(outbuff_pkt_data_2),
    .outbuff_pkt_data_3(outbuff_pkt_data_3),
    .outbuff_pkt_req(outbuff_pkt_req),
    .outbuff_pkt_Node_id_0(outbuff_pkt_Node_id_0),
    .outbuff_pkt_Node_id_1(outbuff_pkt_Node_id_1),
    .outbuff_pkt_Node_id_2(outbuff_pkt_Node_id_2),
    .outbuff_pkt_Node_id_3(outbuff_pkt_Node_id_3)

);
//--------------------------------------------------------------------Bus_arbiter--------------------------------------------------------------------------//
Bus_Arbiter Req_Bus_Arbiter_U
(
    .clk(clk),													// global clock
    .reset(reset),														// sync active high reset
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

    .Num_FV(Num_FV),

    // input FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0]  FV_MEM2FV_Bank_in,
    .FV_MEM2FV_Bank_in_0_sos(Big_FV2Sm_FV_sos_0),
    .FV_MEM2FV_Bank_in_0_eos(Big_FV2Sm_FV_eos_0),
    .FV_MEM2FV_Bank_in_0_FV_data(Big_FV2Sm_FV_FV_data_0),
    .FV_MEM2FV_Bank_in_0_A(Big_FV2Sm_FV_A_0),

    .FV_MEM2FV_Bank_in_1_sos(Big_FV2Sm_FV_sos_1),
    .FV_MEM2FV_Bank_in_1_eos(Big_FV2Sm_FV_eos_1),
    .FV_MEM2FV_Bank_in_1_FV_data(Big_FV2Sm_FV_FV_data_1),
    .FV_MEM2FV_Bank_in_1_A(Big_FV2Sm_FV_A_1),

    .FV_MEM2FV_Bank_in_2_sos(Big_FV2Sm_FV_sos_2),
    .FV_MEM2FV_Bank_in_2_eos(Big_FV2Sm_FV_eos_2),
    .FV_MEM2FV_Bank_in_2_FV_data(Big_FV2Sm_FV_FV_data_2),
    .FV_MEM2FV_Bank_in_2_A(Big_FV2Sm_FV_A_2),

    .FV_MEM2FV_Bank_in_3_sos(Big_FV2Sm_FV_sos_3),
    .FV_MEM2FV_Bank_in_3_eos(Big_FV2Sm_FV_eos_3),
    .FV_MEM2FV_Bank_in_3_FV_data(Big_FV2Sm_FV_FV_data_3),
    .FV_MEM2FV_Bank_in_3_A(Big_FV2Sm_FV_A_3),


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
    .Current_replay_Iter(replay_Iter),//from current_replay_iteration
    .Neighbor_CNTL2Neighbor_Info_CNTL_full(Neighbor_CNTL2Neighbor_Info_CNTL_full),
    .BUS2Neighbor_info_MEM_CNTL_in_valid(BUS2Neighbor_info_MEM_CNTL_out_valid),
    .BUS2Neighbor_info_MEM_CNTL_in_Node_id(BUS2Neighbor_info_MEM_CNTL_out_Node_id),
    .BUS2Neighbor_info_MEM_CNTL_PE_tag(BUS2Neighbor_info_MEM_CNTL_out_PE_tag),

    .Neighbor_info2Neighbor_FIFO_out_valid(Neighbor_info2Neighbor_FIFO_out_valid), // If low, the data in this struct is garbage
    .Neighbor_info2Neighbor_FIFO_out_addr(Neighbor_info2Neighbor_FIFO_out_addr),
    .Neighbor_info2Neighbor_FIFO_out_PE_tag(Neighbor_info2Neighbor_FIFO_out_PE_tag)
);
//--------------------------------------------------------------------S_Neighbor_SRAM_integration-----------------------------------------------------------------//

S_Neighbor_SRAM_integration S_Neighbor_SRAM_integration_U( 
    .clk(clk),
    .reset(reset),
    // input winc,
	.wdata_valid(Neighbor_info2Neighbor_FIFO_out_valid),
    .wdata_addr(Neighbor_info2Neighbor_FIFO_out_addr),
    .wdata_PE_tag(Neighbor_info2Neighbor_FIFO_out_PE_tag),


	.NeighborID_SRAM2Edge_PE_out_sos_0(NeighborID_SRAM2Edge_PE_out_sos_0), // start of streaming
    .NeighborID_SRAM2Edge_PE_out_eos_0(NeighborID_SRAM2Edge_PE_out_eos_0),//  end of streaming
    .NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_0(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_0),
    .NeighborID_SRAM2Edge_PE_out_Neighbor_id_0(NeighborID_SRAM2Edge_PE_out_Neighbor_id_0),

    .NeighborID_SRAM2Edge_PE_out_sos_1(NeighborID_SRAM2Edge_PE_out_sos_1), // start of streaming
    .NeighborID_SRAM2Edge_PE_out_eos_1(NeighborID_SRAM2Edge_PE_out_eos_1),//  end of streaming
    .NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_1(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_1),
    .NeighborID_SRAM2Edge_PE_out_Neighbor_id_1(NeighborID_SRAM2Edge_PE_out_Neighbor_id_1),

    .NeighborID_SRAM2Edge_PE_out_sos_2(NeighborID_SRAM2Edge_PE_out_sos_2), // start of streaming
    .NeighborID_SRAM2Edge_PE_out_eos_2(NeighborID_SRAM2Edge_PE_out_eos_2),//  end of streaming
    .NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_2(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_2),
    .NeighborID_SRAM2Edge_PE_out_Neighbor_id_2(NeighborID_SRAM2Edge_PE_out_Neighbor_id_2),

    .NeighborID_SRAM2Edge_PE_out_sos_3(NeighborID_SRAM2Edge_PE_out_sos_3), // start of streaming
    .NeighborID_SRAM2Edge_PE_out_eos_3(NeighborID_SRAM2Edge_PE_out_eos_3),//  end of streaming
    .NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_3(NeighborID_SRAM2Edge_PE_out_Neighbor_num_Iter_3),
    .NeighborID_SRAM2Edge_PE_out_Neighbor_id_3(NeighborID_SRAM2Edge_PE_out_Neighbor_id_3),

    .wfull(Neighbor_CNTL2Neighbor_Info_CNTL_full)
);

//--------------------------------------------------------------------Output_Bus_arbiter-----------------------------------------------------------------//
Output_Bus_arbiter Output_Bus_arbiter_U(
    .clk(clk),
    .reset(reset),

    // input Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0]  Edge_PE2Req_Output_SRAM_in,
    .Edge_PE2Req_Output_SRAM_in_Grant_valid_0(Edge_PE2Req_Output_SRAM_in_Grant_valid_0),
    .Edge_PE2Req_Output_SRAM_in_PE_tag_0(Edge_PE2Req_Output_SRAM_in_PE_tag_0),
    .Edge_PE2Req_Output_SRAM_in_req_0(Edge_PE2Req_Output_SRAM_in_req_0),
    .Edge_PE2Req_Output_SRAM_in_Node_id_0(Edge_PE2Req_Output_SRAM_in_Node_id_0),

    .Edge_PE2Req_Output_SRAM_in_Grant_valid_1(Edge_PE2Req_Output_SRAM_in_Grant_valid_1),
    .Edge_PE2Req_Output_SRAM_in_PE_tag_1(Edge_PE2Req_Output_SRAM_in_PE_tag_1),
    .Edge_PE2Req_Output_SRAM_in_req_1(Edge_PE2Req_Output_SRAM_in_req_1),
    .Edge_PE2Req_Output_SRAM_in_Node_id_1(Edge_PE2Req_Output_SRAM_in_Node_id_1),

    .Edge_PE2Req_Output_SRAM_in_Grant_valid_2(Edge_PE2Req_Output_SRAM_in_Grant_valid_2),
    .Edge_PE2Req_Output_SRAM_in_PE_tag_2(Edge_PE2Req_Output_SRAM_in_PE_tag_2),
    .Edge_PE2Req_Output_SRAM_in_req_2(Edge_PE2Req_Output_SRAM_in_req_2),
    .Edge_PE2Req_Output_SRAM_in_Node_id_2(Edge_PE2Req_Output_SRAM_in_Node_id_2),

    .Edge_PE2Req_Output_SRAM_in_Grant_valid_3(Edge_PE2Req_Output_SRAM_in_Grant_valid_3),
    .Edge_PE2Req_Output_SRAM_in_PE_tag_3(Edge_PE2Req_Output_SRAM_in_PE_tag_3),
    .Edge_PE2Req_Output_SRAM_in_req_3(Edge_PE2Req_Output_SRAM_in_req_3),
    .Edge_PE2Req_Output_SRAM_in_Node_id_3(Edge_PE2Req_Output_SRAM_in_Node_id_3),
    // input Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in_,
    .Edge_Bank2Req_Output_SRAM_in_Grant_valid_0(outbuff_pkt_Grant_valid[0]),
    .Edge_Bank2Req_Output_SRAM_in_sos_0(outbuff_pkt_sos[0]),
    .Edge_Bank2Req_Output_SRAM_in_eos_0(outbuff_pkt_eos[0]),
    .Edge_Bank2Req_Output_SRAM_in_data_0(outbuff_pkt_data_0),
    .Edge_Bank2Req_Output_SRAM_in_req_0(outbuff_pkt_req[0]),
    .Edge_Bank2Req_Output_SRAM_in_Node_id_0(outbuff_pkt_Node_id_0),

    .Edge_Bank2Req_Output_SRAM_in_Grant_valid_1(outbuff_pkt_Grant_valid[1]),
    .Edge_Bank2Req_Output_SRAM_in_sos_1(outbuff_pkt_sos[1]),
    .Edge_Bank2Req_Output_SRAM_in_eos_1(outbuff_pkt_eos[1]),
    .Edge_Bank2Req_Output_SRAM_in_data_1(outbuff_pkt_data_1),
    .Edge_Bank2Req_Output_SRAM_in_req_1(outbuff_pkt_req[1]),
    .Edge_Bank2Req_Output_SRAM_in_Node_id_1(outbuff_pkt_Node_id_1),

    .Edge_Bank2Req_Output_SRAM_in_Grant_valid_2(outbuff_pkt_Grant_valid[2]),
    .Edge_Bank2Req_Output_SRAM_in_sos_2(outbuff_pkt_sos[2]),
    .Edge_Bank2Req_Output_SRAM_in_eos_2(outbuff_pkt_eos[2]),
    .Edge_Bank2Req_Output_SRAM_in_data_2(outbuff_pkt_data_2),
    .Edge_Bank2Req_Output_SRAM_in_req_2(outbuff_pkt_req[2]),
    .Edge_Bank2Req_Output_SRAM_in_Node_id_2(outbuff_pkt_Node_id_2),

    .Edge_Bank2Req_Output_SRAM_in_Grant_valid_3(outbuff_pkt_Grant_valid[3]),
    .Edge_Bank2Req_Output_SRAM_in_sos_3(outbuff_pkt_sos[3]),
    .Edge_Bank2Req_Output_SRAM_in_eos_3(outbuff_pkt_eos[3]),
    .Edge_Bank2Req_Output_SRAM_in_data_3(outbuff_pkt_data_3),
    .Edge_Bank2Req_Output_SRAM_in_req_3(outbuff_pkt_req[3]),
    .Edge_Bank2Req_Output_SRAM_in_Node_id_3(outbuff_pkt_Node_id_3),
    // input Bank_Req2Req_Output_SRAM[`Num_Vertex_Unit-1:0] Vertex_Bank2Req_Output_SRAM_in,
    .Vertex_Bank2Req_Output_SRAM_in_Grant_valid_0(outbuff_pkt_0_Grant_valid),
    .Vertex_Bank2Req_Output_SRAM_in_sos_0(outbuff_pkt_0_sos),
    .Vertex_Bank2Req_Output_SRAM_in_eos_0(outbuff_pkt_0_eos),
    .Vertex_Bank2Req_Output_SRAM_in_data_0(outbuff_pkt_0_data),
    .Vertex_Bank2Req_Output_SRAM_in_req_0(outbuff_pkt_0_req),
    .Vertex_Bank2Req_Output_SRAM_in_Node_id_0(outbuff_pkt_0_Node_id),

    .Vertex_Bank2Req_Output_SRAM_in_Grant_valid_1(outbuff_pkt_1_Grant_valid),
    .Vertex_Bank2Req_Output_SRAM_in_sos_1(outbuff_pkt_1_sos),
    .Vertex_Bank2Req_Output_SRAM_in_eos_1(outbuff_pkt_1_eos),
    .Vertex_Bank2Req_Output_SRAM_in_data_1(outbuff_pkt_1_data),
    .Vertex_Bank2Req_Output_SRAM_in_req_1(outbuff_pkt_1_req),
    .Vertex_Bank2Req_Output_SRAM_in_Node_id_1(outbuff_pkt_1_Node_id),

    .Vertex_Bank2Req_Output_SRAM_in_Grant_valid_2(outbuff_pkt_2_Grant_valid),
    .Vertex_Bank2Req_Output_SRAM_in_sos_2(outbuff_pkt_2_sos),
    .Vertex_Bank2Req_Output_SRAM_in_eos_2(outbuff_pkt_2_eos),
    .Vertex_Bank2Req_Output_SRAM_in_data_2(outbuff_pkt_2_data),
    .Vertex_Bank2Req_Output_SRAM_in_req_2(outbuff_pkt_2_req),
    .Vertex_Bank2Req_Output_SRAM_in_Node_id_2(outbuff_pkt_2_Node_id),

    .Vertex_Bank2Req_Output_SRAM_in_Grant_valid_3(outbuff_pkt_3_Grant_valid),
    .Vertex_Bank2Req_Output_SRAM_in_sos_3(outbuff_pkt_3_sos),
    .Vertex_Bank2Req_Output_SRAM_in_eos_3(outbuff_pkt_3_eos),
    .Vertex_Bank2Req_Output_SRAM_in_data_3(outbuff_pkt_3_data),
    .Vertex_Bank2Req_Output_SRAM_in_req_3(outbuff_pkt_3_req),
    .Vertex_Bank2Req_Output_SRAM_in_Node_id_3(outbuff_pkt_3_Node_id),
    // input Output_Sram2Arbiter[`Num_Banks_FV-1:0] Output_Sram2Arbiter,
    .Output_Sram2Arbiter_eos(Output_Sram2Arbiter_eos),
    // output Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] Req2Output_SRAM_Bank_out,
    .Req2Output_SRAM_Bank_out_valid_0(Req2Output_SRAM_Bank_out_valid_0),
    .Req2Output_SRAM_Bank_out_PE_tag_0(Req2Output_SRAM_Bank_out_PE_tag_0),
    .Req2Output_SRAM_Bank_out_rd_wr_0(Req2Output_SRAM_Bank_out_rd_wr_0),
    .Req2Output_SRAM_Bank_out_Node_id_0(Req2Output_SRAM_Bank_out_Node_id_0),
    .Req2Output_SRAM_Bank_out_data_0(Req2Output_SRAM_Bank_out_data_0),
    .Req2Output_SRAM_Bank_out_wr_sos_0(Req2Output_SRAM_Bank_out_wr_sos_0),
    .Req2Output_SRAM_Bank_out_wr_eos_0(Req2Output_SRAM_Bank_out_wr_eos_0),

    .Req2Output_SRAM_Bank_out_valid_1(Req2Output_SRAM_Bank_out_valid_1),
    .Req2Output_SRAM_Bank_out_PE_tag_1(Req2Output_SRAM_Bank_out_PE_tag_1),
    .Req2Output_SRAM_Bank_out_rd_wr_1(Req2Output_SRAM_Bank_out_rd_wr_1),
    .Req2Output_SRAM_Bank_out_Node_id_1(Req2Output_SRAM_Bank_out_Node_id_1),
    .Req2Output_SRAM_Bank_out_data_1(Req2Output_SRAM_Bank_out_data_1),
    .Req2Output_SRAM_Bank_out_wr_sos_1(Req2Output_SRAM_Bank_out_wr_sos_1),
    .Req2Output_SRAM_Bank_out_wr_eos_1(Req2Output_SRAM_Bank_out_wr_eos_1),

    .Req2Output_SRAM_Bank_out_valid_2(Req2Output_SRAM_Bank_out_valid_2),
    .Req2Output_SRAM_Bank_out_PE_tag_2(Req2Output_SRAM_Bank_out_PE_tag_2),
    .Req2Output_SRAM_Bank_out_rd_wr_2(Req2Output_SRAM_Bank_out_rd_wr_2),
    .Req2Output_SRAM_Bank_out_Node_id_2(Req2Output_SRAM_Bank_out_Node_id_2),
    .Req2Output_SRAM_Bank_out_data_2(Req2Output_SRAM_Bank_out_data_2),
    .Req2Output_SRAM_Bank_out_wr_sos_2(Req2Output_SRAM_Bank_out_wr_sos_2),
    .Req2Output_SRAM_Bank_out_wr_eos_2(Req2Output_SRAM_Bank_out_wr_eos_2),

    .Req2Output_SRAM_Bank_out_valid_3(Req2Output_SRAM_Bank_out_valid_3),
    .Req2Output_SRAM_Bank_out_PE_tag_3(Req2Output_SRAM_Bank_out_PE_tag_3),
    .Req2Output_SRAM_Bank_out_rd_wr_3(Req2Output_SRAM_Bank_out_rd_wr_3),
    .Req2Output_SRAM_Bank_out_Node_id_3(Req2Output_SRAM_Bank_out_Node_id_3),
    .Req2Output_SRAM_Bank_out_data_3(Req2Output_SRAM_Bank_out_data_3),
    .Req2Output_SRAM_Bank_out_wr_sos_3(Req2Output_SRAM_Bank_out_wr_sos_3),
    .Req2Output_SRAM_Bank_out_wr_eos_3(Req2Output_SRAM_Bank_out_wr_eos_3),

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
    //input Bank2RS Bank2RS_in,
    .Bank2RS_in_sos(RS_pkt_out_sos),
    .Bank2RS_in_eos(RS_pkt_out_eos),
    .Bank2RS_in_FV_data_0(RS_pkt_out_FV_data_0),
    .Bank2RS_in_FV_data_1(RS_pkt_out_FV_data_1),
    .Bank2RS_in_FV_data_2(RS_pkt_out_FV_data_2),
    .Bank2RS_in_FV_data_3(RS_pkt_out_FV_data_3),
    .Bank2RS_in_Node_id(RS_pkt_out_Node_id),

    .start_idx(Weight_Cntl2RS_out_Cur_FV_num),
    .Vertex_buf_idle(Vertex_empty),
    .complete(Vertex_complete), 

    //output RS2Vertex_PE RS2Vertex_PE_out,
    .RS2Vertex_PE_out_0_0(RS2Vertex_PE_out_0_0),
    .RS2Vertex_PE_out_0_1(RS2Vertex_PE_out_0_1),
    .RS2Vertex_PE_out_0_2(RS2Vertex_PE_out_0_2),
    .RS2Vertex_PE_out_0_3(RS2Vertex_PE_out_0_3),
    .RS2Vertex_PE_out_1_0(RS2Vertex_PE_out_1_0),
    .RS2Vertex_PE_out_1_1(RS2Vertex_PE_out_1_1),
    .RS2Vertex_PE_out_1_2(RS2Vertex_PE_out_1_2),
    .RS2Vertex_PE_out_1_3(RS2Vertex_PE_out_1_3),
    .RS2Vertex_PE_out_2_0(RS2Vertex_PE_out_2_0),
    .RS2Vertex_PE_out_2_1(RS2Vertex_PE_out_2_1),
    .RS2Vertex_PE_out_2_2(RS2Vertex_PE_out_2_2),
    .RS2Vertex_PE_out_2_3(RS2Vertex_PE_out_2_3),
    .RS2Vertex_PE_out_3_0(RS2Vertex_PE_out_3_0),
    .RS2Vertex_PE_out_3_1(RS2Vertex_PE_out_3_1),
    .RS2Vertex_PE_out_3_2(RS2Vertex_PE_out_3_2),
    .RS2Vertex_PE_out_3_3(RS2Vertex_PE_out_3_3),

    .RS2Vertex_PE_out_Node_id_0(RS2Vertex_PE_out_Node_id_0),
    .RS2Vertex_PE_out_Node_id_1(RS2Vertex_PE_out_Node_id_1),
    .RS2Vertex_PE_out_Node_id_2(RS2Vertex_PE_out_Node_id_2),
    .RS2Vertex_PE_out_Node_id_3(RS2Vertex_PE_out_Node_id_3),

    .fire(fire),
    .RS_available(RS_available),
    .Vertex_RS_empty(Vertex_RS_empty)

);
//------------------------------------------Vertex_PE----------------------------------------------//

Vertex_PE Vertex_PE_0(
    .clk(clk),
    .reset(reset),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    .Weight_data_in_0(Weight_data2Vertex_0),
    .Weight_data_in_1(Weight_data2Vertex_1),
    .Weight_data_in_2(Weight_data2Vertex_2),
    .Weight_data_in_3(Weight_data2Vertex_3),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    .FV_RS_0(RS2Vertex_PE_out_0_0),
    .FV_RS_1(RS2Vertex_PE_out_0_1),
    .FV_RS_2(RS2Vertex_PE_out_0_2),
    .FV_RS_3(RS2Vertex_PE_out_0_3),

    .Node_id(RS2Vertex_PE_out_Node_id_0),

    .Vertex_output(vertex_data_pkt_0_data),
    .Node_id_out(vertex_data_pkt_0_Node_id)
);
Vertex_PE Vertex_PE_1(
    .clk(clk),
    .reset(reset),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    .Weight_data_in_0(Weight_data2Vertex_0),
    .Weight_data_in_1(Weight_data2Vertex_1),
    .Weight_data_in_2(Weight_data2Vertex_2),
    .Weight_data_in_3(Weight_data2Vertex_3),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    .FV_RS_0(RS2Vertex_PE_out_1_0),
    .FV_RS_1(RS2Vertex_PE_out_1_1),
    .FV_RS_2(RS2Vertex_PE_out_1_2),
    .FV_RS_3(RS2Vertex_PE_out_1_3),

    .Node_id(RS2Vertex_PE_out_Node_id_1),

    .Vertex_output(vertex_data_pkt_1_data),
    .Node_id_out(vertex_data_pkt_1_Node_id)
);
Vertex_PE Vertex_PE_2(
    .clk(clk),
    .reset(reset),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    .Weight_data_in_0(Weight_data2Vertex_0),
    .Weight_data_in_1(Weight_data2Vertex_1),
    .Weight_data_in_2(Weight_data2Vertex_2),
    .Weight_data_in_3(Weight_data2Vertex_3),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    .FV_RS_0(RS2Vertex_PE_out_2_0),
    .FV_RS_1(RS2Vertex_PE_out_2_1),
    .FV_RS_2(RS2Vertex_PE_out_2_2),
    .FV_RS_3(RS2Vertex_PE_out_2_3),

    .Node_id(RS2Vertex_PE_out_Node_id_2),

    .Vertex_output(vertex_data_pkt_2_data),
    .Node_id_out(vertex_data_pkt_2_Node_id)
);
Vertex_PE Vertex_PE_3(
    .clk(clk),
    .reset(reset),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] Weight_data_in,
    .Weight_data_in_0(Weight_data2Vertex_0),
    .Weight_data_in_1(Weight_data2Vertex_1),
    .Weight_data_in_2(Weight_data2Vertex_2),
    .Weight_data_in_3(Weight_data2Vertex_3),
    // input [`Mult_per_PE-1:0][`FV_size-1:0] FV_RS,
    .FV_RS_0(RS2Vertex_PE_out_3_0),
    .FV_RS_1(RS2Vertex_PE_out_3_1),
    .FV_RS_2(RS2Vertex_PE_out_3_2),
    .FV_RS_3(RS2Vertex_PE_out_3_3),

    .Node_id(RS2Vertex_PE_out_Node_id_3),

    .Vertex_output(vertex_data_pkt_3_data),
    .Node_id_out(vertex_data_pkt_3_Node_id)
);
//------------------------------------------------------Weight_CNTL-----------------------------------------//
Weight_CNTL Weight_CNTL_U(
    .clk(clk),
    .reset(reset),
    .Num_Weight_layer(Weights_boundary),//Num_Weight_layer-1
    .Num_FV(Num_FV),
    .fire(fire), //from RS

    // output logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex,
    .Weight_data2Vertex_0(Weight_data2Vertex_0),
    .Weight_data2Vertex_1(Weight_data2Vertex_1),
    .Weight_data2Vertex_2(Weight_data2Vertex_2),
    .Weight_data2Vertex_3(Weight_data2Vertex_3),
    .Weight_Cntl2RS_out_Cur_FV_num(Weight_Cntl2RS_out_Cur_FV_num),

    .Weight_Cntl2bank_out_sos(Weight_Cntl2bank_out_sos),
    .Weight_Cntl2bank_out_eos(Weight_Cntl2bank_out_eos),
    .Weight_Cntl2bank_out_change(Weight_Cntl2bank_out_change),   
    .RS_IDLE(Vertex_complete)
);
Big_FV_wrapper_0 Big_FV_wrapper_0_U(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(replay_Iter),
    .Cur_Update_Iter({$clog2(`Max_update_Iter){1'b0}}),
    .FV_num(Num_FV), 

    .req_pkt_valid_0(Req2Output_SRAM_Bank_out_valid_0),
    .req_pkt_PE_tag_0(Req2Output_SRAM_Bank_out_PE_tag_0),
    .req_pkt_rd_wr_0(Req2Output_SRAM_Bank_out_rd_wr_0),
    .req_pkt_Node_id_0(Req2Output_SRAM_Bank_out_Node_id_0),
    .req_pkt_data_0(Req2Output_SRAM_Bank_out_data_0),
    .req_pkt_wr_sos_0(Req2Output_SRAM_Bank_out_wr_sos_0),
    .req_pkt_wr_eos_0(Req2Output_SRAM_Bank_out_wr_eos_0),

    .req_pkt_valid_1(Req2Output_SRAM_Bank_out_valid_1),
    .req_pkt_PE_tag_1(Req2Output_SRAM_Bank_out_PE_tag_1),
    .req_pkt_rd_wr_1(Req2Output_SRAM_Bank_out_rd_wr_1),
    .req_pkt_Node_id_1(Req2Output_SRAM_Bank_out_Node_id_1),
    .req_pkt_data_1(Req2Output_SRAM_Bank_out_data_1),
    .req_pkt_wr_sos_1(Req2Output_SRAM_Bank_out_wr_sos_1),
    .req_pkt_wr_eos_1(Req2Output_SRAM_Bank_out_wr_eos_1),

    .req_pkt_valid_2(Req2Output_SRAM_Bank_out_valid_2),
    .req_pkt_PE_tag_2(Req2Output_SRAM_Bank_out_PE_tag_2),
    .req_pkt_rd_wr_2(Req2Output_SRAM_Bank_out_rd_wr_2),
    .req_pkt_Node_id_2(Req2Output_SRAM_Bank_out_Node_id_2),
    .req_pkt_data_2(Req2Output_SRAM_Bank_out_data_2),
    .req_pkt_wr_sos_2(Req2Output_SRAM_Bank_out_wr_sos_2),
    .req_pkt_wr_eos_2(Req2Output_SRAM_Bank_out_wr_eos_2),

    .req_pkt_valid_3(Req2Output_SRAM_Bank_out_valid_3),
    .req_pkt_PE_tag_3(Req2Output_SRAM_Bank_out_PE_tag_3),
    .req_pkt_rd_wr_3(Req2Output_SRAM_Bank_out_rd_wr_3),
    .req_pkt_Node_id_3(Req2Output_SRAM_Bank_out_Node_id_3),
    .req_pkt_data_3(Req2Output_SRAM_Bank_out_data_3),
    .req_pkt_wr_sos_3(Req2Output_SRAM_Bank_out_wr_sos_3),
    .req_pkt_wr_eos_3(Req2Output_SRAM_Bank_out_wr_eos_3),

    .stream_begin(stream_begin),

    .Big_FV2Sm_FV_sos_0(Big_FV2Sm_FV_sos_0),
    .Big_FV2Sm_FV_eos_0(Big_FV2Sm_FV_eos_0),
    .Big_FV2Sm_FV_FV_data_0(Big_FV2Sm_FV_FV_data_0),
    .Big_FV2Sm_FV_A_0(Big_FV2Sm_FV_A_0),

    .Big_FV2Sm_FV_sos_1(Big_FV2Sm_FV_sos_1),
    .Big_FV2Sm_FV_eos_1(Big_FV2Sm_FV_eos_1),
    .Big_FV2Sm_FV_FV_data_1(Big_FV2Sm_FV_FV_data_1),
    .Big_FV2Sm_FV_A_1(Big_FV2Sm_FV_A_1),

    .Big_FV2Sm_FV_sos_2(Big_FV2Sm_FV_sos_2),
    .Big_FV2Sm_FV_eos_2(Big_FV2Sm_FV_eos_2),
    .Big_FV2Sm_FV_FV_data_2(Big_FV2Sm_FV_FV_data_2),
    .Big_FV2Sm_FV_A_2(Big_FV2Sm_FV_A_2),

    .Big_FV2Sm_FV_sos_3(Big_FV2Sm_FV_sos_3),
    .Big_FV2Sm_FV_eos_3(Big_FV2Sm_FV_eos_3),
    .Big_FV2Sm_FV_FV_data_3(Big_FV2Sm_FV_FV_data_3),
    .Big_FV2Sm_FV_A_3(Big_FV2Sm_FV_A_3),


    .EdgePE_rd_out_sos_0(EdgePE_rd_out_sos_0),
    .EdgePE_rd_out_eos_0(EdgePE_rd_out_eos_0),
    .EdgePE_rd_out_PE_tag_0(EdgePE_rd_out_PE_tag_0),
    .EdgePE_rd_out_FV_data_0(EdgePE_rd_out_FV_data_0),
    .EdgePE_rd_out_valid_0(EdgePE_rd_out_valid_0),

    .EdgePE_rd_out_sos_1(EdgePE_rd_out_sos_1),
    .EdgePE_rd_out_eos_1(EdgePE_rd_out_eos_1),
    .EdgePE_rd_out_PE_tag_1(EdgePE_rd_out_PE_tag_1),
    .EdgePE_rd_out_FV_data_1(EdgePE_rd_out_FV_data_1),
    .EdgePE_rd_out_valid_1(EdgePE_rd_out_valid_1),

    .EdgePE_rd_out_sos_2(EdgePE_rd_out_sos_2),
    .EdgePE_rd_out_eos_2(EdgePE_rd_out_eos_2),
    .EdgePE_rd_out_PE_tag_2(EdgePE_rd_out_PE_tag_2),
    .EdgePE_rd_out_FV_data_2(EdgePE_rd_out_FV_data_2),
    .EdgePE_rd_out_valid_2(EdgePE_rd_out_valid_2),

    .EdgePE_rd_out_sos_3(EdgePE_rd_out_sos_3),
    .EdgePE_rd_out_eos_3(EdgePE_rd_out_eos_3),
    .EdgePE_rd_out_PE_tag_3(EdgePE_rd_out_PE_tag_3),
    .EdgePE_rd_out_FV_data_3(EdgePE_rd_out_FV_data_3),
    .EdgePE_rd_out_valid_3(EdgePE_rd_out_valid_3),
    .available(inbuff_available)
);

Big_FV_wrapper_1 Big_FV_wrapper_1_U(
    .clk(clk),
    .reset(reset),
    .Cur_Replay_Iter(replay_Iter),
    .Cur_Update_Iter({$clog2(`Max_update_Iter){1'b0}}),
    .FV_num(Num_FV), 

    .req_pkt_valid_0(Req2Output_SRAM_Bank_out_valid_0),
    .req_pkt_PE_tag_0(Req2Output_SRAM_Bank_out_PE_tag_0),
    .req_pkt_rd_wr_0(Req2Output_SRAM_Bank_out_rd_wr_0),
    .req_pkt_Node_id_0(Req2Output_SRAM_Bank_out_Node_id_0),
    .req_pkt_data_0(Req2Output_SRAM_Bank_out_data_0),
    .req_pkt_wr_sos_0(Req2Output_SRAM_Bank_out_wr_sos_0),
    .req_pkt_wr_eos_0(Req2Output_SRAM_Bank_out_wr_eos_0),

    .req_pkt_valid_1(Req2Output_SRAM_Bank_out_valid_1),
    .req_pkt_PE_tag_1(Req2Output_SRAM_Bank_out_PE_tag_1),
    .req_pkt_rd_wr_1(Req2Output_SRAM_Bank_out_rd_wr_1),
    .req_pkt_Node_id_1(Req2Output_SRAM_Bank_out_Node_id_1),
    .req_pkt_data_1(Req2Output_SRAM_Bank_out_data_1),
    .req_pkt_wr_sos_1(Req2Output_SRAM_Bank_out_wr_sos_1),
    .req_pkt_wr_eos_1(Req2Output_SRAM_Bank_out_wr_eos_1),

    .req_pkt_valid_2(Req2Output_SRAM_Bank_out_valid_2),
    .req_pkt_PE_tag_2(Req2Output_SRAM_Bank_out_PE_tag_2),
    .req_pkt_rd_wr_2(Req2Output_SRAM_Bank_out_rd_wr_2),
    .req_pkt_Node_id_2(Req2Output_SRAM_Bank_out_Node_id_2),
    .req_pkt_data_2(Req2Output_SRAM_Bank_out_data_2),
    .req_pkt_wr_sos_2(Req2Output_SRAM_Bank_out_wr_sos_2),
    .req_pkt_wr_eos_2(Req2Output_SRAM_Bank_out_wr_eos_2),

    .req_pkt_valid_3(Req2Output_SRAM_Bank_out_valid_3),
    .req_pkt_PE_tag_3(Req2Output_SRAM_Bank_out_PE_tag_3),
    .req_pkt_rd_wr_3(Req2Output_SRAM_Bank_out_rd_wr_3),
    .req_pkt_Node_id_3(Req2Output_SRAM_Bank_out_Node_id_3),
    .req_pkt_data_3(Req2Output_SRAM_Bank_out_data_3),
    .req_pkt_wr_sos_3(Req2Output_SRAM_Bank_out_wr_sos_3),
    .req_pkt_wr_eos_3(Req2Output_SRAM_Bank_out_wr_eos_3),

    .stream_begin(stream_begin),

    .Big_FV2Sm_FV_sos_0(Big_FV2Sm_FV_sos_0_1),
    .Big_FV2Sm_FV_eos_0(Big_FV2Sm_FV_eos_0_1),
    .Big_FV2Sm_FV_FV_data_0(Big_FV2Sm_FV_FV_data_0_1),
    .Big_FV2Sm_FV_A_0(Big_FV2Sm_FV_A_0_1),

    .Big_FV2Sm_FV_sos_1(Big_FV2Sm_FV_sos_1_1),
    .Big_FV2Sm_FV_eos_1(Big_FV2Sm_FV_eos_1_1),
    .Big_FV2Sm_FV_FV_data_1(Big_FV2Sm_FV_FV_data_1_1),
    .Big_FV2Sm_FV_A_1(Big_FV2Sm_FV_A_1_1),

    .Big_FV2Sm_FV_sos_2(Big_FV2Sm_FV_sos_2_1),
    .Big_FV2Sm_FV_eos_2(Big_FV2Sm_FV_eos_2_1),
    .Big_FV2Sm_FV_FV_data_2(Big_FV2Sm_FV_FV_data_2_1),
    .Big_FV2Sm_FV_A_2(Big_FV2Sm_FV_A_2_1),

    .Big_FV2Sm_FV_sos_3(Big_FV2Sm_FV_sos_3_1),
    .Big_FV2Sm_FV_eos_3(Big_FV2Sm_FV_eos_3_1),
    .Big_FV2Sm_FV_FV_data_3(Big_FV2Sm_FV_FV_data_3_1),
    .Big_FV2Sm_FV_A_3(Big_FV2Sm_FV_A_3_1),


    .EdgePE_rd_out_sos_0(EdgePE_rd_out_sos_0_1),
    .EdgePE_rd_out_eos_0(EdgePE_rd_out_eos_0_1),
    .EdgePE_rd_out_PE_tag_0(EdgePE_rd_out_PE_tag_0_1),
    .EdgePE_rd_out_FV_data_0(EdgePE_rd_out_FV_data_0_1),
    .EdgePE_rd_out_valid_0(EdgePE_rd_out_valid_0_1),

    .EdgePE_rd_out_sos_1(EdgePE_rd_out_sos_1_1),
    .EdgePE_rd_out_eos_1(EdgePE_rd_out_eos_1_1),
    .EdgePE_rd_out_PE_tag_1(EdgePE_rd_out_PE_tag_1_1),
    .EdgePE_rd_out_FV_data_1(EdgePE_rd_out_FV_data_1_1),
    .EdgePE_rd_out_valid_1(EdgePE_rd_out_valid_1_1),

    .EdgePE_rd_out_sos_2(EdgePE_rd_out_sos_2_1),
    .EdgePE_rd_out_eos_2(EdgePE_rd_out_eos_2_1),
    .EdgePE_rd_out_PE_tag_2(EdgePE_rd_out_PE_tag_2_1),
    .EdgePE_rd_out_FV_data_2(EdgePE_rd_out_FV_data_2_1),
    .EdgePE_rd_out_valid_2(EdgePE_rd_out_valid_2_1),

    .EdgePE_rd_out_sos_3(EdgePE_rd_out_sos_3_1),
    .EdgePE_rd_out_eos_3(EdgePE_rd_out_eos_3_1),
    .EdgePE_rd_out_PE_tag_3(EdgePE_rd_out_PE_tag_3_1),
    .EdgePE_rd_out_FV_data_3(EdgePE_rd_out_FV_data_3_1),
    .EdgePE_rd_out_valid_3(EdgePE_rd_out_valid_3_1),
    .available(outbuff_available)
);
Output_BUS Output_BUS_U(
    .clk(clk),
    .reset(reset),
    // input FV_bank_CNTL2Edge_PE[`Num_Banks_FV-1:0] Output_bank_CNTL2Edge_PE_in,
    .Output_bank_CNTL2Edge_PE_in_0_sos(EdgePE_rd_out_sos_0_1),
    .Output_bank_CNTL2Edge_PE_in_0_eos(EdgePE_rd_out_eos_0_1),
    .Output_bank_CNTL2Edge_PE_in_0_PE_tag(EdgePE_rd_out_PE_tag_0_1),
    .Output_bank_CNTL2Edge_PE_in_0_FV_data(EdgePE_rd_out_FV_data_0_1),
    .Output_bank_CNTL2Edge_PE_in_0_valid(EdgePE_rd_out_valid_0_1),

    .Output_bank_CNTL2Edge_PE_in_1_sos(EdgePE_rd_out_sos_1_1),
    .Output_bank_CNTL2Edge_PE_in_1_eos(EdgePE_rd_out_eos_1_1),
    .Output_bank_CNTL2Edge_PE_in_1_PE_tag(EdgePE_rd_out_PE_tag_1_1),
    .Output_bank_CNTL2Edge_PE_in_1_FV_data(EdgePE_rd_out_FV_data_1_1),
    .Output_bank_CNTL2Edge_PE_in_1_valid(EdgePE_rd_out_valid_1_1),

    .Output_bank_CNTL2Edge_PE_in_2_sos(EdgePE_rd_out_sos_2_1),
    .Output_bank_CNTL2Edge_PE_in_2_eos(EdgePE_rd_out_eos_2_1),
    .Output_bank_CNTL2Edge_PE_in_2_PE_tag(EdgePE_rd_out_PE_tag_2_1),
    .Output_bank_CNTL2Edge_PE_in_2_FV_data(EdgePE_rd_out_FV_data_2_1),
    .Output_bank_CNTL2Edge_PE_in_2_valid(EdgePE_rd_out_valid_2_1),

    .Output_bank_CNTL2Edge_PE_in_3_sos(EdgePE_rd_out_sos_3_1),
    .Output_bank_CNTL2Edge_PE_in_3_eos(EdgePE_rd_out_eos_3_1),
    .Output_bank_CNTL2Edge_PE_in_3_PE_tag(EdgePE_rd_out_PE_tag_3_1),
    .Output_bank_CNTL2Edge_PE_in_3_FV_data(EdgePE_rd_out_FV_data_3_1),
    .Output_bank_CNTL2Edge_PE_in_3_valid(EdgePE_rd_out_valid_3_1),


    // output Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out
    .Output_SRAM2Edge_PE_out_0_sos(Output_SRAM2Edge_PE_out_0_sos),
    .Output_SRAM2Edge_PE_out_0_eos(Output_SRAM2Edge_PE_out_0_eos),
    .Output_SRAM2Edge_PE_out_0_FV_data(Output_SRAM2Edge_PE_out_0_FV_data),

    .Output_SRAM2Edge_PE_out_1_sos(Output_SRAM2Edge_PE_out_1_sos),
    .Output_SRAM2Edge_PE_out_1_eos(Output_SRAM2Edge_PE_out_1_eos),
    .Output_SRAM2Edge_PE_out_1_FV_data(Output_SRAM2Edge_PE_out_1_FV_data),

    .Output_SRAM2Edge_PE_out_2_sos(Output_SRAM2Edge_PE_out_2_sos),
    .Output_SRAM2Edge_PE_out_2_eos(Output_SRAM2Edge_PE_out_2_eos),
    .Output_SRAM2Edge_PE_out_2_FV_data(Output_SRAM2Edge_PE_out_2_FV_data),

    .Output_SRAM2Edge_PE_out_3_sos(Output_SRAM2Edge_PE_out_3_sos),
    .Output_SRAM2Edge_PE_out_3_eos(Output_SRAM2Edge_PE_out_3_eos),
    .Output_SRAM2Edge_PE_out_3_FV_data(Output_SRAM2Edge_PE_out_3_FV_data)

);
vertex_buffer vertex_buffer(
    .clk(clk),
    .reset(reset),
    // input Vertex2Accu_Bank [`Num_Vertex_Unit-1:0] vertex_data_pkt, 
    .vertex_data_pkt_0_data(vertex_data_pkt_0_data),
    .vertex_data_pkt_0_Node_id(vertex_data_pkt_0_Node_id),

    .vertex_data_pkt_1_data(vertex_data_pkt_1_data),
    .vertex_data_pkt_1_Node_id(vertex_data_pkt_1_Node_id),

    .vertex_data_pkt_2_data(vertex_data_pkt_2_data),
    .vertex_data_pkt_2_Node_id(vertex_data_pkt_2_Node_id),

    .vertex_data_pkt_3_data(vertex_data_pkt_3_data),
    .vertex_data_pkt_3_Node_id(vertex_data_pkt_3_Node_id),

    // input Weight_Cntl2bank  vertex_cntl_pkt,
    .Weight_Cntl2bank_sos(Weight_Cntl2bank_out_sos),
    .Weight_Cntl2bank_eos(Weight_Cntl2bank_out_eos),
    .Weight_Cntl2bank_change(Weight_Cntl2bank_out_change),

    .req_grant(Ouput_SRAM_Grants[11:8]),

    .empty(Vertex_empty),
    // output Bank_Req2Req_Output_SRAM [`Num_Vertex_Unit-1:0] outbuff_pkt
    .outbuff_pkt_0_Grant_valid(outbuff_pkt_0_Grant_valid),
    .outbuff_pkt_0_sos(outbuff_pkt_0_sos),
    .outbuff_pkt_0_eos(outbuff_pkt_0_eos),
    .outbuff_pkt_0_data(outbuff_pkt_0_data),
    .outbuff_pkt_0_req(outbuff_pkt_0_req),
    .outbuff_pkt_0_Node_id(outbuff_pkt_0_Node_id),

    .outbuff_pkt_1_Grant_valid(outbuff_pkt_1_Grant_valid),
    .outbuff_pkt_1_sos(outbuff_pkt_1_sos),
    .outbuff_pkt_1_eos(outbuff_pkt_1_eos),
    .outbuff_pkt_1_data(outbuff_pkt_1_data),
    .outbuff_pkt_1_req(outbuff_pkt_1_req),
    .outbuff_pkt_1_Node_id(outbuff_pkt_1_Node_id),

    .outbuff_pkt_2_Grant_valid(outbuff_pkt_2_Grant_valid),
    .outbuff_pkt_2_sos(outbuff_pkt_2_sos),
    .outbuff_pkt_2_eos(outbuff_pkt_2_eos),
    .outbuff_pkt_2_data(outbuff_pkt_2_data),
    .outbuff_pkt_2_req(outbuff_pkt_2_req),
    .outbuff_pkt_2_Node_id(outbuff_pkt_2_Node_id),

    .outbuff_pkt_3_Grant_valid(outbuff_pkt_3_Grant_valid),
    .outbuff_pkt_3_sos(outbuff_pkt_3_sos),
    .outbuff_pkt_3_eos(outbuff_pkt_3_eos),
    .outbuff_pkt_3_data(outbuff_pkt_3_data),
    .outbuff_pkt_3_req(outbuff_pkt_3_req),
    .outbuff_pkt_3_Node_id(outbuff_pkt_3_Node_id)

);

endmodule