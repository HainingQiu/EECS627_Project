
module FV_info_MEMcntl(
    input clk,
    input reset,
    input empty,
    input FIFO2FV_info_MEM_CNTL FIFO2FV_info_MEM_CNTL_in,
    input FV_FIFO2FV_info_MEM_CNTL FV_FIFO2FV_info_MEM_CNTL_in,
    input FV_Info_SRAM2CNTL FV_Info_SRAM2CNTL_in,
    input sos,
    input eos,
    input FV_Info_Bank0_data,

    output FV_info_CNTL2SRAM_Interface FV_info_CNTL2SRAM_Interface_out,
    output FV_info_MEM_CNTL2FIFO FV_info_MEM_CNTL2FIFO_out,
    output FV_info2FV_FIFO FV_info2FV_FIFO_out
);
//FV_info_SRAM  each line has 12 bits for addr, {8 bits,4 bits offset}
typedef enum reg[1:0] {
IDLE='d0,
Fetch_val='d1,
Prepare
} state_t;
state_t state,nx_state;

// FV_info_CNTL2SRAM_Interface reg_FV_info_CNTL2SRAM_Interface_out;
FV_info2FV_FIFO nx_FV_info2FV_FIFO_out;

logic[$clog2(`Num_Edge_PE)-1:0] reg_PE_tag,nx_PE_tag;
logic reg_eos;
logic[$clog2(256):0] prepare_wr_addr,nx_prepare_wr_addr;
logic data_valid;
// FV_info_MEM_CNTL2FIFO nx_FV_info_MEM_CNTL2FIFO_out;
always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
        state<=#1 IDLE;

        FV_info2FV_FIFO_out<=#1 'd0;
        reg_PE_tag<=#1 'd0;
        reg_eos<=#1 'd0;
        prepare_wr_addr<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;

        FV_info2FV_FIFO_out<=#1 nx_FV_info2FV_FIFO_out;
        reg_PE_tag<=#1 nx_PE_tag;
        reg_eos<=#1 state!=Prepare ?1'b0 :reg_eos? 1'b1: eos;
        prepare_wr_addr<=#1 nx_prepare_wr_addr;

    end
end
always_comb begin
    nx_PE_tag=reg_PE_tag;
    nx_FV_info2FV_FIFO_out='d0;
    // nx_FV_info_MEM_CNTL2FIFO_out='d0;
    FV_info_MEM_CNTL2FIFO_out='d0;
    FV_info_CNTL2SRAM_Interface_out.A='d0;
    FV_info_CNTL2SRAM_Interface_out.CEN=1'b1;
    FV_info_CNTL2SRAM_Interface_out.WEN=1'b1;
    nx_prepare_wr_addr=prepare_wr_addr;
    nx_state=state;
    case(state)
        IDLE:
            if(sos)begin
                nx_state=Prepare;
            end
            else if(FIFO2FV_info_MEM_CNTL_in.valid)begin
                nx_state=Fetch_val;
                FV_info_CNTL2SRAM_Interface_out.A=FIFO2FV_info_MEM_CNTL_in.Node_id;
                FV_info_CNTL2SRAM_Interface_out.CEN=1'b0;
                FV_info_CNTL2SRAM_Interface_out.WEN=1'b1;
                nx_PE_tag=FIFO2FV_info_MEM_CNTL_in.PE_tag;
            end
            else if(!empty && !FV_FIFO2FV_info_MEM_CNTL_in.full)begin
                FV_info_MEM_CNTL2FIFO_out.rinc=1'b1;
                nx_state=IDLE;
            end
            else begin
                nx_state=IDLE;
            end
         Prepare:
                begin

                    if(prepare_wr_addr=='d256)begin
                        FV_info_CNTL2SRAM_Interface_out.WEN='d1;
                        if(reg_eos )begin
                            nx_state=IDLE;
                            nx_prepare_wr_addr='d0;
                        end
                    end
                    else if(reg_eos && data_valid)begin
                        FV_info_CNTL2SRAM_Interface_out.WEN='d0;
                        FV_info_CNTL2SRAM_Interface_out.A=prepare_wr_addr;
                      
                        FV_info_CNTL2SRAM_Interface_out.CEN='d0;
                        nx_prepare_wr_addr='d0;
                        nx_state=IDLE;
                    end

                    else if(data_valid)begin
                        nx_state=Prepare;
                        FV_info_CNTL2SRAM_Interface_out.WEN='d0;
                        FV_info_CNTL2SRAM_Interface_out.A=prepare_wr_addr;
                        
                        FV_info_CNTL2SRAM_Interface_out.CEN='d0;
                        nx_prepare_wr_addr=prepare_wr_addr+1'd1;
                    end
                
                end

        Fetch_val: begin
                nx_FV_info2FV_FIFO_out.valid=1'b1;
                nx_FV_info2FV_FIFO_out.FV_addr=FV_Info_SRAM2CNTL_in.D;
                nx_FV_info2FV_FIFO_out.PE_tag=reg_PE_tag; 
                nx_state=IDLE;
		end
    endcase
end

        RX#(.BW_MEM(`FV_info_bank_width))
        FV_Info_Rx(
            .clk(clk),
            // input wclk,
            .reset(reset),//rd
            // input wrst,

            .data_in(FV_Info_Bank0_data),//from TX
            .SOS(sos),
            .EOS(eos),

        // output logic wr_full,
            .valid(data_valid),
            .data_out(FV_info_CNTL2SRAM_Interface_out.Data)
        );

endmodule