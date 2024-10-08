module Neighbor_Bank_MEMCntl(

input clk,
input reset,
input Neighbor_MEM_CNTL2Neighbor_Bank_CNTL Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in,
// input FV_MEM2FV_Bank  FV_MEM2FV_Bank_in,
input [`Neighbor_ID_bandwidth-1:0] Neighbor_SRAM_DATA,
input sos,
input eos,
input Neighbor_ID_Bank_data,

output Neighbor_bank2SRAM_Interface Neighbor_bank2SRAM_Interface_out,
output Neighbor_bank_CNTL2Edge_PE Neighbor_bank_CNTL2Edge_PE_out,
output logic Busy
);
typedef enum reg[1:0] {
IDLE='d0,
Stream='d1,
Prepare='d2
} state_t;
state_t state,nx_state;

Neighbor_bank2SRAM_Interface reg_Neighbor_bank2SRAM_Interface;
// logic[`Neighbor_addr_length-1:0] reg_Stream_addr, nx_Stream_addr;
logic[$clog2(`max_degree_Iter)-1:0] cnt,nx_cnt;
logic [$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_reg_PE_tag;
Neighbor_bank_CNTL2Edge_PE nx_Neighbor_bank_CNTL2Edge_PE_out;
logic [$clog2(`max_degree_Iter):0] Num_neighbor_Iter,nx_Num_neighbor_Iter;
logic reg_eos;
logic data_valid;
logic [$clog2(512):0] prepare_wr_addr,nx_prepare_wr_addr;
always_ff @(posedge clk or negedge reset)begin
    if(!reset)begin
        state<=#1 IDLE;
        reg_PE_tag<=#1 'd0;
        Num_neighbor_Iter<=#1 'd0;

        reg_Neighbor_bank2SRAM_Interface.CEN <=#1 1'b1;
        reg_Neighbor_bank2SRAM_Interface.WEN <=#1 1'b1;
        reg_Neighbor_bank2SRAM_Interface.A<=#1 'd0;
        cnt<=#1 'd0;
        reg_eos<=#1 'd0;
        prepare_wr_addr<=#1 'd0;

    end
    else begin
        state<=#1 nx_state;
        reg_PE_tag<=#1 nx_reg_PE_tag;
        Num_neighbor_Iter<=#1 nx_Num_neighbor_Iter;
        // Neighbor_bank2SRAM_Interface_out<=#1 nx_Neighbor_bank2SRAM_Interface;
        reg_Neighbor_bank2SRAM_Interface<=#1 Neighbor_bank2SRAM_Interface_out;
        Neighbor_bank_CNTL2Edge_PE_out<=#1 nx_Neighbor_bank_CNTL2Edge_PE_out;
        cnt<=#1 nx_cnt;
        reg_eos<=#1 state!=Prepare ?1'b0 :reg_eos? 1'b1: eos;
        prepare_wr_addr<=#1 nx_prepare_wr_addr;
    end
end
always_comb begin
	nx_state = state; // default to avoid latch
    nx_cnt=cnt;
    nx_Neighbor_bank_CNTL2Edge_PE_out='d0;
    // nx_Neighbor_bank2SRAM_Interface=Neighbor_bank2SRAM_Interface_out;
    Busy='d0;
    nx_reg_PE_tag=reg_PE_tag;
    nx_Num_neighbor_Iter=Num_neighbor_Iter;
    // Neighbor_bank2SRAM_Interface_out=reg_Neighbor_bank2SRAM_Interface;
    Neighbor_bank2SRAM_Interface_out.CEN=reg_Neighbor_bank2SRAM_Interface.CEN;
    Neighbor_bank2SRAM_Interface_out.WEN=reg_Neighbor_bank2SRAM_Interface.WEN;
    Neighbor_bank2SRAM_Interface_out.A=reg_Neighbor_bank2SRAM_Interface.A;
    nx_prepare_wr_addr=prepare_wr_addr;

    case(state)
        IDLE: 
            if(sos)begin
                nx_state=Prepare;
            end
            else if(Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.valid)begin
                nx_state=Stream;
                Neighbor_bank2SRAM_Interface_out.CEN=1'b0;
                Neighbor_bank2SRAM_Interface_out.WEN = 1'b1;
                Neighbor_bank2SRAM_Interface_out.A=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`Neighbor_info_bandwidth-1-2:`start_bit_addr_neighbor];         
              //  nx_Num_neighbor_Iter=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[0]?Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`start_bit_addr_neighbor-1:0]+1'b1 :Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`start_bit_addr_neighbor-1:0];
                nx_Num_neighbor_Iter=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.Bank_addr[`start_bit_addr_neighbor-1:0]+1'b1;
                nx_reg_PE_tag=Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in.PE_tag;
                nx_cnt=nx_cnt+`num_neighbor_id;
            end 
            else begin
                nx_state=IDLE;
                Neighbor_bank2SRAM_Interface_out.CEN=1'b1;
                Neighbor_bank2SRAM_Interface_out.WEN=1'b1;
            end
        Prepare:
                begin
                   
                    if(prepare_wr_addr=='d512)begin
                        Neighbor_bank2SRAM_Interface_out.WEN='d1;
                        if(reg_eos )begin
                            nx_state=IDLE;
                            nx_prepare_wr_addr='d0;
                        end
                    end
                    else if(reg_eos && data_valid)begin
                        Neighbor_bank2SRAM_Interface_out.WEN='d0;
                        Neighbor_bank2SRAM_Interface_out.A=prepare_wr_addr;
                      
                        Neighbor_bank2SRAM_Interface_out.CEN='d0;
                        nx_prepare_wr_addr='d0;
                        nx_state=IDLE;
                    end

                    else if(data_valid)begin
                        nx_state=Prepare;
                        Neighbor_bank2SRAM_Interface_out.WEN='d0;
                        Neighbor_bank2SRAM_Interface_out.A=prepare_wr_addr;
                        
                        Neighbor_bank2SRAM_Interface_out.CEN='d0;
                        nx_prepare_wr_addr=prepare_wr_addr+1'd1;
                    end
                    else begin
                        Neighbor_bank2SRAM_Interface_out.WEN='d1;
                        Neighbor_bank2SRAM_Interface_out.A=prepare_wr_addr;
                        
                        Neighbor_bank2SRAM_Interface_out.CEN='d1;
                    end
                
                end

        Stream:
            if(nx_Num_neighbor_Iter<=`num_neighbor_id)begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=Neighbor_SRAM_DATA;//nx_Num_neighbor_Iter[0]?{7'd0,Neighbor_SRAM_DATA[6:0]}:
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt='d0;
                Neighbor_bank2SRAM_Interface_out.CEN=1'b0;
                Neighbor_bank2SRAM_Interface_out.WEN= 1'b1;
            end
             else if(cnt==`num_neighbor_id)begin
                Busy=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt=nx_cnt+`num_neighbor_id;
                Neighbor_bank2SRAM_Interface_out.CEN=1'b0;
                Neighbor_bank2SRAM_Interface_out.WEN= 1'b1;
                Neighbor_bank2SRAM_Interface_out.A=Neighbor_bank2SRAM_Interface_out.A+1'b1;
            end
            else if(cnt>=nx_Num_neighbor_Iter)begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=Neighbor_SRAM_DATA;//nx_Num_neighbor_Iter[0]?{7'd0,Neighbor_SRAM_DATA[6:0]}:
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt='d0;
                Neighbor_bank2SRAM_Interface_out.CEN= 1'b0;
                Neighbor_bank2SRAM_Interface_out.WEN= 1'b1;
            end

            else begin
                Busy=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_Neighbor_bank_CNTL2Edge_PE_out.data=Neighbor_SRAM_DATA;
                nx_Neighbor_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_Neighbor_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_Neighbor_bank_CNTL2Edge_PE_out.Neighbor_num_Iter=nx_Num_neighbor_Iter;
                nx_cnt=nx_cnt+`num_neighbor_id;
                Neighbor_bank2SRAM_Interface_out.CEN=1'b0;
                Neighbor_bank2SRAM_Interface_out.WEN= 1'b1;
                Neighbor_bank2SRAM_Interface_out.A=Neighbor_bank2SRAM_Interface_out.A+1'b1;
            end
    endcase
end

        RX#(.BW_MEM(`Neighbor_ID_bandwidth))
        Neighbor_ID_Rx(
            .clk(clk),
            // input wclk,
            .reset(reset),//rd
            // input wrst,

            .data_in(Neighbor_ID_Bank_data),//from TX
            .SOS(sos),
            .EOS(eos),

        // output logic wr_full,
            .valid(data_valid),
            .data_out(Neighbor_bank2SRAM_Interface_out.Data)
        );
endmodule


