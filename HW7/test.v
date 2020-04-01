`timescale 1ns/100ps
module m(y, x);
    output y;  
    input x;
    not #1.534 (y,x);
endmodule

`timescale 10ns/100ps
module modA();
    wire b; reg a;
    m m1( b, a );
    initial
        $monitor( $time, "  realtime=%f a=%b b=%b", $realtime, a, b );
    initial begin
        #10 a = 0;
        #10 a = 1;
        #10 $finish;
    end
endmodule
