// `include "sys_defs.svh"
module dual_port_RAM(
	 input wclk
	,input wenc
	,input [$clog2(`DEPTH_FV_FIFO)-1:0] waddr
	,input FV_info2FV_FIFO wdata
	,input rclk
	,input renc
	,input [$clog2(`DEPTH_FV_FIFO)-1:0] raddr
	,output FV_info2FV_FIFO rdata
);

FV_info2FV_FIFO[`DEPTH_FV_FIFO-1:0] RAM_MEM;

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= #1  wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <= #1 RAM_MEM[raddr];
	else begin
		rdata<= #1 'd0;
	end

end 

endmodule  

module FV_Sync_FIFO(
	input 					clk		, 
	input 					rst,
	input 					winc	,
	input 			 		rinc	,
	input FV_info2FV_FIFO	wdata	,

	output logic				wfull	,
	output logic				rempty	,
	output FV_info2FV_FIFO rdata
);
reg [$clog2(`DEPTH_FV_FIFO):0] wr_ptr, rd_ptr;
assign wfull={~wr_ptr[$clog2(`DEPTH_FV_FIFO)],wr_ptr[$clog2(`DEPTH_FV_FIFO)-1:0]}==rd_ptr;
assign rempty=wr_ptr==rd_ptr;
always@(posedge clk)begin
	if(rst)begin
		wr_ptr<= #1 'd0;
	end
	else if(winc&& !wfull)begin
		wr_ptr<= #1  wr_ptr+1'b1;
	end
	else begin
		wr_ptr<= #1  wr_ptr;
	end
end
always@(posedge clk)begin
	if(rst)begin
		rd_ptr<= #1 'd0;
	end
	else if(rinc&& !rempty)begin
		rd_ptr<= #1  rd_ptr+1'b1;
	end
	else begin
		rd_ptr<= #1  rd_ptr;
	end
end

dual_port_RAM tb_dual_port_RAM(
	.wclk(clk),
	.wenc(~wfull&&winc),
	.waddr(wr_ptr[$clog2(`DEPTH_FV_FIFO)-1:0]),
	.wdata(wdata),
	.rclk(clk),
	.renc(~rempty&&rinc),
	.raddr(rd_ptr[$clog2(`DEPTH_FV_FIFO)-1:0]),
	.rdata(rdata)
);

endmodule