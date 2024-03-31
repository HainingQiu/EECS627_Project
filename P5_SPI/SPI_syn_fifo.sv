// `include "sys_defs.svh"
module SPI_dual_port_RAM#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	 input wclk
	,input wenc
	,input  waddr
	,input [WIDTH-1:0] wdata
	,input rclk
	,input renc
	,input raddr
	,output logic[WIDTH-1:0] rdata
);

logic[WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= #1 wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <=#1 RAM_MEM[raddr];
	else begin
		rdata<=#1 'd0;
	end

end 

endmodule  

module SPI_Sync_FIFO#(
	parameter	WIDTH = 16,
	parameter 	DEPTH = 2
)(
	input 					clk		, 
	input 					rst,
	input 					winc	,
	input 			 		rinc	,
	input  [WIDTH-1:0]	wdata	,

	output logic				wfull	,
	output logic				rempty	,
	output  logic[WIDTH-1:0] rdata
);
logic [$clog2(DEPTH):0] wr_ptr, rd_ptr;
assign wfull={~wr_ptr[$clog2(DEPTH)],wr_ptr[$clog2(DEPTH)-1:0]}==rd_ptr;
assign rempty=wr_ptr==rd_ptr;
always@(posedge clk or negedge rst)begin
	if(!rst)begin
		wr_ptr<= #1'd0;
	end
	else if(winc&& !wfull)begin
		wr_ptr<= #1 wr_ptr+1'b1;
	end
	else begin
		wr_ptr<= #1 wr_ptr;
	end
end
always@(posedge clk or negedge rst)begin
	if(!rst)begin
		rd_ptr<= #1'd0;
	end
	else if(rinc&& !rempty)begin
		rd_ptr<= #1 rd_ptr+1'b1;

	end
	else begin
		rd_ptr<= #1 rd_ptr;
	end
end

SPI_dual_port_RAM 
#(
	.WIDTH(WIDTH),
	.DEPTH(DEPTH)
)tb_dual_port_RAM(
	.wclk(clk),
	.wenc(~wfull&&winc),
	.waddr(wr_ptr[0]),
	.wdata(wdata),
	.rclk(clk),
	.renc(~rempty&&rinc),
	.raddr(rd_ptr[0]),
	.rdata(rdata)
);

endmodule
