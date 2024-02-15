module Neighbor_Bank_MEMCntl(

input clk,
input reset,
input Neighbor_MEM_CNTL2Neighbor_Bank_CNTL Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in,
// input FV_MEM2FV_Bank  FV_MEM2FV_Bank_in,
input [`Neighbor_ID_bandwidth-1:0] Neighbor_SRAM_DATA,

output Neighbor_bank2SRAM_Interface Neighbor_bank2SRAM_Interface_out,
output Neighbor_bank_CNTL2Edge_PE Neighbor_bank_CNTL2Edge_PE_out,
output logic Busy
);
typedef enum reg {
IDLE='d0,
Stream='d1
} state_t;
state_t state,nx_state;

Neighbor_bank2SRAM_Interface nx_Neighbor_bank2SRAM_Interface;
logic[`Neighbor_addr_length-1:0] reg_Stream_addr, nx_Stream_addr;
logic[$clog2(`max_degree_Iter)-1:0] cnt,nx_cnt;
logic [$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_reg_PE_tag;
Neighbor_bank_CNTL2Edge_PE nx_Neighbor_bank_CNTL2Edge_PE_out;
logic [$clog2(`max_degree_Iter):0] Num_neighbor_Iter,nx_Num_neighbor_Iter;
always_ff @(posedge clk)begin
    if(reset)begin
        state<=#1 IDLE;
        reg_PE_tag<=#1 'd0;
        Num_neighbor_Iter<=#1 'd0;
        Neighbor_bank2SRAM_Interface_out.CEN <=#1 1'b1;
        Neighbor_bank2SRAM_Interface_out.WEN <=#1 1'b1;
        Neighbor_bank2SRAM_Interface_out.A<=#1 'd0;
        Neighbor_bank_CNTL2Edge_PE_out<=#1 'd0;
        cnt<=#1 'd0;

    end
    else begin
        state<=#1 nx_state;
        reg_PE_tag<=#1 nx_reg_PE_tag;
        Num_neighbor_Iter<=#1 nx_Num_neighbor_Iter;
        Neighbor_bank2SRAM_Interface_out<=#1 nx_Neighbor_bank2SRAM_Interface;
        Neighbor_bank_CNTL2Edge_PE_out<=#1 nx_Neighbor_bank_CNTL2Edge_PE_out;
        cnt<=#1 nx_cnt;
    end
end
always_comb begin
	nx_state = state; // default to avoid latch
    nx_cnt=cnt;
    nx_Neighbor_bank_CNTL2Edge_PE_out='d0;
    nx_Neighbor_bank2SRAM_Interface=Neighbor_bank2SRAM_Interface_out;
    Busy='d0;
    nx_reg_PE_tag=reg_PE_tag;
    nx_Num_neighbor_Iter=Num_neighbor_Iter;
    case(state)
        IDLE: 
            if(Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.valid)begin
                nx_state=Stream;
                nx_Neighbor_bank2SRAM_Interface.CEN=1'b0;
                nx_Neighbor_bank2SRAM_Interface.WEN = 1'b1;
                nx_Neighbor_bank2SRAM_Interface.A=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`Neighbor_info_bandwidth-1-2:`start_bit_addr_neighbor];         
                nx_Num_neighbor_Iter=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`start_bit_addr_neighbor-1:0];
                nx_reg_PE_tag=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.PE_tag;
            end 
            else begin
                nx_state=IDLE;
                nx_Neighbor_bank2SRAM_Interface.CEN=1'b1;
                nx_Neighbor_bank2SRAM_Interface.WEN=1'b1;
            end
        Stream:
            if(nx_Num_neighbor_Iter<'d3)begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=nx_Num_neighbor_Iter[0]?{7'd0,Neighbor_SRAM_DATA[6:0]}:Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt='d0;
                nx_Neighbor_bank2SRAM_Interface.CEN=1'b0;
                nx_Neighbor_bank2SRAM_Interface.WEN= 1'b1;
            end
            else if(cnt[$clog2(`max_degree_Iter)-1:1]==nx_Num_neighbor_Iter[$clog2(`max_degree_Iter)-1:1])begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=nx_Num_neighbor_Iter[0]?{7'd0,Neighbor_SRAM_DATA[6:0]}:Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt='d0;
                nx_Neighbor_bank2SRAM_Interface.CEN= 1'b0;
                nx_Neighbor_bank2SRAM_Interface.WEN= 1'b1;
            end
            else if(cnt=='d0)begin
                Busy=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt=nx_cnt+'d2;
                nx_Neighbor_bank2SRAM_Interface.CEN=1'b0;
                nx_Neighbor_bank2SRAM_Interface.WEN= 1'b1;
                nx_Neighbor_bank2SRAM_Interface.A=nx_Neighbor_bank2SRAM_Interface.A+1'b1;
            end
            else begin
                Busy=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt=nx_cnt+'d2;
                nx_Neighbor_bank2SRAM_Interface.CEN=1'b0;
                nx_Neighbor_bank2SRAM_Interface.WEN= 1'b1;
                nx_Neighbor_bank2SRAM_Interface.A=nx_Neighbor_bank2SRAM_Interface.A+1'b1;
            end
    endcase
end
endmodule


