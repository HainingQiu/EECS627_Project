// `include "sys_defs.svh"
module FV_MEMcntl(
    input clk,
    input reset,
    input FV_FIFO2FV_CNTL FV_FIFO2FV_CNTL_in,
    input [`Num_Banks_FV-1:0] Bank_busy,

    output FV_CNTL2FV_FIFO FV_CNTL2FV_FIFO_out,
    output FV_MEM_CNTL2FV_Bank_CNTL[`Num_Banks_FV-1:0] FV_MEM_CNTL2FV_Bank_CNTL_out
);
typedef enum reg [1:0] {
IDLE='d0,
Route='d1,
Stall='d2,
Complete='d3
} state_t;
state_t state,nx_state;
FV_CNTL2FV_FIFO nx_FV_CNTL2FV_FIFO_out;
FV_FIFO2FV_CNTL reg_FV_FIFO2FV_CNTL_in,nx_FV_FIFO2FV_CNTL_in;
FV_MEM_CNTL2FV_Bank_CNTL[`Num_Banks_FV-1:0] nx_FV_MEM_CNTL2FV_Bank_CNTL_out;
always_ff@(posedge clk)begin
    if(reset)begin
        state<=#1 IDLE;
        FV_CNTL2FV_FIFO_out<=#1 'd0;
        FV_MEM_CNTL2FV_Bank_CNTL_out<=#1 'd0;
        reg_FV_FIFO2FV_CNTL_in<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;
        FV_CNTL2FV_FIFO_out<=#1 nx_FV_CNTL2FV_FIFO_out;
        FV_MEM_CNTL2FV_Bank_CNTL_out<=#1 nx_FV_MEM_CNTL2FV_Bank_CNTL_out;
        reg_FV_FIFO2FV_CNTL_in<=#1 nx_FV_FIFO2FV_CNTL_in;
    end
end

always_comb begin
    nx_FV_CNTL2FV_FIFO_out='d0;
    nx_FV_FIFO2FV_CNTL_in=reg_FV_FIFO2FV_CNTL_in;
    nx_FV_MEM_CNTL2FV_Bank_CNTL_out='d0;
    case(state)
        IDLE:
            if(!FV_FIFO2FV_CNTL_in.empty)begin
                nx_FV_CNTL2FV_FIFO_out.rinc=1'b1;
                nx_state=Route;
            end
            else begin
                nx_FV_CNTL2FV_FIFO_out.rinc=1'b0;
                nx_state=IDLE;
            end
        Route:
            if(FV_FIFO2FV_CNTL_in.valid && !Bank_busy[FV_FIFO2FV_CNTL_in.FV_addr[`FV_info_bank_width-1:`FV_info_bank_width-2]])begin
                nx_state=Complete;
                nx_FV_FIFO2FV_CNTL_in=FV_FIFO2FV_CNTL_in;
            end
            else if(FV_FIFO2FV_CNTL_in.valid)begin
                nx_state=Stall;
                nx_FV_FIFO2FV_CNTL_in=FV_FIFO2FV_CNTL_in;
                
            end
            else begin
                nx_state=Route;
                nx_FV_FIFO2FV_CNTL_in=FV_FIFO2FV_CNTL_in;
            end
        Stall:
            if(!Bank_busy[reg_FV_FIFO2FV_CNTL_in.FV_addr[`FV_info_bank_width-1:`FV_info_bank_width-2]])begin
                nx_state=Complete;
            end
            else begin
                nx_state=Stall;
            end

        Complete: begin
            if(!FV_FIFO2FV_CNTL_in.empty)begin
                nx_FV_CNTL2FV_FIFO_out.rinc=1'b1;
                nx_state=Route;
            end
            else begin
                nx_FV_CNTL2FV_FIFO_out.rinc=1'b0;
                nx_state=IDLE;
            end
            nx_FV_MEM_CNTL2FV_Bank_CNTL_out[reg_FV_FIFO2FV_CNTL_in.FV_addr[`FV_info_bank_width-1:`FV_info_bank_width-2]].valid=reg_FV_FIFO2FV_CNTL_in.valid;
            nx_FV_MEM_CNTL2FV_Bank_CNTL_out[reg_FV_FIFO2FV_CNTL_in.FV_addr[`FV_info_bank_width-1:`FV_info_bank_width-2]].PE_tag=reg_FV_FIFO2FV_CNTL_in.PE_tag;
            nx_FV_MEM_CNTL2FV_Bank_CNTL_out[reg_FV_FIFO2FV_CNTL_in.FV_addr[`FV_info_bank_width-1:`FV_info_bank_width-2]].FV_Bank_addr=reg_FV_FIFO2FV_CNTL_in.FV_addr[`FV_info_bank_width-3:0];
		end
	endcase
end

endmodule