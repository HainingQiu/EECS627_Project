
// `include "sys_defs.svh"
// `timescale 1 ns/1 ps

module Big_FV_BankCntl_1(
    input clk,
    input reset, 
    input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,
    input [$clog2(`Max_update_Iter)-1:0] Cur_Update_Iter,
    input [`FV_bandwidth-1:0] FV_SRAM_data,
    input [$clog2(`Max_FV_num):0] FV_num,
    input stream_begin,
    // input [`FV_bandwidth-1:0] FV_WB_data, 
    input Req2Output_SRAM_Bank req_pkt, // data write back to output buffer, either from acc_buff or vertex_buff

    // interface packet to SRAM Bank
    output Big_FV2SRAM_pkt FV2SRAM_out,

    // Stream to small feature value
    output FV_MEM2FV_Bank Big_FV2Sm_FV,

    // Read output back to Edge PE
    output FV_bank_CNTL2Edge_PE EdgePE_rd_out,

    output available

);
    typedef enum logic [1:0] {
        // logic [2:0] state;
        IDLE = 'd0,
        STREAM_ITER_FV = 'd1,
        FV_WB = 'd2,
        FV_RD_TO_EDGE = 'd3
    } state_t;

    state_t state, nx_state;

    assign available = (state == IDLE);

    // localparam IDLE = 0;
    // localparam STREAM_ITER_FV = 1;
    // localparam FV_WB = 2;
    // localparam FV_RD_TO_EDGE = 3;
    // logic [1:0] state;
    // logic [1:0] nx_state;

    logic [$clog2(`FV_SRAM_bank_cache_line)-1:0] node_offset;
    logic [$clog2(`MAX_NODE_PER_ITER_BANK):0] node_cnt;
    logic [$clog2(`MAX_NODE_PER_ITER_BANK):0] nx_node_cnt;
    // assign node_offset = node_cnt << ($clog2(`Max_FV_num/2));

    // cnt[$clog2(`Max_FV_num/`num_fv_line)-1:0]
    logic [$clog2(`Max_FV_num/(`num_fv_line)):0] cnt; // sram bank cache line per iteration = 64
    logic [$clog2(`Max_FV_num/(`num_fv_line)):0] nx_cnt;
    
    logic [$clog2(`Max_FV_num):0] total_FV_num;
    logic [$clog2(`Max_FV_num):0] nx_total_FV_num;
   
    logic [$clog2(`FV_MEM_cache_line)-1:0] iter_offset;
    logic [$clog2(`Max_replay_Iter)-1:0] cur_iter;
    logic [$clog2(`Max_replay_Iter)-1:0] nx_iter;
    logic change;

    // assign iter_offset = cur_iter << ($clog2(`FV_SRAM_bank_cache_line));
    assign change = (cur_iter != Cur_Replay_Iter);


    logic [$clog2(`FV_MEM_cache_line)-1:0] stream_addr;
    logic [$clog2(`FV_MEM_cache_line)-1:0] prev_addr;
    // assign stream_addr = cnt + node_offset + iter_offset;
    assign stream_addr = {cur_iter, node_cnt[$clog2(`MAX_NODE_PER_ITER_BANK)-1:0], cnt[$clog2(`Max_FV_num/(`num_fv_line))-1:0]};

    logic [$clog2(`Num_Edge_PE)-1:0] nx_PE_tag;
    logic [$clog2(`Num_Edge_PE)-1:0] PE_tag;

    FV_MEM2FV_Bank nx_Big_FV2Sm_FV;
    FV_bank_CNTL2Edge_PE nx_EdgePE_rd_out;

    logic [$clog2(`Max_Node_id)-1:0] curr_nodeid;
    logic [$clog2(`Max_Node_id)-1:0] nxt_nodeid;

    always_comb begin
        FV2SRAM_out.CEN = 1'b1;
        FV2SRAM_out.WEN = 1'b1;
        FV2SRAM_out.addr = 'd0;
        FV2SRAM_out.FV_data = 'd0;

        nx_Big_FV2Sm_FV.sos = 1'b0; 
        nx_Big_FV2Sm_FV.eos = 1'b0;
        nx_Big_FV2Sm_FV.FV_data = 'd0;
        nx_Big_FV2Sm_FV.A = 'd0;

        nx_EdgePE_rd_out.sos = 1'b0;
        nx_EdgePE_rd_out.eos = 1'b0;
        nx_EdgePE_rd_out.FV_data = 'd0;
        nx_EdgePE_rd_out.PE_tag = 'd0;
        nx_EdgePE_rd_out.valid='d0;
        
        nx_state = state;
        nx_iter = cur_iter;
        nx_total_FV_num = total_FV_num;
        nx_cnt = cnt;

        nx_node_cnt = node_cnt;

        nxt_nodeid = curr_nodeid;
        nx_PE_tag = PE_tag;

        case (state)
            IDLE: begin
                if (Cur_Update_Iter[0]) begin
                    if (stream_begin || change) begin
                        nx_state = STREAM_ITER_FV;
                        // nx_reg_reset = 1'b0;
                        FV2SRAM_out.CEN = 1'b0;
                        FV2SRAM_out.WEN = 1'b1;
                        // FV2SRAM_out.addr = cnt + node_offset + (Cur_Replay_Iter << ($clog2(`FV_SRAM_bank_cache_line)));
                        FV2SRAM_out.addr = {Cur_Replay_Iter, node_cnt[$clog2(`MAX_NODE_PER_ITER_BANK)-1:0], cnt[$clog2(`Max_FV_num/(`num_fv_line))-1:0]};
                        FV2SRAM_out.FV_data = 'd0;
                        nx_total_FV_num = FV_num;
                        nx_cnt = cnt + 1;
                        nx_iter = Cur_Replay_Iter;
                    end
                end else begin
                    if (req_pkt.valid) begin
                        nxt_nodeid = req_pkt.Node_id;
                        if (req_pkt.rd_wr) begin  // write back to output buffer
                            if (req_pkt.wr_eos) begin
                                nx_state = IDLE;
                            end else begin
                                nx_state = FV_WB;
                                nx_cnt = cnt + 1;
                            end
                            FV2SRAM_out.CEN = 1'b0;
                            FV2SRAM_out.WEN = 1'b0;
                            FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],{$clog2(`Max_FV_num/(`num_fv_line)){1'b0}}};
                            FV2SRAM_out.FV_data = req_pkt.data;
                        end else begin   // Edge PE read
                            nx_state = FV_RD_TO_EDGE;
                            FV2SRAM_out.CEN = 1'b0;
                            FV2SRAM_out.WEN = 1'b1;
                            FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],{$clog2(`Max_FV_num/(`num_fv_line)){1'b0}}};
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
                nx_Big_FV2Sm_FV.A = {2'b00, prev_addr[$clog2(`FV_MEM_cache_line)-3:0]};
                // {2'b00, node_cnt[$clog2(`MAX_NODE_PER_ITER_BANK)-1:0], cnt[$clog2(`Max_FV_num/2)-1:0]-1};
                // cnt[$clog2(`Max_FV_num/2)-1:0]-1;

                if ((cnt == 1) && (node_cnt == 0)) begin
                    nx_Big_FV2Sm_FV.sos = 1'b1;
                    nx_cnt = cnt + 1;   
                end 
                
                if ({cnt,{$clog2(`num_fv_line){1'b0}}} >= total_FV_num) begin
                    // FV2SRAM_out.CEN = 1'b0; 
                    if (node_cnt == (`NODE_PER_ITER_BANK-1)) begin // `FV_SRAM_bank_cache_line-1
                        nx_Big_FV2Sm_FV.eos = 1'b1;
                        nx_state = IDLE;
                        nx_cnt = 'd0;
                        nx_node_cnt = 'd0;
                        FV2SRAM_out.CEN = 1'b1; 
                    end else begin
                        FV2SRAM_out.CEN = 1'b0;
                        // FV2SRAM_out.addr = {cur_iter, nx_node_cnt[$clog2(`MAX_NODE_PER_ITER_BANK)-1:0], {$clog2(`Max_FV_num/2){1'b0}}};
                        nx_node_cnt = node_cnt + 1;
                        nx_cnt = 'd1;
                        FV2SRAM_out.addr = {cur_iter, nx_node_cnt[$clog2(`MAX_NODE_PER_ITER_BANK)-1:0], {$clog2(`Max_FV_num/(`num_fv_line)){1'b0}}};
                    end
                end else begin
                    // Big_FV2Sm_FV.sos = 1'b0;
                    // Big_FV2Sm_FV.eos = 1'b0; 
                    nx_cnt = cnt + 1;
                end
                
                // Configure output to small FV
                nx_Big_FV2Sm_FV.FV_data = FV_SRAM_data;
                // Big_FV2Sm_FV.A = node_offset+cnt-1;

            end
            FV_WB: begin

                FV2SRAM_out.CEN = 1'b0;
                FV2SRAM_out.WEN = 1'b0;
               // FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],3'b000} + cnt;
                FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],cnt[$clog2(`Max_FV_num/(`num_fv_line))-1:0]};
                FV2SRAM_out.FV_data = req_pkt.data;
                nx_cnt = cnt + 1;
                if (req_pkt.wr_eos) begin
                    nx_state = IDLE;
                    nx_cnt='d0;
                end
            end
            FV_RD_TO_EDGE: begin
                nx_EdgePE_rd_out.valid='d1;
                if (cnt == 1) begin
                    nx_EdgePE_rd_out.sos = 1'b1;
                end else begin
                    nx_EdgePE_rd_out.sos = 1'b0;
                end

                if ({cnt,2'd0} >= total_FV_num) begin // `FV_SRAM_bank_cache_line-1
                    nx_EdgePE_rd_out.eos = 1'b1;
                    nx_state = IDLE;
                    nx_cnt = 'd0;
                end else begin
                    nx_EdgePE_rd_out.eos = 1'b0;
                    nx_cnt = cnt + 1;

                    FV2SRAM_out.CEN = 1'b0;
                    FV2SRAM_out.WEN = 1'b1;
                    // FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],3'd0} + cnt; // the last 3'd0 is because each node feature value takes 8 lines
                    // FV2SRAM_out.addr = {req_pkt.Node_id[$clog2(`Max_Node_id)-1:2],cnt[$clog2(`Max_FV_num/2)-1:0]};
                    FV2SRAM_out.addr = {curr_nodeid[$clog2(`Max_Node_id)-1:2],cnt[$clog2(`Max_FV_num/(`num_fv_line))-1:0]};
                    FV2SRAM_out.FV_data = 'd0;
                end
                nx_EdgePE_rd_out.FV_data = FV_SRAM_data;
                nx_EdgePE_rd_out.PE_tag = PE_tag;
            end
        endcase
    
    end


    always_ff @(posedge clk) begin
        if (reset) begin
            cnt <= #1 'd0;
            state <= #1 IDLE;
            // Big_FV2Sm_FV <= 0;
            cur_iter <= #1 'd0;
            node_cnt <= #1 'd0;
            total_FV_num <= #1 'd0;
            PE_tag <= #1 'd0;
            prev_addr <= #1 'd0; // {2'b00, stream_addr[$clog2(`FV_MEM_cache_line)-3:0]};
            Big_FV2Sm_FV <= #1 'd0;
            EdgePE_rd_out <= #1 'd0;
            curr_nodeid <= #1 'd0;
        end else begin
            // total_FV_line <= nx_total_FV_line;
            state <= #1 nx_state;
            cnt <= #1 nx_cnt;
            node_cnt <= #1 nx_node_cnt;
            cur_iter <= #1 nx_iter;
            total_FV_num <= #1 nx_total_FV_num;
            PE_tag <= #1 nx_PE_tag;
            prev_addr <= #1 FV2SRAM_out.addr; // {2'b00, stream_addr[$clog2(`FV_MEM_cache_line)-3:0]};
            Big_FV2Sm_FV <= #1 nx_Big_FV2Sm_FV;
            EdgePE_rd_out <= #1 nx_EdgePE_rd_out;
            curr_nodeid <= #1 nxt_nodeid;
        end
    end

    
endmodule