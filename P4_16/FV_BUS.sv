// `include "sys_defs.svh"
module FV_BUS(

    input clk,
    input reset,
    input FV_bank_CNTL2Edge_PE[`Num_Banks_FV-1:0] FV_bank_CNTL2Edge_PE_in,
    output FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out
);
FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] nx_FV_SRAM2Edge_PE_out;

always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
        FV_SRAM2Edge_PE_out<=#1 'd0;
    end
    else begin
        FV_SRAM2Edge_PE_out<=#1 nx_FV_SRAM2Edge_PE_out;
    end
end
always_comb begin
    nx_FV_SRAM2Edge_PE_out='d0;
    for (int i=0;i<`Num_Banks_FV;i++)begin
        if(FV_bank_CNTL2Edge_PE_in[i].valid)begin
            nx_FV_SRAM2Edge_PE_out[FV_bank_CNTL2Edge_PE_in[i].PE_tag].sos=FV_bank_CNTL2Edge_PE_in[i].sos;
            nx_FV_SRAM2Edge_PE_out[FV_bank_CNTL2Edge_PE_in[i].PE_tag].eos=FV_bank_CNTL2Edge_PE_in[i].eos;
            nx_FV_SRAM2Edge_PE_out[FV_bank_CNTL2Edge_PE_in[i].PE_tag].FV_data=FV_bank_CNTL2Edge_PE_in[i].FV_data;
        end

    end
end

endmodule