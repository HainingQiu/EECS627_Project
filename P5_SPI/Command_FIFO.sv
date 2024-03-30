


module Command_FIFO_dual_port_RAM(
	 input wclk
	,input wenc
	,input [$clog2(`com_fifo_size)-1:0] waddr  //???2????????????
	,input com_packet wdata      	//????
	,input rclk
	,input renc
	,input [$clog2(`com_fifo_size)-1:0] raddr  //???2????????????
	,input replay_iter_flag
	,output com_packet rdata 		//????
);

 com_packet [`com_fifo_size-1:0]   RAM_MEM;

always @(posedge wclk) begin
	if(wenc )
        RAM_MEM[waddr] <= #1 wdata;

end 

always @(posedge rclk) begin
	if(renc)
		rdata <=#1 RAM_MEM[raddr];
    else 
		rdata <=#1 'd0;


end 

endmodule  
/**********************************SFIFO************************************/
module Command_FIFO(
	input 					clk		, 
	input 					reset	,
	input 					winc	,
	input 			 		rinc	,
	input                   replay_iter_flag,
	input com_packet	wdata	,

	output logic				wfull	,
	output com_packet rdata
);
reg [$clog2(`com_fifo_size):0] wr_ptr, rd_ptr;
wire rempty;
assign wfull={~wr_ptr[$clog2(`com_fifo_size)],wr_ptr[$clog2(`com_fifo_size)-1:0]}==rd_ptr;
assign rempty=wr_ptr==rd_ptr;
always@(posedge clk or negedge reset)begin
	if(!reset )begin
		wr_ptr<= #1'd0;
	end
        else if (replay_iter_flag)begin
		wr_ptr<= #1'd0;
        end
	else if(winc && !wfull)begin
		wr_ptr<= #1 wr_ptr+1'b1;
	end
	else begin
		wr_ptr<= #1 wr_ptr;
	end
end
always@(posedge clk or negedge reset)begin
	if(!reset )begin
		rd_ptr<= #1'd0;
	end
        else if (replay_iter_flag)begin
		rd_ptr<= #1'd0;
        end
	else if(rinc && !rempty)begin
		rd_ptr<= #1 rd_ptr+1'b1;
	end
	else begin
		rd_ptr<= #1 rd_ptr;
	end
end

Command_FIFO_dual_port_RAM  tb_dual_port_RAM(
	.wclk(clk),
	.wenc(~wfull&&winc),
	.waddr(wr_ptr[$clog2(`com_fifo_size)-1:0]),  //???2????????????
	.wdata(wdata),     	//????
	.rclk(clk),
	.replay_iter_flag(replay_iter_flag),
	.renc(~rempty && rinc),
	.raddr(rd_ptr[$clog2(`com_fifo_size)-1:0]),  //???2????????????
	.rdata(rdata)		//????
);

endmodule
