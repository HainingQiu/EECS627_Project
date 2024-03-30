module Output_BUS(
    input clk,
    input reset,
    // input FV_bank_CNTL2Edge_PE[`Num_Banks_FV-1:0] Output_bank_CNTL2Edge_PE_in,
    input Output_bank_CNTL2Edge_PE_in_0_sos,
    input Output_bank_CNTL2Edge_PE_in_0_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_0_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_0_FV_data,
    input Output_bank_CNTL2Edge_PE_in_0_valid,

    input Output_bank_CNTL2Edge_PE_in_1_sos,
    input Output_bank_CNTL2Edge_PE_in_1_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_1_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_1_FV_data,
    input Output_bank_CNTL2Edge_PE_in_1_valid,

    input Output_bank_CNTL2Edge_PE_in_2_sos,
    input Output_bank_CNTL2Edge_PE_in_2_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_2_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_2_FV_data,
    input Output_bank_CNTL2Edge_PE_in_2_valid,

    input Output_bank_CNTL2Edge_PE_in_3_sos,
    input Output_bank_CNTL2Edge_PE_in_3_eos,
    input [$clog2(`Num_Edge_PE)-1:0]Output_bank_CNTL2Edge_PE_in_3_PE_tag,
    input [`FV_bandwidth-1:0] Output_bank_CNTL2Edge_PE_in_3_FV_data,
    input Output_bank_CNTL2Edge_PE_in_3_valid,


    // output Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out
    output logic Output_SRAM2Edge_PE_out_0_sos,
    output logic Output_SRAM2Edge_PE_out_0_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_0_FV_data,

    output logic Output_SRAM2Edge_PE_out_1_sos,
    output logic Output_SRAM2Edge_PE_out_1_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_1_FV_data,

    output logic Output_SRAM2Edge_PE_out_2_sos,
    output logic Output_SRAM2Edge_PE_out_2_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_2_FV_data,

    output logic Output_SRAM2Edge_PE_out_3_sos,
    output logic Output_SRAM2Edge_PE_out_3_eos,
    output logic [`FV_bandwidth-1:0]  Output_SRAM2Edge_PE_out_3_FV_data

);
Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] nx_Output_SRAM2Edge_PE_out;
FV_bank_CNTL2Edge_PE[`Num_Banks_FV-1:0] Output_bank_CNTL2Edge_PE_in;
Output_SRAM2Edge_PE[`Num_Edge_PE-1:0] Output_SRAM2Edge_PE_out;
assign Output_bank_CNTL2Edge_PE_in[0].sos=Output_bank_CNTL2Edge_PE_in_0_sos;
assign Output_bank_CNTL2Edge_PE_in[0].eos=Output_bank_CNTL2Edge_PE_in_0_eos;
assign Output_bank_CNTL2Edge_PE_in[0].PE_tag=Output_bank_CNTL2Edge_PE_in_0_PE_tag;
assign Output_bank_CNTL2Edge_PE_in[0].FV_data=Output_bank_CNTL2Edge_PE_in_0_FV_data;
assign Output_bank_CNTL2Edge_PE_in[0].valid=Output_bank_CNTL2Edge_PE_in_0_valid;

assign Output_bank_CNTL2Edge_PE_in[1].sos=Output_bank_CNTL2Edge_PE_in_1_sos;
assign Output_bank_CNTL2Edge_PE_in[1].eos=Output_bank_CNTL2Edge_PE_in_1_eos;
assign Output_bank_CNTL2Edge_PE_in[1].PE_tag=Output_bank_CNTL2Edge_PE_in_1_PE_tag;
assign Output_bank_CNTL2Edge_PE_in[1].FV_data=Output_bank_CNTL2Edge_PE_in_1_FV_data;
assign Output_bank_CNTL2Edge_PE_in[1].valid=Output_bank_CNTL2Edge_PE_in_1_valid;

assign Output_bank_CNTL2Edge_PE_in[2].sos=Output_bank_CNTL2Edge_PE_in_2_sos;
assign Output_bank_CNTL2Edge_PE_in[2].eos=Output_bank_CNTL2Edge_PE_in_2_eos;
assign Output_bank_CNTL2Edge_PE_in[2].PE_tag=Output_bank_CNTL2Edge_PE_in_2_PE_tag;
assign Output_bank_CNTL2Edge_PE_in[2].FV_data=Output_bank_CNTL2Edge_PE_in_2_FV_data;
assign Output_bank_CNTL2Edge_PE_in[2].valid=Output_bank_CNTL2Edge_PE_in_2_valid;

assign Output_bank_CNTL2Edge_PE_in[3].sos=Output_bank_CNTL2Edge_PE_in_3_sos;
assign Output_bank_CNTL2Edge_PE_in[3].eos=Output_bank_CNTL2Edge_PE_in_3_eos;
assign Output_bank_CNTL2Edge_PE_in[3].PE_tag=Output_bank_CNTL2Edge_PE_in_3_PE_tag;
assign Output_bank_CNTL2Edge_PE_in[3].FV_data=Output_bank_CNTL2Edge_PE_in_3_FV_data;
assign Output_bank_CNTL2Edge_PE_in[3].valid=Output_bank_CNTL2Edge_PE_in_3_valid;

assign Output_SRAM2Edge_PE_out_0_sos=Output_SRAM2Edge_PE_out[0].sos;
assign Output_SRAM2Edge_PE_out_0_eos=Output_SRAM2Edge_PE_out[0].eos;
assign Output_SRAM2Edge_PE_out_0_FV_data=Output_SRAM2Edge_PE_out[0].FV_data;

assign Output_SRAM2Edge_PE_out_1_sos=Output_SRAM2Edge_PE_out[1].sos;
assign Output_SRAM2Edge_PE_out_1_eos=Output_SRAM2Edge_PE_out[1].eos;
assign Output_SRAM2Edge_PE_out_1_FV_data=Output_SRAM2Edge_PE_out[1].FV_data;

assign Output_SRAM2Edge_PE_out_2_sos=Output_SRAM2Edge_PE_out[2].sos;
assign Output_SRAM2Edge_PE_out_2_eos=Output_SRAM2Edge_PE_out[2].eos;
assign Output_SRAM2Edge_PE_out_2_FV_data=Output_SRAM2Edge_PE_out[2].FV_data;

assign Output_SRAM2Edge_PE_out_3_sos=Output_SRAM2Edge_PE_out[3].sos;
assign Output_SRAM2Edge_PE_out_3_eos=Output_SRAM2Edge_PE_out[3].eos;
assign Output_SRAM2Edge_PE_out_3_FV_data=Output_SRAM2Edge_PE_out[3].FV_data;

always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
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