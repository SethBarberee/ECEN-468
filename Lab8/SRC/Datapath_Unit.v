// Module Definition
module Datapath_Unit (
	Serial_out,
	BC_lt_BCmax,
	Data_Bus,
	Load_XMT_DR,
	Load_XMT_shftreg,
	start,
	shift,
	clear,
	Clock,
	rst_b);

	// Declare internal parameters
	parameter		word_size = 8;
	parameter		size_bit_count = 3;
	parameter		all_ones = {(word_size + 1){1'b1}};	// 9 bits of ones

	// Declare input/output
	output		Serial_out;
	output		BC_lt_BCmax;

	input [word_size-1:0]	Data_Bus;
	input			Load_XMT_DR;
	input			Load_XMT_shftreg;
	input			start;
	input			shift;
	input			clear;
	input 		Clock;
	input			rst_b;

	// Declare internal reg variable
	reg [word_size-1:0]	XMT_datareg;	// Transmit Data Register
	reg [word_size:0]		XMT_shftreg;	// Transmit Shift Register:{data, start bit}
	reg [size_bit_count:0]	bit_count;		// Counts the bits that are transmitted
	
	assign Serial_out = XMT_shftreg[0];

	// Connect your UDP (User Defined Primitive)
	// Insert your code here.

	// Data Path for UART Transmitter
	always @(posedge Clock or negedge rst_b)
	begin
            if(Load_XMT_DR)
                XMT_datareg <= Data_Bus;
            if(Load_XMT_shftreg)
                XMT_shftreg <= XMT_datareg;
            if(start)
                XMT_shftreg[0] <= 0;
            if(shift)
                // TODO shift here
                begin
                    XMT_shftreg[8:1] <= XMT_shftreg[7:0]
                    XMT_shftreg[0] <= 1;
                    bit_count <= bit_count + 1;
                end
            if(clear)
                bit_count <= 0;
	end
endmodule

// UDP (User Defined Primitive)
// -----------------------------------
// Insert your UDP here.
// -----------------------------------
