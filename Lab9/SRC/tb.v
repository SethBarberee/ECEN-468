`timescale 1ns/10ps
`include "Mainsystem.v"

module stimulus;

	parameter AddrSize = 18;
	parameter WordSize = 8;

   	reg clk;
   	wire Serial_out;
   
   	reg Breq;
   	wire Bgnt;
  
	wire [7:0]	DataBus;
	wire [31:0]	AddrBus;
	wire       	ControlBus;

   	reg bReset;
   	reg [7:0]	dRcvData;
   
   	MAINSYSTEM MAINSYSTEM_01(Serial_out, clk, Breq, Bgnt, DataBus, AddrBus, ControlBus, bReset);
	
	always begin
	      #10 clk = !clk;
	end
	
	initial
	begin
	   	bReset 	= 1'b1;
		clk 	= 1'b0;
		Breq 	= 1'b0;
		force DataBus = 8'hzz;
		force AddrBus = 32'h0000_0000;
		#100   	bReset = 1'b0;
		#100   	bReset = 1'b1;
		release DataBus;
	end

	initial
	begin
	   // WRITE TO MEMORY : MEM, bCE=0, bWE=0, Addr=0x30, DataBus=0x35; 
	   $display(">> 1. Writing 0x35 to SRAM.");
	   #500 force DataBus = 8'h35;   	force AddrBus = 32'h1000_0030;   
	   // RESET
      	   #200 release DataBus;         	force AddrBus = 32'h0000_0000;
           // READ FROM MEMORY TO BUS : MEM, bCE=0, bWE=1, Addr=0x30;
	   #300                          	force AddrBus = 32'h1004_0030;  
	   $display(">> 1a. Writing Complete");
	   
	   // READ DATA FROM THE BUS
	   $display(">> 2. Reading from SRAM.");
	   #100 dRcvData = DataBus;
	   // RESET
           #200 release DataBus;         	force AddrBus = 32'h0000_0000;
      
	   // SEND TO UART    
	   $display(">> 3. Sending through UART.");
	   #100   	bReset = 1'b0; 
	   #100 	bReset = 1'b1; 
	   #60 force DataBus = dRcvData;	force AddrBus = 32'h2000_0001;   // Load_XMT_datareg = 1;
	   #60   		        	force AddrBus = 32'h2000_0002;   // Byte_ready = 1;
	   #60                           	force AddrBus = 32'h2000_0004;   // T_byte = 1;
	   // RESET
           #200 release DataBus;         	force AddrBus = 32'h0000_0000;

	   #100	$stop;
	end

	initial
	begin
		$dumpfile ("wave.dump");
		$dumpvars (0, stimulus);
	end
	
	initial
		$monitor($time, "dRcvData:0h%h", dRcvData);

	initial
	begin 
		#1600 $monitor($time, "CLK[%b->%b] SerialOut: %b", clk, !clk, Serial_out);
	end
	//initial
	//	$sdf_annotate("Mainsystem.sdf", MAINSYSTEM_01);
endmodule
