module test (a,b,y);
    input a,b;
    output y;

    nand #4 (y, a, b); // gate delay of 4
    //nand #(3,5) (y, a, b); // rise of 3 and fall of 5

endmodule

module run;

    reg a,b,c;

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
        $dumpvars (0, wave);
    end
endmodule
