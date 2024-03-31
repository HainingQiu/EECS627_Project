simSetSimulator "-vcssv" -exec "./simv" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
srcTBInvokeSim
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.PACKET_SRAM_integration_U" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U" -win $_nTrace1
wvCreateWindow
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.decoder_0" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.PACKET_CNTL_0" -win \
           $_nTrace1
srcSetScope "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.PACKET_CNTL_0" -delim "." \
           -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.PACKET_CNTL_0" -win \
           $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.IMem_Sram_U" -win \
           $_nTrace1
srcSetScope "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.IMem_Sram_U" -delim "." \
           -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.IMem_Sram_U" -win \
           $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
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
wvZoom -win $_nWave3 1076566.735113 167944410.677618
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
srcHBSelect \
           "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.PACKET_CNTL_0.RX_Packet_CNTL" \
           -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.PACKET_CNTL_0" -win \
           $_nTrace1
srcSetScope "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.PACKET_CNTL_0" -delim "." \
           -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.PACKET_SRAM_integration_U.PACKET_CNTL_0" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "nx_state" -line 130 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
srcDeselectAll -win $_nTrace1
srcSelect -signal "prepare_wr_addr" -line 119 -pos 1 -win $_nTrace1
debExit
