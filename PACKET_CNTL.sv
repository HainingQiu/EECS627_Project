
module PACKET_CNTL(
    input clk,
    input reset,
    input DP2mem_packet DP2mem_packet_in,
    input Edge_PE2IMEM_CNTL Edge_PE2IMEM_CNTL_in,
    input full,
    input [$clog2(`Max_replay_Iter)-1:0]  replay_Iter,
    input replay_iter_flag,
    input [`packet_size-1:0] Data_SRAM_in,
    output PACKET_CNTL2SRAM  PACKET_CNTL_SRAM_out,
    output com_packet mem2fifo,
    output logic[1:0] TB_state
    
);


parameter IDLE='d0, stream='d1,stall='d2;
logic [1:0]state,nx_state;
logic [$clog2(`Max_packet_line)-1:0] nx_re_addr,current_re_addr;
logic [$clog2(`Max_packet_line)-1:0] nx_wr_addr,current_wr_addr;
assign TB_state=state;
always_ff@(posedge clk)begin
    if(reset | replay_iter_flag)begin
      current_re_addr <='d0;
      current_wr_addr <='d0;
      state<=IDLE;
    end
    else begin
      current_re_addr <=nx_re_addr;
      current_wr_addr <=nx_wr_addr;
      state<=nx_state;
    end
end
always_comb begin
    nx_state=state;
    nx_re_addr = current_re_addr;
    nx_wr_addr = current_wr_addr;
    PACKET_CNTL_SRAM_out=0;
    mem2fifo =0;
case(state)
  IDLE: nx_state = reset ? IDLE : stream;
 stream:  begin
        if(DP2mem_packet_in.valid)begin 
            PACKET_CNTL_SRAM_out.re_valid='d0;
            PACKET_CNTL_SRAM_out.wr_valid='d1;
            PACKET_CNTL_SRAM_out.SRAM_addr=current_wr_addr;
            PACKET_CNTL_SRAM_out.SRAM_DATA =DP2mem_packet_in.packet;
            nx_wr_addr=nx_wr_addr +'d1;
        end
        else if (Edge_PE2IMEM_CNTL_in.valid) begin
            PACKET_CNTL_SRAM_out.re_valid='d0;
            PACKET_CNTL_SRAM_out.wr_valid='d1;
            PACKET_CNTL_SRAM_out.SRAM_addr=current_wr_addr;
            PACKET_CNTL_SRAM_out.SRAM_DATA =Edge_PE2IMEM_CNTL_in.packet;
            nx_wr_addr=nx_wr_addr +'d1;
        end
        else if (!full) begin
            PACKET_CNTL_SRAM_out.re_valid='d1;
            PACKET_CNTL_SRAM_out.wr_valid='d0;
            PACKET_CNTL_SRAM_out.SRAM_addr=current_re_addr;
            PACKET_CNTL_SRAM_out.SRAM_DATA ='d0;
            nx_re_addr=nx_re_addr +'d1;
            mem2fifo.valid='d1;
            mem2fifo.packet = Data_SRAM_in;     
        end
        if( replay_iter_flag && replay_Iter=='d3) begin
            nx_state =stall;
        end
    end
   stall : begin
           PACKET_CNTL_SRAM_out=0;
           mem2fifo =0;
   end


endcase
end
endmodule