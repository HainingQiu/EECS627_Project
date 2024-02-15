// `include "sys_defs.svh"
// `timescale 1 ns/1 ps

module Big_FV_wrapper_1(
    input clk,
    input reset,
    input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,
    input [$clog2(`Max_update_Iter)-1:0] Cur_Update_Iter,
    input [$clog2(`Max_FV_num)-1:0] FV_num, 
    input Req2Output_SRAM_Bank [`Num_Banks_all_FV-1:0] req_pkt,

    output FV_MEM2FV_Bank [`Num_Banks_all_FV-1:0] Big_FV2Sm_FV,
    output FV_bank_CNTL2Edge_PE [`Num_Banks_all_FV-1:0] EdgePE_rd_out 
);
    /*
        For Each Buffer:
        1. As Ping Buffer, stream output to small FV according to Replay Iter num
        2. As Pong Buffer, each bank accepts small FV to replay iteration
    */


    logic [`Num_Banks_all_FV-1:0] [$clog2(`FV_MEM_cache_line)-1:0] cntl2RAM_addr;
    logic [`Num_Banks_all_FV-1:0] [`FV_bandwidth-1:0 ] FV_SRAM_DATA;

    Big_FV2SRAM_pkt [`Num_Banks_all_FV-1:0] FV2SRAM_out;

    generate // ping buffer cntl + sram
        genvar i;
        for (i = 0; i < `Num_Banks_all_FV; i++) begin:Big_FV_BankCntl_1_DUT
            Big_FV_BankCntl_1 Big_FV_BankCntl_i_1 (
                .clk(clk),
                .reset(reset),
                .Cur_Replay_Iter(Cur_Replay_Iter),
                .Cur_Update_Iter(Cur_Update_Iter),
                .FV_SRAM_data(FV_SRAM_DATA[i]),
                .FV_num(FV_num),
                .req_pkt(req_pkt[i]),

                .FV2SRAM_out(FV2SRAM_out[i]),
                .Big_FV2Sm_FV(Big_FV2Sm_FV[i]), 
                .EdgePE_rd_out(EdgePE_rd_out[i])
            );
        end 
   

        for (i = 0; i < `Num_Banks_all_FV; i++) begin : ping_buffer
            BIG_FV_SRAM BIG_FV_SRAM_u(
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