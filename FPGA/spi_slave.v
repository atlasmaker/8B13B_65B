/*
Copyright (c) 2021, 2022, 2023 and 2024 Tokio Yukiya  
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, 
  this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation 
  and/or other materials provided with the distribution.
* Neither the name of the Tokyo Polytechnic University  nor the names of its contributors 
  may be used to endorse or promote products derived from this software 
  without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
OF THE POSSIBILITY OF SUCH DAMAGE.
*/

////////////////////////////////////////////////

`define SPI_INITIAL       3'b000
`define SPI_IDLE          3'b001
`define SPI_RECEIVE_0     3'b010
`define SPI_RECEIVE_1     3'b011
`define SPI_RECEIVE_2     3'b100
`define SPI_PREEND        3'b101
`define SPI_END           3'b110
`define SPI_DUMMY         3'b111 //
/////////////////////////////////////////////////
`define SPI_LENGTH_MSB       519     //If you hope to other bit length, you need to edit you want.
`define SPI_LENGTH           520　　　// For example: bit length 1024
`define SPI_LENGTH_RESET     520'b0  //SPI_LENGTH_MSB 1023, SPI_LENGTH 1024, SPI_LENGTH_RESET 1024'b0
/////////////////////////////////////////////////
`define SPI_COUNTER          12     //If you hope to more bit length over 2^12, you need edit to you want.
`define SPI_COUNTER_RESET    12'b0  //counter and counter_q are counting a number of bits, when signals are recieved. 
`define SPI_COUNTER_MSB      11
/////////////////////////////////////////////////
/////CPOL and CPHA are supported. 
/////Each SPI modes have been checked using PIGPIO@RspberryPi3 and CycloneV(5CSEMA4U23C6)@De0-Nano-SoC-Terasic.
/////WIRINGPI:8MHz is OK, does not work 9MHz, when clk is 50MHz.
/////PIGPIO:  5MHz is Ok, does not work 5.3MHz, when clk is 50MHz. 

module spi_slave(
    input clk,       //System clock 	
    input rst,       //Reset sigal
    input ss,        //Chip Select@SPI
    input mosi,      //MOSI@SPI
    output miso,     //MISO@SPI
    input sck,       //SCK@SPI
    output done,     //Strobe Signal
    input  [`SPI_LENGTH_MSB:0] din,  //Data in: for MISO   
    output [`SPI_LENGTH_MSB:0] dout, //Data out: for MOSI
    input cpol,      //CPOL@SPI(0/1)   MODE 0: CPOL=0, CPHA=0  MODE 2: CPOL=1, CPHA=0  
    input cpha       //CPHA@SPI(0/1)   MODE 1:CPOL=0, CPHA=1  MODE 3: CPOL=1, CPHA=1
);
reg [2:0] spi_state,spi_state_q;
reg send_recv_enable;
reg [`SPI_LENGTH_MSB:0] din_reg, dout_reg,din_q,din_reg_q, dout_reg_q;
reg [`SPI_COUNTER_MSB:0] counter,counter_q;
reg miso_reg, mosi_reg,mosi_tmp,miso_reg_q, mosi_reg_q,mosi_tmp_q;
reg sck_prev,ss_prev,sck_prev_q,ss_prev_q;
reg send_recv_strobe;
reg [7:0] sig_wid_cnt, sig_wid_cnt_q;
//reg spi_clk;
reg ss_q,mosi_q,sck_q;
reg cpha_q;
reg clk_half,clk_half_q;
wire sck_cpol,sck_cpol_i;
assign miso=miso_reg_q;
assign done=send_recv_strobe;
assign dout=dout_reg_q;
assign sck_cpol  = (cpol==1'b0) ? sck : ~sck;//CPOL
assign sck_cpol_i= (cpol==1'b0) ? 1'b0: 1'b1;//CPOL INITIALIZED

initial begin
spi_state       =`SPI_INITIAL;
spi_state_q     =`SPI_INITIAL;
din_reg         =`SPI_LENGTH_RESET;
din_reg_q       =`SPI_LENGTH_RESET;
dout_reg        =`SPI_LENGTH_RESET;
dout_reg_q      =`SPI_LENGTH_RESET;
counter         =`SPI_COUNTER_RESET;
counter_q       =`SPI_COUNTER_RESET;
send_recv_strobe=1'b0;
sck_prev=1'b0;
ss_prev=1'b0;
//spi_clk=1'b0;
mosi_q=1'b0;
ss_q=1'b0;
sck_q=sck_cpol_i; 
sck_prev_q=1'b0;
ss_prev_q=1'b0;
miso_reg_q=1'b0;
mosi_tmp=1'b0;
mosi_tmp_q=1'b0;
cpha_q<=1'b0;
sig_wid_cnt=8'b0;
sig_wid_cnt_q=8'b0;
clk_half=1'b0;
clk_half_q=1'b1;
end


//If you use signal tap, you shuld be use half_clk.
//always @(negedge clk) begin clk_half_q=clk_half; end
//always @(posedge clk) begin clk_half=~clk_half_q; end


always @(negedge clk)begin
if(rst==1'b1)begin 
mosi_q<=1'b0;
mosi_tmp_q<=1'b0;
ss_q<=1'b0;
sck_q<=1'b0;
spi_state_q<=1'b0;
sck_prev_q<=1'b0;
ss_prev_q<=1'b0;
counter_q<=`SPI_COUNTER_RESET;
miso_reg_q<=1'b0;
din_reg_q<=`SPI_LENGTH_RESET;
dout_reg_q<=`SPI_LENGTH_RESET;
cpha_q<=1'b0;
sig_wid_cnt_q<=8'd0;
end else begin 
mosi_q<=mosi;
mosi_tmp_q<=mosi_tmp;
ss_q<=ss;
ss_prev_q<=ss_prev;
sck_q<=sck_cpol;  
sck_prev_q<=sck_prev;
spi_state_q<=spi_state;
counter_q<=counter;
miso_reg_q<=miso_reg;
din_q<=din;
din_reg_q<=din_reg;
dout_reg_q<=dout_reg;
cpha_q<=cpha;
sig_wid_cnt_q<=sig_wid_cnt;
end
end

always @(posedge clk)begin 
case(spi_state_q)
`SPI_INITIAL: begin   //Initialized
   spi_state        <=`SPI_IDLE; 
   send_recv_strobe <=1'b0;
	sig_wid_cnt<=8'd0;
   din_reg          <=`SPI_LENGTH_RESET;
   counter          <=`SPI_COUNTER_RESET;
	mosi_tmp<=1'b0;
	miso_reg<=1'b0;
end

`SPI_IDLE:begin    //Waiting Chip Select Signal(Active low)
   if( (ss_prev_q==1'b1) && (ss_q==1'b0) ) begin 
	 	din_reg          <=din_q;
	   dout_reg         <=`SPI_LENGTH_RESET;
	   counter          <=`SPI_COUNTER_RESET;
	   spi_state        <=`SPI_RECEIVE_0;
		end else begin  
	 spi_state          <=`SPI_IDLE;
	end
 end

`SPI_RECEIVE_0:begin  //Positive Edge
    //MISO
    miso_reg   <=din_reg_q[`SPI_LENGTH_MSB];
    spi_state  <=`SPI_RECEIVE_1;
end 

`SPI_RECEIVE_1:begin //Negative Edge
if((sck_prev_q==1'b0) && (sck_q==1'b1)) begin
     //MISO
		din_reg             <=din_reg_q<<1'b1;
     //MOSI
//		mosi_tmp  <=mosi_q;//CATCH THE MOSI SIGNAL at Positive Edge. 20210316
		mosi_tmp  <=mosi;//CATCH THE MOSI SIGNAL at Positive Edge.
		dout_reg  <=dout_reg_q<<1;
		spi_state <=`SPI_RECEIVE_2;
end else begin
		spi_state <=`SPI_RECEIVE_1;
end
end

`SPI_RECEIVE_2:begin
if((sck_prev_q==1'b1) && (sck_q==1'b0)) begin 
		//MISO
		//MOSI		
      if(cpha_q==1'b0) begin 
          dout_reg[0] <=mosi_tmp_q;//CPHA==0
      end else begin
	  dout_reg[0] <=mosi_q;    //CPHA==1 //CATCH THE MOSI SIGNAL at Negative Edge.
      end
      counter             <=counter_q+`SPI_COUNTER'b1; 	
      if(counter_q>=`SPI_LENGTH_MSB) begin
	 send_recv_strobe <=1'b1;
	  spi_state        <=`SPI_PREEND;
	  miso_reg<=1'b0; 
      end else begin 
        miso_reg   <=din_reg_q[`SPI_LENGTH_MSB];
	spi_state        <=`SPI_RECEIVE_1;
      end
end else begin 
     spi_state        <=`SPI_RECEIVE_2;
end
end
 	
`SPI_PREEND:begin //for width of strobe signal
		if(sig_wid_cnt_q>=8'd128) begin 
			spi_state  <=`SPI_END; 
			send_recv_strobe <=1'b0;
			counter    <=`SPI_COUNTER_RESET;
		end else begin 
			sig_wid_cnt<=sig_wid_cnt_q+8'd1;		
			spi_state        <=`SPI_PREEND;
		end
 end
 `SPI_END:  begin spi_state <=`SPI_INITIAL; end
`SPI_DUMMY:begin spi_state <=`SPI_INITIAL; end
default:   begin spi_state <=`SPI_INITIAL; end
endcase
 sck_prev <= sck_q;
  ss_prev <= ss_q;
end

endmodule
