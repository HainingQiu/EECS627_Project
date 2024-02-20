module Output_BUS(
    input clk,
    input reset,
    input FV_bank_CNTL2Edge_PE[`Num_Banks_FV-1:0] Output_bank_CNTL2Edge_PE_in,
    output Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out
);
Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] nx_Output_SRAM2Edge_PE_out;

always_ff@(posedge clk)begin
    if(reset)begin
        Output_SRAM2Edge_PE_out<=#1 'd0;
    end
    else begin
        Output_SRAM2Edge_PE_out<=#1 nx_Output_SRAM2Edge_PE_out;
    end
end
always_comb begin
    nx_Output_SRAM2Edge_PE_out='d0;
    for (int i=0;i<`Num_Banks_FV;i++)begin
        if(Output_bank_CNTL2Edge_PE_in[i].valid)begin
            nx_Output_SRAM2Edge_PE_out[Output_bank_CNTL2Edge_PE_in[i].PE_tag].sos=Output_bank_CNTL2Edge_PE_in[i].sos;
            nx_Output_SRAM2Edge_PE_out[Output_bank_CNTL2Edge_PE_in[i].PE_tag].eos=Output_bank_CNTL2Edge_PE_in[i].eos;
            nx_Output_SRAM2Edge_PE_out[Output_bank_CNTL2Edge_PE_in[i].PE_tag].FV_data=Output_bank_CNTL2Edge_PE_in[i].FV_data;
        end

    end
end

endmodule