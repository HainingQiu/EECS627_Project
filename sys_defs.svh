`define packet_size 16
`define Num_Edge_PE 4
`define Num_Banks_FV_INFO 1 //this is fv//neigbor info each replay_iteration info has one bank for simple
`define Num_Banks_FV 4 //small
`define Bank_size_FV_INFO 1024//bits
// `define Bank_offset_FV_INFO 
`define Max_Node_id 128
`define Max_replay_Iter 4
`define FV_info_bank_width 8 //don't need to store offset, in this case 16bits in FV SRAM, 2^4, save 4 bits
// `define FV_info_SRAM_addr ;
`define Max_FV_num 16 //#16 FVs
`define FV_size 8// one FV is 8 bits
`define FV_bandwidth 16
`define Neighbor_ID_bandwidth 14
`define FV_SRAM_size `Max_FV_num*`FV_size*`Max_Node_id/4
`define FV_SRAM_bank_size `FV_SRAM_size/4    //unit bits
`define FV_SRAM_bank_cache_line `FV_SRAM_bank_size/`FV_bandwidth    //unit bits
`define FV_SRAM_bank_id_bit $clog2(`FV_SRAM_bank_size)+1 //which bank
`define max_degree_Iter 16       //max num of neighbor for one replay iteration
`define num_neighbor_id `Neighbor_ID_bandwidth/$clog2(`Max_Node_id)
`define DEPTH_FV_FIFO `Num_Banks_FV
`define Num_Banks_all_FV `Num_Banks_FV //big
`define Max_connectivity_all 4*`max_degree_Iter
`define Size_Neighbor_SRAM `Max_Node_id*`Max_connectivity_all*`$clog2(`Max_Node_id) 
`define line_Size_Neighbor_SRAM $clog2(`Size_Neighbor_SRAM)  //4096 lines
`define Neighbor_info_bandwidth 16 //12 bits addr and  max_degree_Iter
`define num_bank_neighbor_info 2;
`define Num_Banks_Neighbor 4
`define start_bit_addr_neighbor $clog2(`max_degree_Iter)
`define Neighbor_addr_length `Neighbor_info_bandwidth-$clog2(`max_degree_Iter)-$clog2(`Num_Banks_Neighbor)//bank  16-4-2=10bits
`define Neighbor_bank_bandwidth `Neighbor_ID_bandwidth //2 nodes in one line
// typedef struct packed {
// 	logic[`Num_Edge_PE-1:0] valid; //if valid mem read req
//     logic[`Num_Edge_PE-1:0][`$clog2(`Num_Edge_PE)-1:0] PE_tag;
//     logic[`Num_Edge_PE-1:0][$clog2(`Max_Node_id)-1:0] Neighbor_Node_id;
// } Edge_PE2FV_info;
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
    logic [1:0][`FV_size-1:0] FV_data;
    logic Done_aggr;
    logic WB_en;
} Edge_PE2Bank;
typedef struct packed {
    logic req;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic[1:0] req_type; //00 represnt for neighbor id info, 01 represent for fv, 10 represent for output
    logic[$clog2(`Max_Node_id)-1:0] Node_id;
} Req_Bus_arbiter;
typedef struct packed {
    logic Grant;
} Grant_Bus_arbiter;
typedef struct packed {
	logic sos; // start of streaming
    logic eos;//  end of streaming
    //logic [`$clog2(`Num_Edge_PE)-1:0] PE_tag;
    logic [`FV_bandwidth-1:0] FV_data;
} Output_SRAM2Edge_PE;
typedef struct packed {
    logic valid;
   // logic rd_wr_en;//0 for rd, 1 for wr
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;
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
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;

} BUS2FV_info_FIFO;
typedef struct packed {
    logic valid;
  //  logic rd_wr_en;//0 for rd, 1 for wr
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;

} BUS2Neighbor_info_MEM_CNTL;
typedef struct packed {
    logic valid;
   // logic rd_wr_en;//0 for rd, 1 for wr
    logic [$clog2(`Max_Node_id)-1:0] Node_id;
    logic[$clog2(`Num_Edge_PE)-1:0] PE_tag;

} BUS2Output_SRAM_MEM_CNTL;
typedef struct packed {
    logic[$clog2(`Max_Node_id)-1:0] A;
    logic CEN;
} FV_info_CNTL2SRAM_Interface;
typedef struct packed {
    logic[$clog2(`Max_Node_id)-1:0] A;
    logic CEN;
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
    logic [`FV_info_bank_width-1-2:0] Bank_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
} Neighbor_MEM_CNTL2Neighbor_Bank_CNTL;
typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    logic [`FV_info_bank_width-1-2:0] Bank_addr;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;
} Neighbor_CNTL2Neighbor_Bank_CNTL;
typedef struct packed {
    logic[$clog2(`FV_SRAM_bank_cache_line)-1:0] A;
    logic CEN;
    logic WEN;
    logic [`FV_bandwidth-1:0]Q;
} FV_bank2SRAM_Interface;
typedef struct packed {
    logic[`Neighbor_addr_length-1:0] A;
    logic [`Neighbor_bank_bandwidth-1:0]Q;
} Neighbor_bank2SRAM_Interface;
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
    logic [`Neighbor_bank_bandwidth-1:0] data;
    logic[$clog2(`max_degree_Iter)-1:0] Neighbor_num_Iter;
    logic valid;
} Neighbor_bank_CNTL2Edge_PE;


typedef struct packed {
    logic sos;
    logic eos;
    logic [`FV_bandwidth-1:0] FV_data;
    logic[$clog2(`FV_SRAM_bank_cache_line)-1:0] A;
} FV_MEM2FV_Bank;
