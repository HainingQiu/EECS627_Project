`define NODE_PER_ITER_BANK `Max_Node_id/(`Num_Banks_all_FV*`Max_replay_Iter)

// `include "sys_defs.svh"
// `timescale 1 ns/1 ps

module Big_FV_BankCntl_1(
    input clk,
    input reset, 
    input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,
    input [$clog2(`Max_update_Iter)-1:0] Cur_Update_Iter,
    input [`FV_bandwidth-1:0] FV_SRAM_data,
    input [$clog2(`Max_FV_num):0] FV_num,

    // input [`FV_bandwidth-1:0] FV_WB_data, 
    input Req2Output_SRAM_Bank req_pkt, // data write back to output buffer, either from acc_buff or vertex_buff

    // interface packet to SRAM Bank
    output Big_FV2SRAM_pkt FV2SRAM_out,

    // Stream to small feature value
    output FV_MEM2FV_Bank Big_FV2Sm_FV,

    // Read output back to Edge PE
    output FV_bank_CNTL2Edge_PE EdgePE_rd_out

);
    localparam IDLE = 0;
    localparam STREAM_ITER_FV = 1;
    localparam FV_WB = 2;
    localparam FV_RD_TO_EDGE = 3;
    logic [1:0] state;
    logic [1:0] nx_state;

    logic [$clog2(`FV_SRAM_bank_cache_line)-1:0] node_offset;
    logic [$clog2(`NODE_PER_ITER_BANK):0] node_cnt;
    logic [$clog2(`NODE_PER_ITER_BANK):0] nx_node_cnt;
    assign node_offset = node_cnt << ($clog2(`Max_FV_num/2));

    logic [$clog2(`Max_FV_num):0] cnt; // sram bank cache line per iteration = 64
    logic [$clog2(`Max_FV_num):0] nx_cnt;
    
    logic [$clog2(`Max_FV_num):0] total_FV_num;
    logic [$clog2(`Max_FV_num):0] nx_total_FV_num;
   
    logic [$clog2(`FV_MEM_cache_line)-1:0] iter_offset;
    logic [$clog2(`Max_replay_Iter)-1:0] cur_iter;
    logic [$clog2(`Max_replay_Iter)-1:0] nx_iter;
    logic change;

    assign iter_offset = cur_iter << ($clog2(`FV_SRAM_bank_cache_line));
    assign change = (cur_iter != Cur_Replay_Iter);


    logic [$clog2(`FV_MEM_cache_line)-1:0] stream_addr;
    assign stream_addr = cnt + node_offset + iter_offset;

    logic [$clog2(`Num_Edge_PE)-1:0] nx_PE_tag;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;


    always_comb begin
        FV2SRAM_out.CEN = 1'b1;
        FV2SRAM_out.WEN = 1'b1;
        FV2SRAM_out.addr = 'd0;
        FV2SRAM_out.FV_data = 'd0;

        Big_FV2Sm_FV.sos = 1'b0; 
        Big_FV2Sm_FV.eos = 1'b0;
        Big_FV2Sm_FV.FV_data = 'd0;
        Big_FV2Sm_FV.A = 'd0;

        EdgePE_rd_out.sos = 1'b0;
        EdgePE_rd_out.eos = 1'b0;
        EdgePE_rd_out.FV_data = 'd0;
        EdgePE_rd_out.PE_tag = 'd0;

        nx_state = state;
        nx_iter = cur_iter;
        nx_total_FV_num = total_FV_num;
        nx_cnt = cnt;

        nx_node_cnt = node_cnt;

        case (state)
            IDLE: begin
                if (Cur_Update_Iter[0]) begin
                    if ((cur_iter == 0) || change) begin
                        nx_state = STREAM_ITER_FV;
                        
                        FV2SRAM_out.CEN = 1'b0;
                        FV2SRAM_out.WEN = 1'b1;
                        FV2SRAM_out.addr = cnt + node_offset + (Cur_Replay_Iter << ($clog2(`FV_SRAM_bank_cache_line)));
                        FV2SRAM_out.FV_data = 'd0;
                        nx_total_FV_num = FV_num;
                        nx_cnt = cnt + 1;
                        nx_iter = Cur_Replay_Iter;
                    end
                end else begin
                    if (req_pkt.valid) begin
                        if (req_pkt.rd_wr) begin  // write back to output buffer
                            if (req_pkt.wr_eos) begin
                                nx_state = IDLE;
                            end else begin
                                nx_state = FV_WB;
                                nx_cnt = cnt + 1;
                            end
                            FV2SRAM_out.CEN = 1'b0;
                            FV2SRAM_out.WEN = 1'b0;
                            FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],3'd0};
                            FV2SRAM_out.FV_data = req_pkt.data;
                        end else begin   // Edge PE read
                            nx_state = FV_RD_TO_EDGE;
                            FV2SRAM_out.CEN = 1'b0;
                            FV2SRAM_out.WEN = 1'b1;
                            FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],3'd0};
                            FV2SRAM_out.FV_data = 'd0;
                            nx_total_FV_num = FV_num;
                            nx_PE_tag = req_pkt.PE_tag;
                            nx_cnt = cnt + 1;
                        end
                    end
                end
            end
            STREAM_ITER_FV: begin
                FV2SRAM_out.CEN = 1'b0;
                // FV2SRAM_out.WEN = 1'b1;
                FV2SRAM_out.addr = stream_addr;
                // FV2SRAM_out.FV_data = 'd0;

                if ((cnt == 1) && (node_cnt == 0)) begin
                    Big_FV2Sm_FV.sos = 1'b1;   
                end else if ((cnt << 1) >= total_FV_num) begin
                    if (node_cnt == (`NODE_PER_ITER_BANK-1)) begin // `FV_SRAM_bank_cache_line-1
                        Big_FV2Sm_FV.eos = 1'b1;
                        nx_state = IDLE;
                        nx_cnt = 'd0;
                        nx_node_cnt = 'd0;
                        FV2SRAM_out.CEN = 1'b1; 
                    end else begin
                        nx_node_cnt = node_cnt + 1;
                        nx_cnt = 'd0;
                    end
                end else begin
                    Big_FV2Sm_FV.sos = 1'b0;
                    Big_FV2Sm_FV.eos = 1'b0; 
                    nx_cnt = cnt + 1;
                end
                
                // Configure output to small FV
                Big_FV2Sm_FV.FV_data = FV_SRAM_data;
                Big_FV2Sm_FV.A = node_offset+cnt-1;

            end
            FV_WB: begin
                if (req_pkt.wr_eos) begin
                    nx_state = IDLE;
                end
                FV2SRAM_out.CEN = 1'b0;
                FV2SRAM_out.WEN = 1'b0;
                FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],3'd0} + cnt;
                FV2SRAM_out.FV_data = req_pkt.data;
                nx_cnt = cnt + 1;
            end
            FV_RD_TO_EDGE: begin
                if (cnt == 1) begin
                    EdgePE_rd_out.sos = 1'b1;
                end else begin
                    EdgePE_rd_out.sos = 1'b0;
                end

                if ((cnt << 1) >= total_FV_num) begin // `FV_SRAM_bank_cache_line-1
                    EdgePE_rd_out.eos = 1'b1;
                    nx_state = IDLE;
                    nx_cnt = 'd0;
                end else begin
                    EdgePE_rd_out.eos = 1'b0;
                    nx_cnt = cnt + 1;

                    FV2SRAM_out.CEN = 1'b0;
                    FV2SRAM_out.WEN = 1'b1;
                    FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],3'd0} + cnt; // the last 3'd0 is because each node feature value takes 8 lines
                    FV2SRAM_out.FV_data = 'd0;
                end
                EdgePE_rd_out.FV_data = FV_SRAM_data;
                EdgePE_rd_out.PE_tag = PE_tag;
  
            end
        endcase
    
    end


    always_ff @(posedge clk) begin
        if (!reset) begin
            cnt <= 'd0;
            state <= IDLE;
            // Big_FV2Sm_FV <= 0;
            cur_iter <= 'd0;
            node_cnt <= 'd0;
            total_FV_num <= 'd0;
            PE_tag <= 'd0;
        end else begin
            // total_FV_line <= nx_total_FV_line;
            state <= nx_state;
            cnt <= nx_cnt;
            node_cnt <= nx_node_cnt;
            cur_iter <= nx_iter;
            total_FV_num <= nx_total_FV_num;
            PE_tag <= nx_PE_tag;
        end
    end

    
endmodule