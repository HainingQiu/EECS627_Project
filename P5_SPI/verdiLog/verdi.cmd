simSetSimulator "-vcssv" -exec "./simv" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
srcTBInvokeSim
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U" -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -delim "." -win \
           $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -delim "." -win \
           $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem" -line 89 -pos 1 -win $_nTrace1
wvCreateWindow
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U" -delim "." -win $_nTrace1
srcHBDrag -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.WB_packet_arbiter" -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcTBRunSim
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomIn -win $_nWave3
wvSelectSignal -win $_nWave3 {( "G1" 1 )} 
wvSetPosition -win $_nWave3 {("G1" 1)}
wvExpandBus -win $_nWave3
wvSetPosition -win $_nWave3 {("G1/Weight_CNTL_U" 14)}
wvScrollUp -win $_nWave3 3
wvScrollUp -win $_nWave3 233
wvSetCursor -win $_nWave3 11039.014374 -snap {("G1" 2)}
debExit
