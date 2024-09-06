Code			8B13B 
Error Check		CRC (CRC-16-CCITT)
Packe Size		65Byte/Packet
Bit Width 		160ns/1bit
Bit Length		933bit (Preamble 36bit,StartBit 4bit, Data 65x13=845bit, CRC 48bit)  
Signal Width 		10us (Data Request & Receive Request)


FPGA_RP_CONNECT.pdf:	Wiring Diagram of FPGA-RaspberryPi	
DE0NanoSoc_TXRX.qpf:	Quartus Project file
DE0NanoSoc_TXRX.v:	Main Code
spi_slave.v:		Code of  SPI SLAVE 
8B13B.h: 		Table of 8B13B
8B13BConvert.h: 	Look up Table of 8B13B Convert
8B13BInvert.h:		Look up Table of 8B13B Invert
ClockBridge.qsys:	IP of clockbridge
DE0NanoSoc_TXRX.sdc:	Synopsys Design Constraints
output_file.cof:	Setting file of Converter from  to DE0NanoSoc_TXRX.pof to output_file64.jic
output_file128.cof:	Setting file of Converter from  to DE0NanoSoc_TXRX.pof to output_file128.jic


