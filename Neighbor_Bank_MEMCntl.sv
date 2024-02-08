module Neighbor_Bank_MEMCntl(
    input clk,
    input reset,
    input Neighbor_MEM_CNTL2Neighbor_Bank_CNTL Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in,
    // input FV_MEM2FV_Bank  FV_MEM2FV_Bank_in,
    input [`Neighbor_info_bandwidth-1:0 ] Neighbor_SRAM_DATA,

    output Neighbor_bank2SRAM_Interface Neighbor_bank2SRAM_Interface_out,
    output Neighbor_bank_CNTL2Edge_PE Neighbor_bank_CNTL2Edge_PE_out,
    output Busy
);
parameter IDLE='d0, Stream='d1;
logic [$clog2(2)-1:0] state,nx_state;
Neighbor_bank2SRAM_Interface nx_Neighbor_bank2SRAM_Interface;
logic[$clog2(`max_degree_Iter)-1:0] cnt,nx_cnt;
logic [`$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_reg_PE_tag;
Neighbor_bank_CNTL2Edge_PE nx_Neighbor_bank_CNTL2Edge_PE_out;
logic [$clog2(`max_degree_Iter):0] Num_neighbor_Iter,nx_Num_neighbor_Iter;
always_ff @(posedge clk)begin
    if(reset)begin
        state<=#1 'd0;
        reg_PE_tag<=#1 'd0;
        Num_neighbor_Iter<=#1 'd0;
        Neighbor_bank2SRAM_Interface_out<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;
        reg_PE_tag<=#1 nx_reg_PE_tag;
        Num_neighbor_Iter<=#1 nx_Num_neighbor_Iter;
        Neighbor_bank2SRAM_Interface_out<=#1 nx_Neighbor_bank2SRAM_Interface;
    end
end
always_comb begin
    nx_cnt=cnt;
    nx_Neighbor_bank_CNTL2Edge_PE_out='d0;
    nx_Neighbor_bank2SRAM_Interface='d0;
    Busy='d0;
    nx_reg_PE_tag=reg_PE_tag;
    nx_Num_neighbor_Iter=Num_neighbor_Iter;
    case(state)
        IDLE: 
            if(Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.valid)begin
                nx_state=Stream;
                nx_Neighbor_bank2SRAM_Interface.CEN=1'b1;
                nx_Neighbor_bank2SRAM_Interface.A=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`Neighbor_info_bandwidth-1:`start_bit_addr_neighbor];
                
                nx_Num_neighbor_Iter=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`start_bit_addr_neighbor-1:0];
                nx_reg_PE_tag=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.PE_tag;
            end 
            else begin
                nx_state=IDLE;
            end
        Stream:
            if(nx_Num_neighbor_Iter<'d3)begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.FV_data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt='d0;
            end
            else if(cnt==nx_Num_neighbor_Iter-1)begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.FV_data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt='d0;
            end
            else if(cnt=='d0)begin
                Busy=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.FV_data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt=nx_cnt+'d2;
            end
            else begin
                Busy=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.FV_data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt=nx_cnt+'d2;
            end

    endcase
end
endmodule


