// `include "sys_defs.svh"
module Bus_Arbiter
(
input clk,															// global clock
input reset,														// sync active high reset
input Req_Bus_arbiter[`Num_Edge_PE-1:0] Req_Bus_arbiter_in,			// input request from PE

output Grant_Bus_arbiter[`Num_Edge_PE-1:0] Grant_Bus_arbiter_out,
output BUS2FV_info_FIFO BUS2FV_info_MEM_CNTL_out,
output BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_out
// output BUS2Output_SRAM_MEM_CNTL BUS2Output_SRAM_MEM_CNTL_out
);
logic [`Num_Edge_PE-1:0] local_req, local_grant;
BUS2FV_info_FIFO nx_BUS2FV_info_MEM_CNTL_out;
Req_Bus_arbiter granted_Req_Bus_arbiter_in;
Req_Bus_arbiter[`Num_Edge_PE-1:0] reg_Req_Bus_arbiter_in;
BUS2Neighbor_info_MEM_CNTL nx_BUS2Neighbor_info_MEM_CNTL_out;
// BUS2Output_SRAM_MEM_CNTL nx_BUS2Output_SRAM_MEM_CNTL_out;
always_ff@(posedge clk)begin
    if(reset)begin
        reg_Req_Bus_arbiter_in<=#1 'd0;
        BUS2FV_info_MEM_CNTL_out<=#1 'd0;
        BUS2Neighbor_info_MEM_CNTL_out<=#1 'd0;
        // BUS2Output_SRAM_MEM_CNTL_out<=#1 'd0;
    end
    else begin
        reg_Req_Bus_arbiter_in<=#1 Req_Bus_arbiter_in;
        BUS2FV_info_MEM_CNTL_out<=#1 nx_BUS2FV_info_MEM_CNTL_out;
        BUS2Neighbor_info_MEM_CNTL_out<=#1 nx_BUS2Neighbor_info_MEM_CNTL_out;
        // BUS2Output_SRAM_MEM_CNTL_out<=#1 nx_BUS2Output_SRAM_MEM_CNTL_out;
    end

end
always_comb begin
    nx_BUS2FV_info_MEM_CNTL_out='d0;
    nx_BUS2Neighbor_info_MEM_CNTL_out='d0;
    // nx_BUS2Output_SRAM_MEM_CNTL_out='d0;
    
    for(int i=0; i<`Num_Edge_PE;i++)begin
        if(granted_Req_Bus_arbiter_in[i])begin
            case(reg_Req_Bus_arbiter_in[i].req_type)
                'b0: begin
					nx_BUS2Neighbor_info_MEM_CNTL_out.valid=1'b1;
					//nx_BUS2Neighbor_info_MEM_CNTL_out.rd_wr_en=1'b0;
					nx_BUS2Neighbor_info_MEM_CNTL_out.Node_id=reg_Req_Bus_arbiter_in[i].Node_id;
					nx_BUS2Neighbor_info_MEM_CNTL_out.PE_tag=reg_Req_Bus_arbiter_in[i].PE_tag;
				end

                'b1: begin
					nx_BUS2FV_info_MEM_CNTL_out.valid=1'b1;
					//nx_BUS2FV_info_MEM_CNTL_out.rd_wr_en=1'b0;
					nx_BUS2FV_info_MEM_CNTL_out.Node_id=reg_Req_Bus_arbiter_in[i].Node_id;
					nx_BUS2FV_info_MEM_CNTL_out.PE_tag=reg_Req_Bus_arbiter_in[i].PE_tag;
				end 

                // 'b10: begin
				// 	nx_BUS2Output_SRAM_MEM_CNTL_out.valid=1'b1;
				// 	//nx_BUS2Output_SRAM_MEM_CNTL_out.rd_wr_en=1'b0;
				// 	nx_BUS2Output_SRAM_MEM_CNTL_out.Node_id=reg_Req_Bus_arbiter_in[i].Node_id;
				// 	nx_BUS2Output_SRAM_MEM_CNTL_out.PE_tag=reg_Req_Bus_arbiter_in[i].PE_tag;
                // end
                default: begin
					
				end				
            endcase
        end
    end

end
//may don't need this

// local packed array


for (genvar i = 0; i < `Num_Edge_PE; i++) begin
	assign local_req[i] = Req_Bus_arbiter_in[i].req;
	assign local_grant[i] = Grant_Bus_arbiter_out[i].Grant;
end

rr_arbiter
#(.num_reqs(`Num_Edge_PE))
rr_arbiter_U0(
    .clk(clk),
    .reset(reset),
    .reqs(local_req),//[`Num_Edge_PE-1:0][$bits(Req_Bus_arbiter_in)-1]),
    .grants(local_grant)
);



endmodule