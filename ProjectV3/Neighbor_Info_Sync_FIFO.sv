
module NeighborInfo_Sync_FIFO_dual_port_RAM(
	 input wclk
	,input wenc
	,input [$clog2(`Num_Edge_PE)-1:0] waddr  //深度对2取对数，得到地址的位宽。
	,input BUS2Neighbor_info_MEM_CNTL wdata      	//数据写入
	,input rclk
	,input renc
	,input [$clog2(`Num_Edge_PE)-1:0] raddr  //深度对2取对数，得到地址的位宽。
	,output BUS2Neighbor_info_MEM_CNTL rdata 		//数据输出
);

BUS2Neighbor_info_MEM_CNTL[`Num_Edge_PE-1:0] RAM_MEM;

always_ff @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= #1 wdata;
end 

always_ff @(posedge rclk) begin
	if(renc)
		rdata <=#1 RAM_MEM[raddr];
	else begin
		rdata<=#1 'd0;
	end

end 

endmodule  
/**********************************SFIFO************************************/
module NeighborInfo_Sync_FIFO(
	input 					clk		, 
	input 					rst	,
	input 					winc	,
	input 			 		rinc	,
	input BUS2Neighbor_info_MEM_CNTL	wdata	,

	output logic				wfull	,
	output logic				rempty	,
	output BUS2Neighbor_info_MEM_CNTL rdata
);
reg [$clog2(`Num_Edge_PE):0] wr_ptr, rd_ptr;
assign wfull={~wr_ptr[$clog2(`Num_Edge_PE)],wr_ptr[$clog2(`Num_Edge_PE)-1:0]}==rd_ptr;
assign rempty=wr_ptr==rd_ptr;
always_ff@(posedge clk)begin
	if(rst)begin
		wr_ptr<= #1'd0;
	end
	else if(winc&& !wfull)begin
		wr_ptr<= #1 wr_ptr+1'b1;
	end
	else begin
		wr_ptr<= #1 wr_ptr;
	end
end
always_ff@(posedge clk)begin
	if(rst)begin
		rd_ptr<= #1 'd0;
	end
	else if(rinc&& !rempty)begin
		rd_ptr<= #1 rd_ptr+1'b1;
	end
	else begin
		rd_ptr<= #1 rd_ptr;
	end
end

NeighborInfo_Sync_FIFO_dual_port_RAM 
tb_dual_port_RAM(
	.wclk(clk),
	.wenc(~wfull&&winc),
	.waddr(wr_ptr[$clog2(`Num_Edge_PE)-1:0]),  //深度对2取对数，得到地址的位宽。
	.wdata(wdata),     	//数据写入
	.rclk(clk),
	.renc(~rempty&&rinc),
	.raddr(rd_ptr[$clog2(`Num_Edge_PE)-1:0]),  //深度对2取对数，得到地址的位宽。
	.rdata(rdata)		//数据输出
);

endmodule