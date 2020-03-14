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
        assign BC_lt_BCmax = (bit_count < word_size + 1);
        //BC_lt_BCmax_primitive(BC_lt_BCmax, bit_count[size_bit_count], bit_count[size_bit_count - 1], bit_count[size_bit_count - 2], bit_count[size_bit_count - 3]);

	// Data Path for UART Transmitter
	always @(posedge Clock or negedge rst_b)
	begin
            if(rst_b)
                begin
                if(Load_XMT_DR)
                    XMT_datareg <= Data_Bus;
                if(Load_XMT_shftreg)
                    XMT_shftreg <= {XMT_datareg, 1'b1};
                if(start)
                    XMT_shftreg[0] <= 0;
                if(shift)
                    // shift here
                    begin
                        XMT_shftreg <= {1'b1, XMT_shftreg[word_size:1]};
                        bit_count <= bit_count + 1;
                    end
                if(clear)
                    bit_count <= 4'b0;
                end
            else
            begin
                bit_count <= 4'b0;
                XMT_shftreg <= 0;
                XMT_datareg <= 0;
            end
	end
endmodule

// UDP (User Defined Primitive)
// -----------------------------------
// Insert your UDP here.
// -----------------------------------
primitive BC_lt_BCmax_primitive (
    BC_lt_BCmax,
    bit_count_3,
    bit_count_2,
    bit_count_1,
    bit_count_0
);
output BC_lt_BCmax;
input bit_count_3;
input bit_count_2;
input bit_count_1;
input bit_count_0;
table
    // bit_count | BC_lt_BCmax
    0   0   0   0 : 1;
    0   0   0   1 : 1;
    0   0   1   0 : 1;
    0   0   1   1 : 1;
    0   1   0   0 : 1;
    0   1   0   1 : 1;
    0   1   1   0 : 1;
    0   1   1   1 : 1;
    1   0   0   0 : 1;
    1   0   0   1 : 0;
endtable
endprimitive
