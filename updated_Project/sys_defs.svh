`ifndef __SYS_DEFS_SVH__
`define __SYS_DEFS_SVH__

`define Curr_Node_Id 32
`define packet_size 16
`define Num_Edge_PE 4
`define Num_Banks_FV_INFO 1 //this is fv//neigbor info each replay_iteration info has one bank for simple
`define Num_Banks_FV 4 //small
`define Bank_size_FV_INFO 1024//bits
// `define Bank_offset_FV_INFO 
`define Max_Node_id 128
`define Max_replay_Iter 4
`define Max_update_Iter 4
`define FV_info_bank_width 10 //don't need to store offset, in this case 16bits in FV SRAM, 2^4, save 4 bits
`define NODE_PER_ITER_BANK `Curr_Node_Id/(`Num_Banks_all_FV*`Max_replay_Iter)
`define MAX_NODE_PER_ITER_BANK `Max_Node_id/(`Num_Banks_all_FV*`Max_replay_Iter)

// `define FV_info_SRAM_addr ;
`define Max_FV_num 128 //#16 FVs
`define MAX_FV_num `Max_FV_num
`define FV_size 16// one FV is 8 bits
`define FV_bandwidth 64
`define Neighbor_ID_bandwidth 63
`define FV_SRAM_size `Max_FV_num*`FV_size*`Max_Node_id/4
`define FV_SRAM_bank_size `FV_SRAM_size/4    //unit bits

`define FV_MEM_size `Max_FV_num*`FV_size*`Max_Node_id // 4096
`define FV_MEM_size `FV_SRAM_size/4    //unit bits 4096
`define FV_MEM_cache_line `FV_SRAM_bank_size*4/`FV_bandwidth   //256

`define FV_SRAM_bank_cache_line `FV_SRAM_bank_size/`FV_bandwidth    //unit bits
`define FV_SRAM_bank_id_bit $clog2(`FV_SRAM_bank_size)+1 //which bank
`define max_degree_Iter 128       //max num of neighbor for one replay iteration
`define num_neighbor_id `Neighbor_ID_bandwidth/$clog2(`Max_Node_id)
`define num_fv_line `FV_bandwidth/`FV_size
`define DEPTH_FV_FIFO `Num_Banks_FV
`define Num_Banks_all_FV `Num_Banks_FV //big
`define Max_connectivity_all 4*`max_degree_Iter
`define Size_Neighbor_SRAM `Max_Node_id*`Max_connectivity_all*`$clog2(`Max_Node_id) 
`define line_Size_Neighbor_SRAM $clog2(`Size_Neighbor_SRAM)  //4096 lines
`define Neighbor_info_bandwidth 18 //12 bits addr and  max_degree_Iter
`define num_bank_neighbor_info 2
`define Num_Banks_Neighbor 4
`define start_bit_addr_neighbor $clog2(`max_degree_Iter)//5
`define Neighbor_addr_length `Neighbor_info_bandwidth-$clog2(`max_degree_Iter)-1-$clog2(`Num_Banks_Neighbor)//bank  16-5-2=10bits
`define Neighbor_bank_bandwidth `Neighbor_ID_bandwidth //2 nodes in one line
`define Num_Vertex_Unit 4
`define Num_Total_reqs2Output `Num_Vertex_Unit+2*`Num_Edge_PE
//------------------------LST--------------------------//
`define Max_packet_line 256
`define com_fifo_size 8
`define RS_entry 4
// `define num_neighbor_id_line 
//---------------------------Vertex------------------------------//
`define Max_Num_Weight_layer 8
`define Mult_per_PE 4
typedef struct packed {
    logic sos;
    logic eos;
    logic [`num_fv_line-1:0][`FV_size-1:0] FV_data;
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
} Bank2RS;

//----------------------WSW-----------------------------//

typedef struct packed {
	logic[`Num_Edge_PE-1:0] valid; //if valid mem read req
    logic[$clog2(`Bank_size_FV_INFO)-$clog2(`FV_info_bank_width)-1:0] FV_SRAM_addr;
} FV_info2SRAM;
typedef struct packed {
	//logic[`Num_Edge_PE-1:0] valid; //if valid mem read req
    logic[`FV_info_bank_width-1:0] data;
} SRAM2FV_info;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`FV_info_bank_width-1:0] FV_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
   // logic empty;
} FV_info2FV_FIFO;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`Neighbor_info_bandwidth-1:0] addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
} Neighbor_info2Neighbor_FIFO;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`FV_info_bank_width-1:0] FV_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic empty;
} FV_FIFO2FV_CNTL;

typedef struct packed {
    logic rinc;
} FV_CNTL2FV_FIFO;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`FV_info_bank_width-1:0] FV_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
} FIFO2FV__MEM_CNTL;
typedef struct packed {
    logic[`packet_size-1-2:0] packet;
    logic valid;
} DP_task2Edge_PE;
typedef struct packed {
    logic IDLE_flag;
} Edge_PE2DP;
typedef struct packed {
    logic[`packet_size-1:0] packet;
    logic valid;
} Edge_PE2IMEM_CNTL;
typedef struct packed {
	logic sos; // start of streaming
    logic eos;//  end of streaming
    //logic [`$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic [`FV_bandwidth-1:0] FV_data;
} FV_SRAM2Edge_PE;
typedef struct packed {
	logic sos; // start of streaming
    logic eos;//  end of streaming
    logic[$clog2(`max_degree_Iter)-1:0] Neighbor_num_Iter;
    logic [`Neighbor_ID_bandwidth-1:0] Neighbor_ids;
} NeighborID_SRAM2Edge_PE;
typedef struct packed {
	logic sos; // start of streaming
    logic eos;//  end of streaming
    logic [`num_fv_line-1:0][`FV_size-1:0] FV_data; //64/16
    logic Done_aggr;
    logic WB_en;
    logic[$clog2(`Max_Node_id)-1:0] Node_id;
} Edge_PE2Bank;
typedef struct packed {
    logic req;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic req_type; //0 represnt for neighbor id info, 1 represent for fv, 
    logic[$clog2(`Max_Node_id)-1:0] Node_id;
} Req_Bus_arbiter;
typedef struct packed {
    logic Grant;
} Grant_Bus_arbiter;

typedef struct packed {
    logic valid;
   // logic rd_wr_en;//0 for rd, 1 for wr
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
    //logic empty;

} FIFO2FV_info_MEM_CNTL;
typedef struct packed {
    logic full;
} FV_FIFO2FV_info_MEM_CNTL;
typedef struct packed {
    logic rinc;
} FV_info_MEM_CNTL2FIFO;
typedef struct packed {
    logic valid;
   // logic rd_wr_en;//0 for rd, 1 for wr
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;

} BUS2FV_info_FIFO;
typedef struct packed {
    logic valid;
  //  logic rd_wr_en;//0 for rd, 1 for wr
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;

} BUS2Neighbor_info_MEM_CNTL;
typedef struct packed {
    logic valid;
   // logic rd_wr_en;//0 for rd, 1 for wr
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;

} BUS2Output_SRAM_MEM_CNTL;
typedef struct packed {
    logic[$clog2(`Max_Node_id):0] A;
    logic CEN;
    logic WEN;
} FV_info_CNTL2SRAM_Interface;
typedef struct packed {
    logic[$clog2(`Max_Node_id):0] A;
    logic CEN;
    logic WEN;
} Neighbor_info_CNTL2SRAM_interface;
typedef struct packed {
    logic valid;
    logic[`FV_info_bank_width-1:0] A;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;
} FV_info_CNTL2FV_CNTL;
typedef struct packed {
    logic[`FV_info_bank_width-1:0] D;
} FV_Info_SRAM2CNTL;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`FV_info_bank_width-1-2:0] FV_Bank_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
} FV_MEM_CNTL2FV_Bank_CNTL;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`Neighbor_info_bandwidth-1-2:0] Bank_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
} Neighbor_MEM_CNTL2Neighbor_Bank_CNTL;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`FV_info_bank_width-1-2:0] Bank_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
} Neighbor_CNTL2Neighbor_Bank_CNTL;
typedef struct packed {
    logic[`FV_info_bank_width-1-2:0] A;
    logic CEN;
    logic WEN;
    logic [`FV_bandwidth-1:0]D;
} FV_bank2SRAM_Interface;
typedef struct packed {
    logic[`Neighbor_addr_length-1:0] A;

    // logic [`Neighbor_bank_bandwidth-1:0]Q;
    logic CEN;
    logic WEN;
} Neighbor_bank2SRAM_Interface;


typedef struct packed {
    logic sos;
    logic eos;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic [`Neighbor_bank_bandwidth-1:0] data;
    logic[$clog2(`max_degree_Iter)-1:0] Neighbor_num_Iter;
    logic valid;
} Neighbor_bank_CNTL2Edge_PE;


typedef struct packed {
    logic sos;
    logic eos;
    logic [`FV_bandwidth-1:0] FV_data;
    logic[`FV_info_bank_width-2-1:0] A;
} FV_MEM2FV_Bank;
typedef struct packed {
	logic sos; // start of streaming
    logic eos;//  end of streaming
    //logic [`$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic [`FV_bandwidth-1:0] FV_data;
} Output_SRAM2Edge_PE;
typedef struct packed {
    logic Grant_valid;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic req;
    logic[$clog2(`Max_Node_id)-1:0] Node_id;
} Edge_PE2Req_Output_SRAM;

typedef struct packed {
    logic Grant_valid; //if req is granted, set 1;
    logic sos;
    logic eos;
    logic [`FV_bandwidth-1:0] data;
    logic req;
    logic[$clog2(`Max_Node_id)-1:0] Node_id;
} Bank_Req2Req_Output_SRAM;
typedef struct packed {
    logic valid;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic rd_wr; //0 represnt for rd, 1 for wr
    logic[$clog2(`Max_Node_id)-1:0] Node_id;
    logic [`FV_bandwidth-1:0] data;
    logic wr_sos;
    logic wr_eos;
} Req2Output_SRAM_Bank;

typedef struct packed {
    logic sos;
    logic eos;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic [`FV_bandwidth-1:0] FV_data;
    logic valid;
} FV_bank_CNTL2Edge_PE;
typedef struct packed {
    logic sos;
    logic eos;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic [`FV_bandwidth-1:0] FV_data;
} Output_bank_CNTL2Edge_PE;
typedef struct packed {
    logic eos;
    // logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;
} Output_Sram2Arbiter;

// typedef struct packed {
//     logic sos;
//     logic eos;
//     logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
//     logic [`FV_bandwidth-1:0] data;
//     logic valid;
// } Output_bank_CNTL2Edge_PE;
//-----------------------------LST-------------------------//
typedef struct packed {
	logic valid; 
    logic [`packet_size-1:0] packet;
} com_packet;
typedef struct packed {
    logic[`packet_size-1-2:0] packet;
    logic valid;
} DP_task2RS;

typedef struct packed {
	logic wen;
  
    logic[$clog2(`Max_packet_line)-1:0] SRAM_addr;
    logic [`packet_size-1:0] SRAM_DATA;
} PACKET_CNTL2SRAM;

typedef struct packed {
	logic valid; 
    logic [`packet_size-1:0] packet;
} DP2mem_packet;
//-----------------------------LST-------------------------//
//------------------------------ZGZ-------------------------//
`define Num_RS2Vertex_PE 4 // RS will issue when 2 nodes are done

typedef struct packed {
    logic [`Num_RS2Vertex_PE-1:0][`Mult_per_PE-1:0][`FV_size-1:0] FV_data;
    logic [`Num_RS2Vertex_PE-1:0][$clog2(`Max_Node_id)-1:0] Node_id;
    logic fire;
} RS2Vertex_PE;

typedef struct packed {
    logic fire;
} RS2Weight_Cntl;
typedef struct packed {
    logic [$clog2(`Max_FV_num)-1:0] Cur_FV_num;//2 MUL      FV_data[0]=RS_buffer[Cur_FV_num]  ; FV_data[1]=RS_buffer[Cur_FV_num+1]
    // logic Complete;
} Weight_Cntl2RS;
typedef struct packed {
    logic sos;
    logic eos;
    logic change;
} Weight_Cntl2bank;
typedef struct packed {
	// logic valid;
	logic [`FV_size-1:0] data;
	logic [$clog2(`Max_Node_id)-1:0] Node_id;
} Vertex2Accu_Bank;

typedef struct packed {
	logic sos;
    logic eos;
	logic [`FV_size-1:0] data;
	logic [$clog2(`Max_Node_id)-1:0] Node_id;

} Vertex_Accu_Bank_in;

typedef struct packed {
    logic CEN;
    logic WEN;
    logic [$clog2(`FV_MEM_cache_line)-1:0] addr; // $clog2(`FV_MEM_cache_line) = 8
    logic [`FV_bandwidth-1:0] FV_data; // TODO: parameterize this
} Big_FV2SRAM_pkt;

`endif

//Bank[`] 16 
// 16*16
//16 output