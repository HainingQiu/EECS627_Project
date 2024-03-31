
module Neighbor_Info_CNTL(
    input clk,
    input reset,
    input BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_in,// from FIFO
    input empty,//FIFO empty?
    input [$clog2(`Max_replay_Iter)-1:0]  Current_replay_Iter,
    input Neighbor_ID_FIFO_full,
    input [`num_bank_neighbor_info-1:0][`Neighbor_info_bandwidth-1:0] Data_SRAM_in,

    output logic rinc2Neighbor_FIFO,
    output Neighbor_info_CNTL2SRAM_interface[`num_bank_neighbor_info-1:0] Neighbor_info_CNTL2SRAM_interface_out,
    output Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out

);

typedef enum reg[1:0] {
IDLE='d0,
Fetch_val='d1,
Prepare='d2
} state_t;
state_t state,nx_state;

logic[$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_PE_tag;
// logic nx_rinc2Neighbor_FIFO;
// Neighbor_info_CNTL2SRAM_interface[`num_bank_neighbor_info-1:0] reg_Neighbor_info_CNTL2SRAM_interface_out;
Neighbor_info2Neighbor_FIFO nx_Neighbor_info2Neighbor_FIFO_out;
always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
        state<=#1 IDLE;
        reg_PE_tag<=#1 'd0;
        // for(int i=0;i<`num_bank_neighbor_info;i++)begin
        //     reg_Neighbor_info_CNTL2SRAM_interface_out[i].A<=#1 'd0;
        //     reg_Neighbor_info_CNTL2SRAM_interface_out[i].CEN<=#1 'd1;
        //     reg_Neighbor_info_CNTL2SRAM_interface_out[i].WEN<=#1 'd1;
        // end

        Neighbor_info2Neighbor_FIFO_out<=#1 'd0;

    end
    else begin
        state<=#1 nx_state;
        reg_PE_tag<=#1 nx_PE_tag;
        // reg_Neighbor_info_CNTL2SRAM_interface_out<=#1 Neighbor_info_CNTL2SRAM_interface_out;
        Neighbor_info2Neighbor_FIFO_out<=#1 nx_Neighbor_info2Neighbor_FIFO_out;
    end
end
always_comb begin
    nx_PE_tag=reg_PE_tag;
    rinc2Neighbor_FIFO='d0;
    nx_Neighbor_info2Neighbor_FIFO_out='d0;
    for(int i=0;i<`num_bank_neighbor_info;i++)begin
        Neighbor_info_CNTL2SRAM_interface_out[i].A= 'd0;
        Neighbor_info_CNTL2SRAM_interface_out[i].CEN= 'd1;
        Neighbor_info_CNTL2SRAM_interface_out[i].WEN=1'b1;
    end
    case(state)
        IDLE:

            if(BUS2Neighbor_info_MEM_CNTL_in.valid)begin
                nx_state=Fetch_val;
                Neighbor_info_CNTL2SRAM_interface_out[Current_replay_Iter[1]].A={Current_replay_Iter[0],BUS2Neighbor_info_MEM_CNTL_in.Node_id};
                Neighbor_info_CNTL2SRAM_interface_out[Current_replay_Iter[1]].CEN=1'b0;
                Neighbor_info_CNTL2SRAM_interface_out[Current_replay_Iter[1]].WEN=1'b1;
                nx_PE_tag=BUS2Neighbor_info_MEM_CNTL_in.PE_tag;
            end
            else if(!empty && !Neighbor_ID_FIFO_full)begin
                rinc2Neighbor_FIFO=1'b1;
                nx_state=IDLE;
            end
            else begin
                nx_state=IDLE;
            end

        Prepare:
            
        Fetch_val: begin
                nx_Neighbor_info2Neighbor_FIFO_out.valid=1'b1;
                nx_Neighbor_info2Neighbor_FIFO_out.addr=Data_SRAM_in[Current_replay_Iter[1]];
                nx_Neighbor_info2Neighbor_FIFO_out.PE_tag=reg_PE_tag; 
                nx_state=IDLE;
		end
    endcase
end


endmodule