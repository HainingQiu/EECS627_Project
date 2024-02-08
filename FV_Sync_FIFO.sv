
module dual_port_RAM(
	 input wclk
	,input wenc
	,input [$clog2(`DEPTH_FV_FIFO)-1:0] waddr  //深度对2取对数，得到地址的位宽。
	,input FV_info2FV_FIFO wdata      	//数据写入
	,input rclk
	,input renc
	,input [$clog2(`DEPTH_FV_FIFO)-1:0] raddr  //深度对2取对数，得到地址的位宽。
	,output FV_info2FV_FIFO rdata 		//数据输出
);

logic  FV_info2FV_FIFO[`DEPTH_FV_FIFO-1:0] RAM_MEM;

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <=#1 RAM_MEM[raddr];
	else begin
		rdata<=#1 'd0;
	end

end 

endmodule  
/**********************************SFIFO************************************/
module FV_Sync_FIFO(
	input 					clk		, 
	input 					rst	,
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
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		wr_ptr<='d0;
	end
	else if(winc&& !wfull)begin
		wr_ptr<=wr_ptr+1'b1;
	end
	else begin
		wr_ptr<=wr_ptr;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		rd_ptr<='d0;
	end
	else if(rinc&& !rempty)begin
		rd_ptr<=rd_ptr+1'b1;
	end
	else begin
		rd_ptr<=rd_ptr;
	end
end

dual_port_RAM #(.DEPTH(DEPTH),
				.WIDTH(WIDTH))
tb_dual_port_RAM(
	.wclk(clk),
	.wenc(~wfull&&winc),
	.waddr(wr_ptr),  //深度对2取对数，得到地址的位宽。
	.wdata(wdata),     	//数据写入
	.rclk(clk),
	.renc(~rempty&&rinc),
	.raddr(rd_ptr),  //深度对2取对数，得到地址的位宽。
	.rdata(rdata)		//数据输出
);

endmodule