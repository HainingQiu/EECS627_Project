// `include "sys_defs.svh"
module FV_Bank_MEMCntl(
input clk,
input reset,
input [$clog2(`Max_FV_num):0] Num_FV,
input FV_MEM_CNTL2FV_Bank_CNTL FV_MEM_CNTL2FV_Bank_CNTL_in,
input FV_MEM2FV_Bank  FV_MEM2FV_Bank_in,
input [`FV_bandwidth-1:0 ] FV_SRAM_DATA,

output FV_bank2SRAM_Interface FV_bank2SRAM_Interface_out,
output FV_bank_CNTL2Edge_PE FV_bank_CNTL2Edge_PE_out,
output logic Busy
);

typedef enum reg [1:0] {
IDLE='d0,
Stream='d1,
Write_FV='d2
} state_t;
state_t state,nx_state;


FV_bank2SRAM_Interface reg_FV_bank2SRAM_Interface_out;
logic[$clog2(`Max_FV_num):0] cnt,nx_cnt;
logic [$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_reg_PE_tag;
FV_bank_CNTL2Edge_PE nx_FV_bank_CNTL2Edge_PE_out;
always_ff @(posedge clk)begin
    if(reset)begin
        state<=#1 IDLE;
        reg_PE_tag<=#1 'd0;
        FV_bank_CNTL2Edge_PE_out<=#1 'd0;
        reg_FV_bank2SRAM_Interface_out.A<=#1 'd0;
        reg_FV_bank2SRAM_Interface_out.CEN<=#1 'd1;
        reg_FV_bank2SRAM_Interface_out.WEN<=#1 'd1;
        reg_FV_bank2SRAM_Interface_out.D<=#1 'd0;
        cnt<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;
        reg_PE_tag<=#1 nx_reg_PE_tag;
        reg_FV_bank2SRAM_Interface_out<=#1 FV_bank2SRAM_Interface_out;
        FV_bank_CNTL2Edge_PE_out<=#1 nx_FV_bank_CNTL2Edge_PE_out;
        cnt<=#1 nx_cnt;
    end
end
always_comb begin
    nx_cnt=cnt;
    FV_bank2SRAM_Interface_out=reg_FV_bank2SRAM_Interface_out;
    nx_FV_bank_CNTL2Edge_PE_out='d0;
    Busy='d0;
    nx_reg_PE_tag=reg_PE_tag;
    case(state)
        IDLE: 
            if(FV_MEM2FV_Bank_in.sos)begin
                nx_state=Write_FV;
                FV_bank2SRAM_Interface_out.WEN=1'b0;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.A=FV_MEM2FV_Bank_in.A;
                FV_bank2SRAM_Interface_out.D=FV_MEM2FV_Bank_in.FV_data;
            end
            else if(FV_MEM_CNTL2FV_Bank_CNTL_in.valid)begin
                nx_state=Stream;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.A=FV_MEM_CNTL2FV_Bank_CNTL_in.FV_Bank_addr;
                nx_reg_PE_tag=FV_MEM_CNTL2FV_Bank_CNTL_in.PE_tag;
            end 
            else begin
                nx_state=IDLE;
                FV_bank2SRAM_Interface_out.CEN=1'b1;
                FV_bank2SRAM_Interface_out.WEN=1'b1;
            end
        Write_FV:
            if(FV_MEM2FV_Bank_in.eos)begin
                nx_state=IDLE;
                FV_bank2SRAM_Interface_out.WEN=1'b0;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.A=FV_MEM2FV_Bank_in.A;
                FV_bank2SRAM_Interface_out.D=FV_MEM2FV_Bank_in.FV_data;
            end
            else begin
                FV_bank2SRAM_Interface_out.WEN=1'b0;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.A=FV_MEM2FV_Bank_in.A;
                FV_bank2SRAM_Interface_out.D=FV_MEM2FV_Bank_in.FV_data;

            end
        Stream:
            if(Num_FV<'d3)begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_FV_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_FV_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_FV_bank_CNTL2Edge_PE_out.FV_data=Num_FV[0]?{8'd0,FV_SRAM_DATA[7:0]}:FV_SRAM_DATA;
                nx_FV_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_FV_bank_CNTL2Edge_PE_out.valid=1'b1;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.WEN=1'b1;
                nx_cnt='d0;
            end
            else if(cnt[$clog2(`Max_FV_num):1]==Num_FV[$clog2(`Max_FV_num):1])begin
                nx_state=IDLE;
                Busy=1'b0;
                nx_FV_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_FV_bank_CNTL2Edge_PE_out.eos=1'b1;
                nx_FV_bank_CNTL2Edge_PE_out.FV_data=Num_FV[0]?{8'd0,FV_SRAM_DATA[7:0]}:FV_SRAM_DATA;
                nx_FV_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_FV_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_cnt='d0;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.WEN=1'b1;
            end
            else if(cnt=='d0)begin
                Busy=1'b1;
                nx_FV_bank_CNTL2Edge_PE_out.sos=1'b1;
                nx_FV_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_FV_bank_CNTL2Edge_PE_out.FV_data=FV_SRAM_DATA;
                nx_FV_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_FV_bank_CNTL2Edge_PE_out.valid=1'b1;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.WEN=1'b1;
                FV_bank2SRAM_Interface_out.A=FV_bank2SRAM_Interface_out.A+1'b1;
                nx_cnt=nx_cnt+'d2;
            end
            else begin
                Busy=1'b1;
                nx_FV_bank_CNTL2Edge_PE_out.sos=1'b0;
                nx_FV_bank_CNTL2Edge_PE_out.eos=1'b0;
                nx_FV_bank_CNTL2Edge_PE_out.FV_data=FV_SRAM_DATA;
                nx_FV_bank_CNTL2Edge_PE_out.PE_tag=nx_reg_PE_tag;
                nx_FV_bank_CNTL2Edge_PE_out.valid=1'b1;
                nx_cnt=nx_cnt+'d2;
                FV_bank2SRAM_Interface_out.CEN=1'b0;
                FV_bank2SRAM_Interface_out.WEN=1'b1;
                FV_bank2SRAM_Interface_out.A=FV_bank2SRAM_Interface_out.A+1'b1;
            end
        default:
            begin
                nx_state=IDLE;
                nx_cnt='d0;
                FV_bank2SRAM_Interface_out='d0;
                nx_FV_bank_CNTL2Edge_PE_out='d0;
                Busy='d0;
                nx_reg_PE_tag='d0;
                FV_bank2SRAM_Interface_out.CEN=1'b1;
                FV_bank2SRAM_Interface_out.WEN=1'b1;
            end

    endcase
end
endmodule


