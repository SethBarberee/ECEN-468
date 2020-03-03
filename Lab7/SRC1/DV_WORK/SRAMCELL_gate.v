
module SRAMCELL ( InData, OutData, bCS, bWE );
  input InData, bCS, bWE;
  output OutData;
  wire   N1, d, N2, n2;

  LATCH d_reg ( .CLK(N1), .D(InData), .Q(d) );
  LATCH OutData_reg ( .CLK(N2), .D(d), .Q(OutData) );
  NOR2X1 U5 ( .A(bCS), .B(n2), .Y(N2) );
  INVX1 U6 ( .A(bWE), .Y(n2) );
  NOR2X1 U7 ( .A(bWE), .B(bCS), .Y(N1) );
endmodule

