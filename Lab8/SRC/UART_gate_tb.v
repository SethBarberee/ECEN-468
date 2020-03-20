`timescale 1ns / 10ps
`include "UART_gate.v"
`include "osu018_stdcells.v"

// TESTBENCH
module stimulus;

	parameter word_size = 8;
	integer i;
	
	// Declare input/output signals
	wire 			Serial_out;

	reg [word_size-1:0]	Data_Bus;
	reg			Load_XMT_datareg, Byte_ready, T_byte, Clock, rst_b;

	// Connect DUT (Design Under Test)
	UART_XMTR UART_XMTR_01(Serial_out, Data_Bus, Load_XMT_datareg, Byte_ready, T_byte, Clock, rst_b);

	// Initial Settings
	initial
	begin
		Clock = 1'b0;
		rst_b = 1'b1;
		Load_XMT_datareg = 1'b0;
		Byte_ready = 1'b0;
		T_byte = 1'b0;
	end

	// Clock generation
	always begin
		#2 Clock = !Clock;
	end
	
	// Main test bench
	initial
	begin
		#4	rst_b = 1'b0;
		#12	rst_b = 1'b1;

		for(i=8'h41; i<=8'h43; i=i+1) begin
			#4 	Data_Bus = i;
			#4	Load_XMT_datareg = 1;
			#4	Load_XMT_datareg = 0;

			#4	Byte_ready = 1;
			#4	Byte_ready = 0;

			#12	T_byte = 1;
			#4	T_byte = 0;
			#60;
		end

		$finish;//$stop;
	end

	// Dump signals to view waveform
	initial
	begin
		$dumpfile ("wave_gate.dump");
		$dumpvars (0, stimulus);
	end
	
	// Output text messages
	initial
		$monitor($time, "Out:%b <= Data_Bus:%b / Load_XMT_datareg:%b / Byte_ready:%b / T_byte:%b, Clock:%b, rst_b:%b", Serial_out, Data_Bus, Load_XMT_datareg, Byte_ready, T_byte, Clock, rst_b);
    initial
        $sdf_annotate("UART.sdf", UART_XMTR_01);

endmodule
