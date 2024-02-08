`include "sys_defs.svh"
module FV_info_MEMcntl(
    input clk,
    input reset,
    input empty,
    input FIFO2FV_info_MEM_CNTL FIFO2FV_info_MEM_CNTL_in,
    input FV_FIFO2FV_info_MEM_CNTL FV_FIFO2FV_info_MEM_CNTL_in,
    input FV_Info_SRAM2CNTL FV_Info_SRAM2CNTL_in,
    output FV_info_CNTL2SRAM_Interface FV_info_CNTL2SRAM_Interface_out,
    output FV_info_MEM_CNTL2FIFO FV_info_MEM_CNTL2FIFO_out,
    output FV_info2FV_FIFO FV_info2FV_FIFO_out
);
//FV_info_SRAM  each line has 12 bits for addr, {8 bits,4 bits offset}
typedef enum reg {
IDLE='d0,
Fetch_val='d1
} state_t;
state_t state,nx_state;

FV_info_CNTL2SRAM_Interface nx_FV_info_CNTL2SRAM_Interface_out;
FV_info2FV_FIFO nx_FV_info2FV_FIFO_out;

logic[$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_PE_tag;
FV_info_MEM_CNTL2FIFO nx_FV_info_MEM_CNTL2FIFO_out;
always_ff@(posedge clk)begin
    if(!reset)begin
        state<=#1 IDLE;
        FV_info_CNTL2SRAM_Interface_out<=#1 'd0;
        FV_info2FV_FIFO_out<=#1 'd0;
        reg_PE_tag<=#1 'd0;
        FV_info_MEM_CNTL2FIFO_out<='d0;
    end
    else begin
        state<=#1 nx_state;
        FV_info_CNTL2SRAM_Interface_out<=#1 nx_FV_info_CNTL2SRAM_Interface_out;
        FV_info2FV_FIFO_out<=#1 nx_FV_info2FV_FIFO_out;
        FV_info_MEM_CNTL2FIFO_out<=#1 nx_FV_info_MEM_CNTL2FIFO_out;
        reg_PE_tag<=#1 nx_PE_tag;

    end
end
always_comb begin
    nx_PE_tag=reg_PE_tag;
    nx_FV_info2FV_FIFO_out='d0;
    nx_FV_info_MEM_CNTL2FIFO_out='d0;
    nx_FV_info_CNTL2SRAM_Interface_out='d0;
    case(state)
        IDLE:
            if(!empty && !FV_FIFO2FV_info_MEM_CNTL_in.full)begin
                nx_FV_info_MEM_CNTL2FIFO_out.rinc=1'b1;
            end
            else if(FIFO2FV_info_MEM_CNTL_in.valid)begin
                nx_state=Fetch_val;
                nx_FV_info_CNTL2SRAM_Interface_out.A=FIFO2FV_info_MEM_CNTL_in.Node_id;
                nx_FV_info_CNTL2SRAM_Interface_out.CEN=1'b1;
                nx_PE_tag=FIFO2FV_info_MEM_CNTL_in.PE_tag;
            end
            else begin
                nx_state=IDLE;
            end
        Fetch_val: begin
                nx_FV_info2FV_FIFO_out.valid=1'b1;
                nx_FV_info2FV_FIFO_out.FV_addr=FV_Info_SRAM2CNTL_in.D;
                nx_FV_info2FV_FIFO_out.PE_tag=reg_PE_tag; 
                nx_state=IDLE;
		end
    endcase
end



endmodule