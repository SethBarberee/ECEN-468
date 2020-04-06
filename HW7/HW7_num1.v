module something_wrong(y_out, x1, x2);
    output y_out;
    input x1, x2;

    parameter delay1=3;
    parameter delay2=4;
    parameter delay3=5;

    //nand #(delay1, delay2, delay3)(y_out, x1, x2);
    nand #(delay1, delay2, delay3) (y_out, x1, x2);
endmodule
