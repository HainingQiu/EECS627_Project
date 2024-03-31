module RX#(parameter BW_MEM=64)(
    input clk,
    // input wclk,
    input reset,//rd
    // input wrst,

    input data_in,//from TX
    input SOS,
    input EOS,

   // output logic wr_full,
    output logic valid,
    output logic[BW_MEM-1:0]data_out
);
typedef enum reg [1:0] {
IDLE='d0,
Read_state='d1,//read data out from fifo
Wait_wr_complete='d2//wait cntl to write
} state_Rd;
typedef enum reg [1:0]{
IDLE_wr='d0,
Wr2FIFO='d1,
Wr_Stall='d2
} state_Wr;
state_Rd state_rd, nx_state_rd;
state_Wr state_wr, nx_state_wr;
logic [BW_MEM-1:0] wdata,data_lock,nx_data_lock;
logic [$clog2(BW_MEM)-1:0] cnt,nx_cnt;
logic winc,rinc,wfull,rempty;
always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
        state_rd<=#1 IDLE;
        state_wr<=#1 IDLE_wr;
        cnt<=#1 'd0;
        data_lock<=#1 'd0;
    end
    else begin
        state_rd<=#1 nx_state_rd;
        state_wr<=#1 nx_state_wr;
        cnt<=#1 nx_cnt;
        data_lock<=#1 nx_data_lock;
    end
end
always_comb begin
    nx_data_lock=data_lock;
    nx_cnt=cnt;
    nx_state_rd=state_rd;
    nx_state_wr=state_wr;
    valid='d0;
   // data_out='d0;
    wdata='d0;
    winc=1'b0;
    rinc=1'b0;
    case(state_wr)
        IDLE_wr:   
            if(SOS)begin
                nx_state_wr=Wr2FIFO;
                nx_cnt=nx_cnt+1;
                nx_data_lock={data_in,data_lock[BW_MEM-1:1]};
            end
            else begin
                nx_state_wr=IDLE_wr;
            end
        Wr2FIFO:
            if(EOS)begin
                nx_state_wr=IDLE_wr;
                nx_cnt='d0;
                wdata={data_in,data_lock[BW_MEM-1:1]};
                winc=1'b1;
            end
            else if(cnt==BW_MEM-1)begin
                nx_cnt='d0;
                nx_data_lock={data_in,data_lock[BW_MEM-1:1]};
                if(wfull)begin
                    nx_cnt=cnt;
                    nx_data_lock=data_lock;
                    nx_state_wr=Wr_Stall;
                end 
                else begin
                    wdata={data_in,data_lock[BW_MEM-1:1]};
                    winc=1'b1;
                end
            end
            else begin
                nx_state_wr=Wr2FIFO;
                nx_cnt=nx_cnt+1;
                nx_data_lock={data_in,data_lock[BW_MEM-1:1]};
            end    
        Wr_Stall:
            if(!wfull)begin
                    wdata=data_lock;
                    winc=1'b1;
                    nx_state_wr=Wr2FIFO;
            end
            else begin
                    nx_cnt=cnt;
                    nx_data_lock=data_lock;
                    nx_state_wr=Wr_Stall;
            end
    endcase

    case(state_rd)
        IDLE:
            if(!rempty)begin
                rinc=1'b1;
                nx_state_rd=Read_state;
            end
            else begin
                nx_state_rd=IDLE;
            end
        Read_state:
            begin
                nx_state_rd=Wait_wr_complete;
                // data_out=rdata;
                valid=1'b1;
            end


        Wait_wr_complete:
            if(!rempty)begin
                rinc=1'b1;
                nx_state_rd=Read_state;
            end
            else begin
                nx_state_rd=IDLE;
            end

    endcase

end
 SPI_Sync_FIFO#(
	.WIDTH(BW_MEM),
	.DEPTH(2)
)
SPI_Sync_FIFO_RX(
	.clk(clk), 
	.rst(reset),
	.winc(winc),
	.rinc(rinc),
	.wdata(wdata),

	.wfull(wfull),
	.rempty(rempty)	,
	.rdata(data_out)
);
endmodule