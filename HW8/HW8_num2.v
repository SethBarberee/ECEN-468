module test (a,b,y);
    input a,b;
    output y;

    //nand #4 (y, a, b); // gate delay of 4
    nand(y, a, b);

    specify
        (a,b => y) = (3,5); // rise/fall of 3/5
        specparam
        pathpulse$ = 2; // inertial delay of 2
    endspecify

endmodule

module run;

    reg a,b;
    wire c;

    test test1(a,b,c);

    initial begin
        a = 0; b = 1;
        #2; a = 1;
        #4; a = 0;
        #5; a = 1;
        #1; b = 0;
    end

    // Dump signals to make waveform
    initial
    begin
        $dumpfile ("wave.dump");
        $dumpvars (0, run);
    end
endmodule
