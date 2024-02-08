`include "sys_defs.svh"
module Neighbor_Info_CNTL(
    input clk,
    input reset,
    input BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_in,// from FIFO
    input empty,//FIFO empty?
    input last_bit_Cur_Replay_Iter,
    input Neighbor_ID_FIFO_full,
    input [`num_bank_neighbor_info-1:0][`Neighbor_info_bandwidth-1:0] Data_SRAM_in,

    output logic rinc2Neighbor_FIFO,
    output Neighbor_info_CNTL2SRAM_interface[`num_bank_neighbor_info-1:0] Neighbor_info_CNTL2SRAM_interface_out,
    output Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out

);

typedef enum reg {
IDLE='d0,
Fetch_val='d1
} state_t;
state_t state,nx_state;

logic[$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_PE_tag;
logic nx_rinc2Neighbor_FIFO;
Neighbor_info_CNTL2SRAM_interface[`num_bank_neighbor_info-1:0] nx_Neighbor_info_CNTL2SRAM_interface_out;
Neighbor_info2Neighbor_FIFO nx_Neighbor_info2Neighbor_FIFO_out;
always_ff@(posedge clk)begin
    if(!reset)begin
        state<=#1 IDLE;
        reg_PE_tag<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;
        reg_PE_tag<=#1 nx_PE_tag;
    end
end
always_comb begin
    nx_PE_tag=reg_PE_tag;
    nx_rinc2Neighbor_FIFO='d0;
    nx_Neighbor_info2Neighbor_FIFO_out='d0;
    nx_Neighbor_info_CNTL2SRAM_interface_out='d0;
    case(state)
        IDLE:
            if(!empty && !Neighbor_ID_FIFO_full)begin
                nx_rinc2Neighbor_FIFO=1'b1;
            end
            else if(BUS2Neighbor_info_MEM_CNTL_in.valid)begin
                nx_state=Fetch_val;
                nx_Neighbor_info_CNTL2SRAM_interface_out[last_bit_Cur_Replay_Iter].A=BUS2Neighbor_info_MEM_CNTL_in.Node_id;
                nx_Neighbor_info_CNTL2SRAM_interface_out[last_bit_Cur_Replay_Iter].CEN=1'b1;
                nx_PE_tag=BUS2Neighbor_info_MEM_CNTL_in.PE_tag;
            end
            else begin
                nx_state=IDLE;
            end
        Fetch_val: begin
                nx_Neighbor_info2Neighbor_FIFO_out.valid=1'b1;
                nx_Neighbor_info2Neighbor_FIFO_out.addr=Data_SRAM_in[last_bit_Cur_Replay_Iter];
                nx_Neighbor_info2Neighbor_FIFO_out.PE_tag=reg_PE_tag; 
                nx_state=IDLE;
		end
    endcase
end


endmodule