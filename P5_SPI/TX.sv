module TX#(parameter MEM_BW=64,MEM_DEPTH=256, num_valid_lines=34)(
    input wclk,
    input wrst,
    //input wfull,

    // output logic SOS,
    // output logic EOS,
    output logic data_out
);
typedef enum reg {
IDLE='d0,
Stream='d1
// Stall='d2
} state_t;
logic [MEM_BW-1:0]MEM [MEM_DEPTH-1:0];
logic [MEM_BW-1:0] lock_data,nx_lock_data;
logic[$clog2(MEM_BW)-1:0] cnt,nx_cnt;
logic [$clog2(MEM_DEPTH)-1:0] mem_idx,nx_mem_idx;
state_t state_Tx, nx_state_Tx;

always_ff@(posedge wclk or negedge wrst)begin
    if(!wrst)begin
        cnt<=#1 'd0;
        state_Tx<=#1 IDLE;
        mem_idx<=#1 'd0;
        lock_data<=#1 'd0;

    end
    else begin
        cnt<=#1 nx_cnt;
        state_Tx<=#1 nx_state_Tx;
        mem_idx<=#1 nx_mem_idx;
        lock_data<=#1 nx_lock_data;
     
    end
end
always_comb begin
    nx_state_Tx=state_Tx;
    nx_cnt=cnt;
    nx_mem_idx=mem_idx;
    data_out='d0;
    // EOS=1'b0;
    // SOS=1'b0;
    nx_lock_data=lock_data;
    case(state_Tx)
        IDLE:
        begin
            nx_lock_data=MEM[nx_mem_idx];
            if(wrst)begin
                nx_state_Tx=Stream;
                
            end
            else begin
                nx_state_Tx=IDLE;
            end
        end
        Stream:
            // if(wfull)begin
            //     nx_cnt=cnt;
            //     nx_mem_idx=mem_idx;
            //     nx_state_Tx=Stall;
            // end
            if(cnt==MEM_BW-1&&mem_idx==num_valid_lines-1)begin
               // EOS=1'b1;
                data_out=lock_data[cnt];
                nx_cnt='d0;
                nx_mem_idx='d0;
                nx_lock_data='d0;
                nx_state_Tx=IDLE;
            end
            else if(cnt=='d0&&mem_idx=='d0)begin
                //SOS=1'b1;
                nx_cnt=cnt+1'b1;
                nx_mem_idx=mem_idx;
                data_out=lock_data[cnt];
                nx_state_Tx=Stream;
            end
            else if(cnt==MEM_BW-1)begin
                nx_cnt='d0;
                nx_mem_idx=mem_idx+1'b1;
                nx_lock_data=MEM[nx_mem_idx];
                data_out=lock_data[cnt];
                nx_state_Tx=Stream;
            end
            else begin
                nx_cnt=cnt+1'b1;
                nx_mem_idx=mem_idx;
                data_out=lock_data[cnt];
                nx_state_Tx=Stream;
            end

        // Stall:
        //     if(!wfull)begin
        //         // data_out=lock_data[cnt];
        //         if(cnt==MEM_BW-1&&mem_idx==MEM_DEPTH-1)begin
        //             //EOS=1'b1;
        //             data_out=lock_data[cnt];
        //             nx_cnt='d0;
        //             nx_mem_idx='d0;
        //             nx_lock_data='d0;
        //             nx_state_Tx=IDEL;
        //         end
        //         else if(cnt==MEM_BW-1)begin
        //             nx_cnt='d0;
        //             nx_mem_idx=mem_idx+1'b1;
        //             nx_lock_data=MEM[nx_mem_idx];
        //             data_out=lock_data[cnt];
        //             nx_state_Tx=Stream;
        //         end
        //         else begin
        //             nx_cnt=cnt+1'b1;
        //             nx_mem_idx=mem_idx;
        //             data_out=lock_data[cnt];
        //             nx_state_Tx=Stream;
        //         end
        //     end
        //     else begin
        //             nx_state_Tx=Stall;
        //     end

    endcase
end
endmodule