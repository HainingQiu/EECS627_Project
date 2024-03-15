// `include "sys_defs.svh"
// `timescale 1 ns/1 ps

module Big_FV_wrapper_0(
    input clk,
    input reset,
    input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,
    input [$clog2(`Max_update_Iter)-1:0] Cur_Update_Iter,
    input [$clog2(`Max_FV_num):0] FV_num, 
    input req_pkt_valid_0,
    input [$clog2(`Num_Edge_PE)-1:0]req_pkt_PE_tag_0,
    input req_pkt_rd_wr_0,
    input [$clog2(`Max_Node_id)-1:0]req_pkt_Node_id_0,
    input req_pkt_data_0,
    input req_pkt_wr_sos_0,
    input req_pkt_wr_eos_0,

    input req_pkt_valid_1,
    input [$clog2(`Num_Edge_PE)-1:0]req_pkt_PE_tag_1,
    input req_pkt_rd_wr_1,
    input [$clog2(`Max_Node_id)-1:0]req_pkt_Node_id_1,
    input req_pkt_data_1,
    input req_pkt_wr_sos_1,
    input req_pkt_wr_eos_1,

    input req_pkt_valid_2,
    input [$clog2(`Num_Edge_PE)-1:0]req_pkt_PE_tag_2,
    input req_pkt_rd_wr_2,
    input [$clog2(`Max_Node_id)-1:0]req_pkt_Node_id_2,
    input req_pkt_data_2,
    input req_pkt_wr_sos_2,
    input req_pkt_wr_eos_2,

    input req_pkt_valid_3,
    input [$clog2(`Num_Edge_PE)-1:0]req_pkt_PE_tag_3,
    input req_pkt_rd_wr_3,
    input [$clog2(`Max_Node_id)-1:0]req_pkt_Node_id_3,
    input req_pkt_data_3,
    input req_pkt_wr_sos_3,
    input req_pkt_wr_eos_3,

    input stream_begin,

    output logic Big_FV2Sm_FV_sos_0,
    output logic Big_FV2Sm_FV_eos_0,
    output logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_0,
    output logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_0,

    output logic Big_FV2Sm_FV_sos_1,
    output logic Big_FV2Sm_FV_eos_1,
    output logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_1,
    output logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_1,

    output logic Big_FV2Sm_FV_sos_2,
    output logic Big_FV2Sm_FV_eos_2,
    output logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_2,
    output logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_2,

    output logic Big_FV2Sm_FV_sos_3,
    output logic Big_FV2Sm_FV_eos_3,
    output logic [`FV_bandwidth-1:0] Big_FV2Sm_FV_FV_data_3,
    output logic[`FV_info_bank_width-2-1:0] Big_FV2Sm_FV_A_3,


    output logic EdgePE_rd_out_sos_0,
    output logic EdgePE_rd_out_eos_0,
    output logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_0,
    output logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_0,
    output logic EdgePE_rd_out_valid_0,

    output logic EdgePE_rd_out_sos_1,
    output logic EdgePE_rd_out_eos_1,
    output logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_1,
    output logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_1,
    output logic EdgePE_rd_out_valid_1,


    output logic EdgePE_rd_out_sos_2,
    output logic EdgePE_rd_out_eos_2,
    output logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_2,
    output logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_2,
    output logic EdgePE_rd_out_valid_2,

    output logic EdgePE_rd_out_sos_3,
    output logic EdgePE_rd_out_eos_3,
    output logic [$clog2(`Num_Edge_PE)-1:0] EdgePE_rd_out_PE_tag_3,
    output logic [`FV_bandwidth-1:0] EdgePE_rd_out_FV_data_3,
    output logic EdgePE_rd_out_valid_3,
    output available
);


Req2Output_SRAM_Bank [`Num_Banks_all_FV-1:0] req_pkt;

FV_MEM2FV_Bank [`Num_Banks_all_FV-1:0] Big_FV2Sm_FV;
FV_bank_CNTL2Edge_PE [`Num_Banks_all_FV-1:0] EdgePE_rd_out;



assign req_pkt[0].valid=req_pkt_valid_0;
assign req_pkt[0].PE_tag=req_pkt_PE_tag_0;
assign req_pkt[0].rd_wr=req_pkt_rd_wr_0;
assign req_pkt[0].Node_id=req_pkt_Node_id_0;
assign req_pkt[0].data=req_pkt_data_0;
assign req_pkt[0].wr_sos=req_pkt_wr_sos_0;
assign req_pkt[0].wr_eos=req_pkt_wr_eos_0;

assign req_pkt[1].valid=req_pkt_valid_1;
assign req_pkt[1].PE_tag=req_pkt_PE_tag_1;
assign req_pkt[1].rd_wr=req_pkt_rd_wr_1;
assign req_pkt[1].Node_id=req_pkt_Node_id_1;
assign req_pkt[1].data=req_pkt_data_1;
assign req_pkt[1].wr_sos=req_pkt_wr_sos_1;
assign req_pkt[1].wr_eos=req_pkt_wr_eos_1;

assign req_pkt[2].valid=req_pkt_valid_2;
assign req_pkt[2].PE_tag=req_pkt_PE_tag_2;
assign req_pkt[2].rd_wr=req_pkt_rd_wr_2;
assign req_pkt[2].Node_id=req_pkt_Node_id_2;
assign req_pkt[2].data=req_pkt_data_2;
assign req_pkt[2].wr_sos=req_pkt_wr_sos_2;
assign req_pkt[2].wr_eos=req_pkt_wr_eos_2;

assign req_pkt[3].valid=req_pkt_valid_3;
assign req_pkt[3].PE_tag=req_pkt_PE_tag_3;
assign req_pkt[3].rd_wr=req_pkt_rd_wr_3;
assign req_pkt[3].Node_id=req_pkt_Node_id_3;
assign req_pkt[3].data=req_pkt_data_3;
assign req_pkt[3].wr_sos=req_pkt_wr_sos_3;
assign req_pkt[3].wr_eos=req_pkt_wr_eos_3;



assign Big_FV2Sm_FV_sos_0=Big_FV2Sm_FV[0].sos;
assign Big_FV2Sm_FV_eos_0=Big_FV2Sm_FV[0].eos;
assign Big_FV2Sm_FV_FV_data_0=Big_FV2Sm_FV[0].FV_data;
assign Big_FV2Sm_FV_A_0=Big_FV2Sm_FV[0].A;


assign Big_FV2Sm_FV_sos_1=Big_FV2Sm_FV[1].sos;
assign Big_FV2Sm_FV_eos_1=Big_FV2Sm_FV[1].eos;
assign Big_FV2Sm_FV_FV_data_1=Big_FV2Sm_FV[1].FV_data;
assign Big_FV2Sm_FV_A_1=Big_FV2Sm_FV[1].A;


assign Big_FV2Sm_FV_sos_2=Big_FV2Sm_FV[2].sos;
assign Big_FV2Sm_FV_eos_2=Big_FV2Sm_FV[2].eos;
assign Big_FV2Sm_FV_FV_data_2=Big_FV2Sm_FV[2].FV_data;
assign Big_FV2Sm_FV_A_2=Big_FV2Sm_FV[2].A;


assign Big_FV2Sm_FV_sos_3=Big_FV2Sm_FV[3].sos;
assign Big_FV2Sm_FV_eos_3=Big_FV2Sm_FV[3].eos;
assign Big_FV2Sm_FV_FV_data_3=Big_FV2Sm_FV[3].FV_data;
assign Big_FV2Sm_FV_A_3=Big_FV2Sm_FV[3].A;

assign EdgePE_rd_out_sos_0=EdgePE_rd_out[0].sos;
assign EdgePE_rd_out_eos_0=EdgePE_rd_out[0].eos;
assign EdgePE_rd_out_PE_tag_0=EdgePE_rd_out[0].PE_tag;
assign EdgePE_rd_out_FV_data_0=EdgePE_rd_out[0].FV_data;
assign EdgePE_rd_out_valid_0=EdgePE_rd_out[0].valid;

assign EdgePE_rd_out_sos_1=EdgePE_rd_out[1].sos;
assign EdgePE_rd_out_eos_1=EdgePE_rd_out[1].eos;
assign EdgePE_rd_out_PE_tag_1=EdgePE_rd_out[1].PE_tag;
assign EdgePE_rd_out_FV_data_1=EdgePE_rd_out[1].FV_data;
assign EdgePE_rd_out_valid_1=EdgePE_rd_out[1].valid;

assign EdgePE_rd_out_sos_2=EdgePE_rd_out[2].sos;
assign EdgePE_rd_out_eos_2=EdgePE_rd_out[2].eos;
assign EdgePE_rd_out_PE_tag_2=EdgePE_rd_out[2].PE_tag;
assign EdgePE_rd_out_FV_data_2=EdgePE_rd_out[2].FV_data;
assign EdgePE_rd_out_valid_2=EdgePE_rd_out[2].valid;

assign EdgePE_rd_out_sos_3=EdgePE_rd_out[3].sos;
assign EdgePE_rd_out_eos_3=EdgePE_rd_out[3].eos;
assign EdgePE_rd_out_PE_tag_3=EdgePE_rd_out[3].PE_tag;
assign EdgePE_rd_out_FV_data_3=EdgePE_rd_out[3].FV_data;
assign EdgePE_rd_out_valid_3=EdgePE_rd_out[3].valid;
    /*
        For Each Buffer:
        1. As Ping Buffer, stream output to small FV according to Replay Iter num
        2. As Pong Buffer, each bank accepts small FV to replay iteration
    */


    // logic [`Num_Banks_all_FV-1:0] [$clog2(`FV_MEM_cache_line)-1:0] cntl2RAM_addr;
    logic [`Num_Banks_all_FV-1:0] [`FV_bandwidth-1:0 ] FV_SRAM_DATA;

    Big_FV2SRAM_pkt [`Num_Banks_all_FV-1:0] FV2SRAM_out;

    logic [`Num_Banks_all_FV-1:0] available_array;
    assign available = &available_array;

    generate // ping buffer cntl + sram
        genvar i;
        for (i = 0; i < `Num_Banks_all_FV; i++) begin:Big_FV_BankCntl_0_DUT
            Big_FV_BankCntl_0 Big_FV_BankCntl_i_0 (
                .clk(clk),
                .reset(reset),
                .Cur_Replay_Iter(Cur_Replay_Iter),
                .Cur_Update_Iter(Cur_Update_Iter),
                .FV_SRAM_data(FV_SRAM_DATA[i]),
                .FV_num(FV_num),
                .req_pkt(req_pkt[i]),
                .stream_begin(stream_begin),
                .FV2SRAM_out(FV2SRAM_out[i]),
                .Big_FV2Sm_FV(Big_FV2Sm_FV[i]), 
                .EdgePE_rd_out(EdgePE_rd_out[i]),
                .available(available_array[i])
            );
        end 
   
        // genvar i;
        for (i = 0; i < `Num_Banks_all_FV; i++) begin : ping_buffer
            BIG_FV_SRAM_64 BIG_FV_SRAM_u(
                .Q(FV_SRAM_DATA[i]), // output 
                .CLK(clk),
                .CEN(FV2SRAM_out[i].CEN),
                .WEN(FV2SRAM_out[i].WEN),
                .A(FV2SRAM_out[i].addr),
                .D(FV2SRAM_out[i].FV_data)
            );
        end
    endgenerate

    // generate
    //     genvar i;
    //     for (i = 0; i < `Num_Banks_all_FV; i++) begin : pong_buffer
    //         RA1SHD BIG_FV_SRAM(
    //             .Q(FV_SRAM_DATA[i]), // output 
    //             .CLK(clk),
    //             .CEN(1'b0),
    //             .WEN(1'b1),
    //             .A(cntl2RAM_addr[i]),
    //             .D()
    //         );
    //     end
    // endgenerate              
    
endmodule