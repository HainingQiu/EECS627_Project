
module RS(
    input clk,
    input reset,
    input DP_task2RS DP_task2RS_in,
    input [$clog2(`Max_replay_Iter)-1:0]  replay_Iter,
    input [`Num_Edge_PE-1:0]PE_IDLE,
    input [`Num_Edge_PE-1:0] bank_busy,
    output DP_task2Edge_PE [`Num_Edge_PE-1:0] DP_task2Edge_PE_out,
    output logic RS_empty,
    output logic RS_full
);
logic [`RS_entry-1:0] [`packet_size-1-2:0]nx_entry,current_entry;
logic [`RS_entry-1:0] nx_entry_valid,current_entry_valid;
logic weights; 
DP_task2Edge_PE DP_task2Edge_PE;
assign RS_full = &nx_entry_valid; 
assign RS_empty = ~(|nx_entry_valid); 
logic [`RS_entry-1:0][2:0] Iter;
always_ff @(posedge clk ) begin
    if(reset)begin
        current_entry <= #1  'd0;
        current_entry_valid <= #1  'd0;

    end
    else begin
        current_entry <= #1  nx_entry;
        current_entry_valid <= #1  nx_entry_valid;
    end
    
end
always_comb begin 
        weights =0;
        DP_task2Edge_PE=0;
        DP_task2Edge_PE_out=0;
        nx_entry = current_entry;
        nx_entry_valid = current_entry_valid;
        for (int i=0; i<`RS_entry;i=i+1)begin
        Iter[i] = current_entry[i][9:7];
        end
        for (int i=0; i<`RS_entry;i=i+1)begin
        weights = weights | Iter[replay_Iter];
        end

        if(|PE_IDLE && !(|bank_busy))begin
            if(!weights)begin 
                for (int i=0; i<`RS_entry;i=i+1)begin
                    if(current_entry_valid[i])begin
                        for(int j=0; j<`Num_Edge_PE;j=j+1)begin
                            if(PE_IDLE[j]&&  !bank_busy[j])begin
                                DP_task2Edge_PE_out[j].packet = current_entry[i];
                                DP_task2Edge_PE_out[j].valid  = 'd1;
                                nx_entry_valid[i] = 0;
                                nx_entry[i]=0;
                                break;
                            end
                        end


                        break;
                    end
                end
            end
            else begin 
                for (int i=0; i<`RS_entry;i=i+1)begin
                    if(current_entry_valid[i] && Iter[i][replay_Iter])begin
                        for(int j=0; j<`Num_Edge_PE;j=j+1)begin
                            if(PE_IDLE[j]&&  !bank_busy[j])begin
                                DP_task2Edge_PE_out[j].packet = current_entry[i];
                                DP_task2Edge_PE_out[j].valid  = 'd1;
                                nx_entry_valid[i] = 0;
                                nx_entry[i]=0;
                                break;
                            end
                        end
                        break;
                    end
                end
            end
        end






        if(DP_task2RS_in.valid)begin
            for (int i=0; i<`RS_entry;i=i+1)begin
            
                if(!current_entry_valid[i])begin
                    nx_entry[i] = DP_task2RS_in.packet;
                    nx_entry_valid[i] = 'd1;
                    break;
                end
            end
        end

end
endmodule