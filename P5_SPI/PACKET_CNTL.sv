

// typedef struct packed {
// 	  logic wen;
//   
//     logic[$clog2(`Max_packet_line)-1:0] SRAM_addr;
//     logic [`packet_size-1:0] SRAM_DATA;
// } PACKET_CNTL2SRAM;

module PACKET_CNTL(
    input clk,
    input reset,
    input DP2mem_packet DP2mem_packet_in,
    input Edge_PE2IMEM_CNTL[`Num_Edge_PE-1:0] Edge_PE2IMEM_CNTL_in,
    input full,
    input cntl_done,

    input Packet_Bank_data,
    input sos,
    input eos, 


    output logic wr_en,
    input replay_iter_flag,
    input fifo_stall,
    input [`packet_size-1:0] Data_SRAM_in,
    output PACKET_CNTL2SRAM  PACKET_CNTL_SRAM_out,
    output com_packet mem2fifo,
    output logic CEN

    
);
//0 wr 1read

parameter IDLE='d0, stream='d1,stall='d2,wait_fifo_stall='d3, Prepare='d4,N=5;
parameter BW_MEM=16;
logic [$clog2(N)-1:0]state,nx_state;
logic [$clog2(`Max_packet_line)-1:0] nx_re_addr,current_re_addr,stall_re_addr;
logic [$clog2(`Max_packet_line)-1:0] nx_wr_addr,current_wr_addr;
 
logic Edge_PE_WB_valid;
logic nx_wr_en;
logic data_valid;
logic[BW_MEM-1:0] data_out;
logic [$clog2(`Max_packet_line):0] prepare_wr_addr,nx_prepare_wr_addr;
logic reg_eos;

RX#(.BW_MEM(BW_MEM))
RX_Packet_CNTL(
    .clk(clk),
    // input wclk,
    .reset(reset),//rd
    // input wrst,

    .data_in(Packet_Bank_data),//from TX
    .SOS(sos),
    .EOS(eos),

   // output logic wr_full,
    .valid(data_valid),
    .data_out(data_out)
);
always_ff@(posedge clk or negedge reset)begin
    if(!reset )begin
      current_re_addr <=#1 'd0;
      current_wr_addr <=#1 'd0;
      state<=#1 IDLE;
      wr_en<=#1 'd0;
      stall_re_addr<=#1 'd0;
      prepare_wr_addr<=#1 'd0;
      reg_eos<=#1 'd0;
    end
    else if(replay_iter_flag)begin
      current_re_addr <=#1 'd0;
      current_wr_addr <=#1 'd0;
      state<=#1 stream;
        wr_en<=#1 'd0;
    stall_re_addr<=#1 'd0;
    prepare_wr_addr<=#1 nx_prepare_wr_addr;
    reg_eos<=#1 state!=Prepare ?1'b0 :reg_eos? 1'b1: eos;

    end

    else begin

      current_re_addr <=#1 full ? stall_re_addr:nx_re_addr;//|| (DP2mem_packet_in.valid )
      stall_re_addr<=#1 full ? stall_re_addr:current_re_addr;//|| Edge_PE_WB_valid
      current_wr_addr <=#1 nx_wr_addr;
      state<=#1 nx_state;
      wr_en<=#1 nx_wr_en;
    //   PACKET_CNTL_SRAM_out<= PACKET_CNTL_SRAM_out;
        prepare_wr_addr<=#1 nx_prepare_wr_addr;
    reg_eos<=#1 state!=Prepare ?1'b0 :reg_eos? 1'b1: eos;
    end
end
always_comb begin
    nx_state=state;
    nx_re_addr = current_re_addr;
    nx_wr_addr = current_wr_addr;
    PACKET_CNTL_SRAM_out.wen='d1;
    PACKET_CNTL_SRAM_out.SRAM_addr=0;
    PACKET_CNTL_SRAM_out.SRAM_DATA =0;
    mem2fifo.valid='d1;
    mem2fifo.packet = Data_SRAM_in;     
    Edge_PE_WB_valid='d0;
    nx_wr_en=0;
    nx_prepare_wr_addr=prepare_wr_addr;
    CEN='d0;
    for(int i=0;i<`Num_Edge_PE;i++)begin
        Edge_PE_WB_valid =Edge_PE_WB_valid | Edge_PE2IMEM_CNTL_in[i].valid;

    end
case(state)
  IDLE: begin 
            nx_state = sos ? Prepare:IDLE;
            nx_wr_en=0;
        end
    Prepare:
        begin
            if(prepare_wr_addr=='d256)begin
                PACKET_CNTL_SRAM_out.wen='d1;
                if(reg_eos )begin
                    nx_state=stream;
                    nx_prepare_wr_addr='d0;
                end
            end
            else if(reg_eos && data_valid)begin
                PACKET_CNTL_SRAM_out.wen='d0;
                PACKET_CNTL_SRAM_out.SRAM_addr=prepare_wr_addr;
                PACKET_CNTL_SRAM_out.SRAM_DATA =data_out;
                nx_prepare_wr_addr='d0;
                nx_state=stream;
            end

            else if(data_valid)begin
                nx_state=Prepare;
                PACKET_CNTL_SRAM_out.wen='d0;
                PACKET_CNTL_SRAM_out.SRAM_addr=prepare_wr_addr;
                PACKET_CNTL_SRAM_out.SRAM_DATA =data_out;
                nx_prepare_wr_addr=prepare_wr_addr+1'd1;
            end
        end

 stream:  begin
            
            if(DP2mem_packet_in.valid)begin 

                PACKET_CNTL_SRAM_out.wen='d0;
                PACKET_CNTL_SRAM_out.SRAM_addr=current_wr_addr;
                PACKET_CNTL_SRAM_out.SRAM_DATA =DP2mem_packet_in.packet;
                nx_wr_addr=nx_wr_addr +'d1;
                nx_wr_en='d0;
            end
            else if (Edge_PE_WB_valid) begin
                 nx_wr_en='d0;
                PACKET_CNTL_SRAM_out.wen='d0;
                PACKET_CNTL_SRAM_out.SRAM_addr=current_wr_addr;

                nx_wr_addr=nx_wr_addr +'d1;
                for(int i=0;i<`Num_Edge_PE;i++)begin
                    if(Edge_PE2IMEM_CNTL_in[i].valid)begin
                        PACKET_CNTL_SRAM_out.SRAM_DATA =Edge_PE2IMEM_CNTL_in[i].packet;
                    end
            
                end
            end
            else if (!full && !replay_iter_flag) begin
                nx_wr_en='d1;
                PACKET_CNTL_SRAM_out.wen='d1;

                PACKET_CNTL_SRAM_out.SRAM_addr=current_re_addr;
                PACKET_CNTL_SRAM_out.SRAM_DATA ='d0;
                nx_re_addr=nx_re_addr +'d1;
                mem2fifo.valid='d1;
                mem2fifo.packet = Data_SRAM_in;     
            end
        if( cntl_done) begin
            nx_state =stall;
        end
        else if (fifo_stall )begin
            nx_state =wait_fifo_stall;
        end

    end
wait_fifo_stall:begin
                if(DP2mem_packet_in.valid)begin 

                PACKET_CNTL_SRAM_out.wen='d0;
                PACKET_CNTL_SRAM_out.SRAM_addr=current_wr_addr;
                PACKET_CNTL_SRAM_out.SRAM_DATA =DP2mem_packet_in.packet;
                nx_wr_addr=nx_wr_addr +'d1;
                nx_wr_en='d0;
            end
            else if (Edge_PE_WB_valid) begin
                 nx_wr_en='d0;
                PACKET_CNTL_SRAM_out.wen='d0;
                PACKET_CNTL_SRAM_out.SRAM_addr=current_wr_addr;

                nx_wr_addr=nx_wr_addr +'d1;
                for(int i=0;i<`Num_Edge_PE;i++)begin
                    if(Edge_PE2IMEM_CNTL_in[i].valid)begin
                        PACKET_CNTL_SRAM_out.SRAM_DATA =Edge_PE2IMEM_CNTL_in[i].packet;
                    end
            
                end
            end
    nx_wr_en='d0;
    if(!fifo_stall | !full)begin
    nx_state=stream;
    end
    end

   stall : begin
           PACKET_CNTL_SRAM_out=0;
           mem2fifo =0;
            nx_wr_en=0;
            CEN='d1;
   end


endcase
end
endmodule
