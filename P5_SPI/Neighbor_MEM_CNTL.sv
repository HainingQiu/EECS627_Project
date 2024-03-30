
module Neighbor_MEM_CNTL(
    input clk,
    input reset,
    input Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_in,
    input empty,
    input [`Num_Banks_Neighbor-1:0] Bank_busy,

    output logic rinc_Neighbor_CNTL2FIFO,
    output Neighbor_MEM_CNTL2Neighbor_Bank_CNTL[`Num_Banks_Neighbor-1:0] Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out
);
typedef enum reg [$clog2(4)-1:0] {
IDLE='d0,
Route='d1,
Stall='d2, 
Complete='d3
} state_t;
state_t state,nx_state;
logic nx_rinc_Neighbor_CNTL2FIFO;
Neighbor_info2Neighbor_FIFO reg_Neighbor_info2Neighbor_FIFO,nx_Neighbor_info2Neighbor_FIFO;
Neighbor_MEM_CNTL2Neighbor_Bank_CNTL[`Num_Banks_Neighbor-1:0] nx_Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out;
always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
        state<=#1 IDLE;
        reg_Neighbor_info2Neighbor_FIFO<= #1 'd0;
        rinc_Neighbor_CNTL2FIFO<=#1 'd0;
        Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;
        reg_Neighbor_info2Neighbor_FIFO<=#1 nx_Neighbor_info2Neighbor_FIFO;
        rinc_Neighbor_CNTL2FIFO<=#1 nx_rinc_Neighbor_CNTL2FIFO;
        Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out<=#1 nx_Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out;
    end
end

always_comb begin
    nx_Neighbor_info2Neighbor_FIFO=reg_Neighbor_info2Neighbor_FIFO;
    nx_Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out='d0;
    nx_rinc_Neighbor_CNTL2FIFO='d0;
    case(state)
        IDLE:
            if(!empty)begin
                nx_rinc_Neighbor_CNTL2FIFO=1'b1;
                nx_state=Route;
            end
            else begin
                nx_rinc_Neighbor_CNTL2FIFO=1'b0;
                nx_state=IDLE;
            end
        Route:
            if(Neighbor_info2Neighbor_FIFO_in.valid && !Bank_busy[Neighbor_info2Neighbor_FIFO_in.addr[`Neighbor_info_bandwidth-1:`Neighbor_info_bandwidth-2]])begin
                nx_state=Complete;
                nx_Neighbor_info2Neighbor_FIFO=Neighbor_info2Neighbor_FIFO_in;
            end
            else if(Neighbor_info2Neighbor_FIFO_in.valid &&Bank_busy[Neighbor_info2Neighbor_FIFO_in.addr[`Neighbor_info_bandwidth-1:`Neighbor_info_bandwidth-2]])begin
                nx_state=Stall;
                nx_Neighbor_info2Neighbor_FIFO=Neighbor_info2Neighbor_FIFO_in;
            end
            else begin
                nx_state=Route;
            end
        Stall:
            if(!Bank_busy[reg_Neighbor_info2Neighbor_FIFO.addr[`Neighbor_info_bandwidth-1:`Neighbor_info_bandwidth-2]])begin
                nx_state=Complete;
            end
            else begin
                nx_state=Stall;
            end

        Complete: begin
            if(!empty)begin
                nx_rinc_Neighbor_CNTL2FIFO=1'b1;
                nx_state=Route;
            end
            else begin
                nx_rinc_Neighbor_CNTL2FIFO=1'b0;
                nx_state=IDLE;
            end
            nx_Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out[reg_Neighbor_info2Neighbor_FIFO.addr[`Neighbor_info_bandwidth-1:`Neighbor_info_bandwidth-2]].valid=reg_Neighbor_info2Neighbor_FIFO.valid;
            nx_Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out[reg_Neighbor_info2Neighbor_FIFO.addr[`Neighbor_info_bandwidth-1:`Neighbor_info_bandwidth-2]].PE_tag=reg_Neighbor_info2Neighbor_FIFO.PE_tag;
            nx_Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out[reg_Neighbor_info2Neighbor_FIFO.addr[`Neighbor_info_bandwidth-1:`Neighbor_info_bandwidth-2]].Bank_addr=reg_Neighbor_info2Neighbor_FIFO.addr[`Neighbor_info_bandwidth-3:0];
		end
	endcase
end
endmodule
