simSetSimulator "-vcssv" -exec "./simv" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
verdiWindowResize -win $_Verdi_1 "820" "362" "900" "723"
srcDeselectAll -win $_nTrace1
srcSelect -signal "Neighbor_ID_Bank3_data" -line 16 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvCreateWindow
wvDrop -win $_nWave3
srcTBInvokeSim
srcHBSelect "Top_tb.Weight_Bank_TX" -win $_nTrace1
srcSetScope "Top_tb.Weight_Bank_TX" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.Weight_Bank_TX" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx" -delim "." -win \
           $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx.SPI_Sync_FIFO_RX" -win \
           $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx.SPI_Sync_FIFO_RX" \
           -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx.SPI_Sync_FIFO_RX" -win \
           $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect \
           "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx.SPI_Sync_FIFO_RX.tb_dual_port_RAM" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx.SPI_Sync_FIFO_RX.tb_dual_port_RAM" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_Bank_Rx.SPI_Sync_FIFO_RX.tb_dual_port_RAM" \
           -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -delim "." -win \
           $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT" -win $_nTrace1
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
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvSelectSignal -win $_nWave3 \
           {( "Weight_Bank_TX/Weight_CNTL_U/Weight_Bank_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Weight_SRAM_DUT" \
           3 )} 
wvZoom -win $_nWave3 0.000000 304923394.243641
wvZoom -win $_nWave3 50685941.692155 123382909.856202
wvZoom -win $_nWave3 60218391.822270 83086643.397053
wvZoom -win $_nWave3 65276667.336162 70289509.237655
wvZoom -win $_nWave3 65854306.071829 67743251.132722
wvZoom -win $_nWave3 66160790.535342 574013218.875502
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvSelectSignal -win $_nWave3 \
           {( "Weight_Bank_TX/Weight_CNTL_U/Weight_Bank_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Weight_SRAM_DUT" \
           1 )} 
wvSelectSignal -win $_nWave3 \
           {( "Weight_Bank_TX/Weight_CNTL_U/Weight_Bank_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM" \
           7 )} 
wvSelectSignal -win $_nWave3 \
           {( "Weight_Bank_TX/Weight_CNTL_U/Weight_Bank_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Weight_SRAM_DUT" \
           4 )} 
wvSelectSignal -win $_nWave3 \
           {( "Weight_Bank_TX/Weight_CNTL_U/Weight_Bank_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Weight_SRAM_DUT" \
           4 )} 
wvSelectSignal -win $_nWave3 \
           {( "Weight_Bank_TX/Weight_CNTL_U/Weight_Bank_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Weight_SRAM_DUT" \
           3 )} 
wvZoom -win $_nWave3 290490306.894867 367845312.536084
wvZoom -win $_nWave3 0.000000 5993732.225180
wvZoom -win $_nWave3 1992618.262941 2984958.035322
wvSaveSignal -win $_nWave3 "/home/zzyyds/EECS627_Project/P5_SPI/signal.rc"
debExit
