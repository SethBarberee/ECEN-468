// TESTBENCH

module do_something;

	// Port Declaration
	reg clock;

	initial
	begin
            clock = 0;
            #300;
            $finish
	end


	// Dump signals to make waveform
	initial
	begin
		$dumpfile ("wave.dump");
		$dumpvars (0, do_something);
	end

        always@(clock) #40 clock = ~clock;
	
endmodule
