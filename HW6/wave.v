// TESTBENCH

module wave;

	// Port Declaration
	reg a,b,c;

	// Initialization
	initial
	begin
            #2 a = 1;
            c <= #4 a;
            b <= #2 c;
            a <= 0;
            fork
                #2 a = 1; #3 b = 0;
            join
	end

	// Dump signals to make waveform
	initial
	begin
		$dumpfile ("wave.dump");
		$dumpvars (0, wave);
	end

endmodule
