simSetSimulator "-vcssv" -exec "./simv" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
srcTBInvokeSim
srcDeselectAll -win $_nTrace1
srcSelect -signal "reset" -line 5 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 5 -pos 1 -win $_nTrace1
srcHBSelect "Top_tb.Neighbor_ID_Bank0_TX" -win $_nTrace1
srcSetScope "Top_tb.Neighbor_ID_Bank0_TX" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.Neighbor_ID_Bank0_TX" -win $_nTrace1
wvCreateWindow
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT" -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT" -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U" -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U" -delim "." -win \
           $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U" -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\]" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\]" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\]" \
           -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U" \
           -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx" \
           -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx.SPI_Sync_FIFO_RX" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx.SPI_Sync_FIFO_RX" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx.SPI_Sync_FIFO_RX" \
           -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx.SPI_Sync_FIFO_RX.tb_dual_port_RAM" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx.SPI_Sync_FIFO_RX.tb_dual_port_RAM" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx.SPI_Sync_FIFO_RX.tb_dual_port_RAM" \
           -win $_nTrace1
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\]" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\]" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\]" \
           -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\].Neighbor_SRAM_U" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\].Neighbor_SRAM_U" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\].Neighbor_SRAM_U" \
           -win $_nTrace1
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
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U/Neighbor_ID_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Neighbor_SRAM_U" \
           3 )} 
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U/Neighbor_ID_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Neighbor_SRAM_U" \
           3 )} 
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U/Neighbor_ID_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Neighbor_SRAM_U" \
           4 )} 
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoom -win $_nWave3 2287704.312115 51136919.917865
wvZoom -win $_nWave3 2688929.902305 18737953.509943
wvScrollUp -win $_nWave3 28
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" \
           8 )} 
wvSetPosition -win $_nWave3 \
           {("Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" 8)}
wvExpandBus -win $_nWave3
wvSetPosition -win $_nWave3 \
           {("Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U/Neighbor_ID_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Neighbor_SRAM_U" 6)}
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" \
           10 )} 
srcHBSelect "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_MEM_CNTL_U" \
           -win $_nTrace1
srcSetScope "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_MEM_CNTL_U" \
           -delim "." -win $_nTrace1
srcHBSelect "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_MEM_CNTL_U" \
           -win $_nTrace1
wvZoom -win $_nWave3 1532401.638101 3361397.141641
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoom -win $_nWave3 0.000000 1990487.919664
wvZoom -win $_nWave3 1085163.331973 1416230.111219
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" \
           8 )} 
wvSetPosition -win $_nWave3 \
           {("Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" 8)}
wvCollapseBus -win $_nWave3
wvSetPosition -win $_nWave3 \
           {("Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" 8)}
wvSetPosition -win $_nWave3 \
           {("Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U/Neighbor_ID_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Neighbor_SRAM_U" 6)}
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" \
           8 )} 
wvSetPosition -win $_nWave3 \
           {("Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" 8)}
wvExpandBus -win $_nWave3
wvSetPosition -win $_nWave3 \
           {("Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U/Neighbor_ID_Rx/SPI_Sync_FIFO_RX/tb_dual_port_RAM/Neighbor_SRAM_U" 6)}
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoom -win $_nWave3 1022432.106747 1427598.021389
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" \
           7 )} 
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" \
           8 )} 
wvSelectSignal -win $_nWave3 \
           {( "Neighbor_ID_Bank0_TX/S_Neighbor_SRAM_integration_U/Neighbor_Bank_MEMCntl[0]/Neighbor_Bank_MEMCntl_U" \
           7 )} 
wvZoomOut -win $_nWave3
wvSetCursor -win $_nWave3 1351057.437925 -snap {("Neighbor_Bank_MEMCntl_U" 12)}
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\]" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\]" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\]" \
           -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.Neighbor_Bank_MEMCntl\[0\].Neighbor_Bank_MEMCntl_U.Neighbor_ID_Rx.SPI_Sync_FIFO_RX.tb_dual_port_RAM" \
           -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\].Neighbor_SRAM_U" \
           -win $_nTrace1
srcSetScope \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\].Neighbor_SRAM_U" \
           -delim "." -win $_nTrace1
srcHBSelect \
           "Top_tb.iTop_DUT.S_Neighbor_SRAM_integration_U.SRAM_Instantiations\[0\].Neighbor_SRAM_U" \
           -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "mem" -line 89 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave3
wvSaveSignal -win $_nWave3 "/home/zzyyds/EECS627_Project/P5_SPI/signal.rc"
debExit
