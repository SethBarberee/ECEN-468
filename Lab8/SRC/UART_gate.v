/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP3
// Date      : Tue Mar 17 11:45:37 2020
/////////////////////////////////////////////////////////////


module Control_Unit ( Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, 
        Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b );
  input Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b;
  output Load_XMT_DR, Load_XMT_shftreg, start, shift, clear;
  wire   N28, N29, N30, N33, N34, N35, N36, N37, N38, N39, N40, N41, n4, n5,
         n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22;
  wire   [2:0] state;
  wire   [2:0] next_state;

  DFFSR \state_reg[0]  ( .D(next_state[0]), .CLK(Clock), .R(1'b1), .S(rst_b), 
        .Q(state[0]) );
  LATCH \next_state_reg[2]  ( .CLK(N41), .D(N30), .Q(next_state[2]) );
  DFFSR \state_reg[2]  ( .D(next_state[2]), .CLK(Clock), .R(rst_b), .S(1'b1), 
        .Q(state[2]) );
  LATCH \next_state_reg[1]  ( .CLK(N41), .D(N29), .Q(next_state[1]) );
  DFFSR \state_reg[1]  ( .D(next_state[1]), .CLK(Clock), .R(rst_b), .S(1'b1), 
        .Q(state[1]) );
  LATCH Load_XMT_DR_reg ( .CLK(N37), .D(N38), .Q(Load_XMT_DR) );
  LATCH \next_state_reg[0]  ( .CLK(N41), .D(N28), .Q(next_state[0]) );
  LATCH Load_XMT_shftreg_reg ( .CLK(N39), .D(N40), .Q(Load_XMT_shftreg) );
  LATCH shift_reg ( .CLK(N34), .D(N35), .Q(shift) );
  LATCH start_reg ( .CLK(N34), .D(N33), .Q(start) );
  LATCH clear_reg ( .CLK(N34), .D(N36), .Q(clear) );
  NOR2X1 U6 ( .A(n4), .B(n5), .Y(N41) );
  OR2X1 U7 ( .A(n6), .B(n7), .Y(n5) );
  NOR2X1 U8 ( .A(n8), .B(n9), .Y(N40) );
  OR2X1 U9 ( .A(n10), .B(n4), .Y(n9) );
  OR2X1 U10 ( .A(n11), .B(N37), .Y(N39) );
  AND2X1 U11 ( .A(Load_XMT_datareg), .B(rst_b), .Y(N38) );
  NAND2X1 U12 ( .A(rst_b), .B(n10), .Y(N37) );
  NOR2X1 U13 ( .A(n12), .B(n13), .Y(N36) );
  NAND2X1 U14 ( .A(rst_b), .B(n14), .Y(n13) );
  NOR2X1 U15 ( .A(n14), .B(n15), .Y(N35) );
  OR2X1 U16 ( .A(n12), .B(n4), .Y(n15) );
  INVX1 U17 ( .A(rst_b), .Y(n4) );
  OAI21X1 U18 ( .A(n7), .B(n6), .C(rst_b), .Y(N34) );
  XOR2X1 U19 ( .A(state[2]), .B(n16), .Y(n6) );
  NOR2X1 U20 ( .A(n17), .B(n18), .Y(n7) );
  NOR2X1 U21 ( .A(n19), .B(n20), .Y(N33) );
  NAND2X1 U22 ( .A(n11), .B(rst_b), .Y(n20) );
  INVX1 U23 ( .A(n21), .Y(n11) );
  OAI22X1 U24 ( .A(n12), .B(n14), .C(n21), .D(n19), .Y(N30) );
  INVX1 U25 ( .A(T_byte), .Y(n19) );
  INVX1 U26 ( .A(BC_lt_BCmax), .Y(n14) );
  OAI22X1 U27 ( .A(n10), .B(n8), .C(T_byte), .D(n21), .Y(N29) );
  NAND3X1 U28 ( .A(n18), .B(n22), .C(state[1]), .Y(n21) );
  INVX1 U29 ( .A(state[0]), .Y(n18) );
  INVX1 U30 ( .A(Byte_ready), .Y(n8) );
  OAI22X1 U31 ( .A(Byte_ready), .B(n10), .C(BC_lt_BCmax), .D(n12), .Y(N28) );
  NAND2X1 U32 ( .A(n16), .B(state[2]), .Y(n12) );
  NOR2X1 U33 ( .A(state[1]), .B(state[0]), .Y(n16) );
  NAND3X1 U34 ( .A(n17), .B(n22), .C(state[0]), .Y(n10) );
  INVX1 U35 ( .A(state[2]), .Y(n22) );
  INVX1 U36 ( .A(state[1]), .Y(n17) );
endmodule


module Datapath_Unit ( Serial_out, BC_lt_BCmax, Data_Bus, Load_XMT_DR, 
        Load_XMT_shftreg, start, shift, clear, Clock, rst_b );
  input [7:0] Data_Bus;
  input Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, Clock, rst_b;
  output Serial_out, BC_lt_BCmax;
  wire   n65, n68, n71, n74, n77, n80, n83, n86, n87, n88, n89, n90, n91, n92,
         n93, n94, n95, n96, n97, n98, n99, n1, n2, n3, n4, n5, n6, n7, n8, n9,
         n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23,
         n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37;
  wire   [8:1] XMT_shftreg;
  wire   [3:0] bit_count;
  wire   [7:0] XMT_datareg;

  DFFSR \XMT_datareg_reg[7]  ( .D(n86), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[7]) );
  DFFSR \XMT_shftreg_reg[8]  ( .D(n91), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[8]) );
  DFFSR \XMT_datareg_reg[6]  ( .D(n83), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[6]) );
  DFFSR \XMT_shftreg_reg[7]  ( .D(n92), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[7]) );
  DFFSR \XMT_datareg_reg[5]  ( .D(n80), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[5]) );
  DFFSR \XMT_shftreg_reg[6]  ( .D(n93), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[6]) );
  DFFSR \XMT_datareg_reg[4]  ( .D(n77), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[4]) );
  DFFSR \XMT_shftreg_reg[5]  ( .D(n94), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[5]) );
  DFFSR \XMT_datareg_reg[3]  ( .D(n74), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[3]) );
  DFFSR \XMT_shftreg_reg[4]  ( .D(n95), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[4]) );
  DFFSR \XMT_datareg_reg[2]  ( .D(n71), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[2]) );
  DFFSR \XMT_shftreg_reg[3]  ( .D(n96), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[3]) );
  DFFSR \XMT_datareg_reg[1]  ( .D(n68), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[1]) );
  DFFSR \XMT_shftreg_reg[2]  ( .D(n97), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[2]) );
  DFFSR \XMT_datareg_reg[0]  ( .D(n65), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[0]) );
  DFFSR \XMT_shftreg_reg[1]  ( .D(n98), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[1]) );
  DFFSR \XMT_shftreg_reg[0]  ( .D(n99), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        Serial_out) );
  DFFSR \bit_count_reg[0]  ( .D(n90), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[0]) );
  DFFSR \bit_count_reg[1]  ( .D(n89), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[1]) );
  DFFSR \bit_count_reg[2]  ( .D(n88), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[2]) );
  DFFSR \bit_count_reg[3]  ( .D(n87), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[3]) );
  OAI22X1 U3 ( .A(n1), .B(n2), .C(start), .D(n3), .Y(n99) );
  AOI21X1 U4 ( .A(Serial_out), .B(n4), .C(n5), .Y(n3) );
  INVX1 U5 ( .A(XMT_shftreg[1]), .Y(n1) );
  OAI21X1 U6 ( .A(n2), .B(n6), .C(n7), .Y(n98) );
  AOI22X1 U7 ( .A(XMT_datareg[0]), .B(n5), .C(XMT_shftreg[1]), .D(n4), .Y(n7)
         );
  INVX1 U8 ( .A(XMT_shftreg[2]), .Y(n6) );
  OAI21X1 U9 ( .A(n2), .B(n8), .C(n9), .Y(n97) );
  AOI22X1 U10 ( .A(XMT_datareg[1]), .B(n5), .C(XMT_shftreg[2]), .D(n4), .Y(n9)
         );
  INVX1 U11 ( .A(XMT_shftreg[3]), .Y(n8) );
  OAI21X1 U12 ( .A(n2), .B(n10), .C(n11), .Y(n96) );
  AOI22X1 U13 ( .A(XMT_datareg[2]), .B(n5), .C(XMT_shftreg[3]), .D(n4), .Y(n11) );
  INVX1 U14 ( .A(XMT_shftreg[4]), .Y(n10) );
  OAI21X1 U15 ( .A(n2), .B(n12), .C(n13), .Y(n95) );
  AOI22X1 U16 ( .A(XMT_datareg[3]), .B(n5), .C(XMT_shftreg[4]), .D(n4), .Y(n13) );
  INVX1 U17 ( .A(XMT_shftreg[5]), .Y(n12) );
  OAI21X1 U18 ( .A(n2), .B(n14), .C(n15), .Y(n94) );
  AOI22X1 U19 ( .A(XMT_datareg[4]), .B(n5), .C(XMT_shftreg[5]), .D(n4), .Y(n15) );
  INVX1 U20 ( .A(XMT_shftreg[6]), .Y(n14) );
  OAI21X1 U21 ( .A(n2), .B(n16), .C(n17), .Y(n93) );
  AOI22X1 U22 ( .A(XMT_datareg[5]), .B(n5), .C(XMT_shftreg[6]), .D(n4), .Y(n17) );
  INVX1 U23 ( .A(XMT_shftreg[7]), .Y(n16) );
  OAI21X1 U24 ( .A(n2), .B(n18), .C(n19), .Y(n92) );
  AOI22X1 U25 ( .A(XMT_datareg[6]), .B(n5), .C(XMT_shftreg[7]), .D(n4), .Y(n19) );
  NOR2X1 U26 ( .A(shift), .B(n4), .Y(n5) );
  INVX1 U27 ( .A(XMT_shftreg[8]), .Y(n18) );
  NAND2X1 U28 ( .A(n20), .B(n2), .Y(n91) );
  MUX2X1 U29 ( .B(XMT_datareg[7]), .A(XMT_shftreg[8]), .S(n4), .Y(n20) );
  NOR2X1 U30 ( .A(shift), .B(Load_XMT_shftreg), .Y(n4) );
  NOR2X1 U31 ( .A(clear), .B(n21), .Y(n90) );
  XOR2X1 U32 ( .A(bit_count[0]), .B(n2), .Y(n21) );
  INVX1 U33 ( .A(shift), .Y(n2) );
  NOR2X1 U34 ( .A(clear), .B(n22), .Y(n89) );
  XOR2X1 U35 ( .A(n23), .B(bit_count[1]), .Y(n22) );
  NOR2X1 U36 ( .A(clear), .B(n24), .Y(n88) );
  XNOR2X1 U37 ( .A(bit_count[2]), .B(n25), .Y(n24) );
  NOR2X1 U38 ( .A(clear), .B(n26), .Y(n87) );
  XOR2X1 U39 ( .A(n27), .B(bit_count[3]), .Y(n26) );
  NAND2X1 U40 ( .A(n25), .B(bit_count[2]), .Y(n27) );
  NOR2X1 U41 ( .A(n23), .B(n28), .Y(n25) );
  INVX1 U42 ( .A(bit_count[1]), .Y(n28) );
  NAND2X1 U43 ( .A(bit_count[0]), .B(shift), .Y(n23) );
  INVX1 U44 ( .A(n29), .Y(n86) );
  MUX2X1 U45 ( .B(XMT_datareg[7]), .A(Data_Bus[7]), .S(Load_XMT_DR), .Y(n29)
         );
  INVX1 U46 ( .A(n30), .Y(n83) );
  MUX2X1 U47 ( .B(XMT_datareg[6]), .A(Data_Bus[6]), .S(Load_XMT_DR), .Y(n30)
         );
  INVX1 U48 ( .A(n31), .Y(n80) );
  MUX2X1 U49 ( .B(XMT_datareg[5]), .A(Data_Bus[5]), .S(Load_XMT_DR), .Y(n31)
         );
  INVX1 U50 ( .A(n32), .Y(n77) );
  MUX2X1 U51 ( .B(XMT_datareg[4]), .A(Data_Bus[4]), .S(Load_XMT_DR), .Y(n32)
         );
  INVX1 U52 ( .A(n33), .Y(n74) );
  MUX2X1 U53 ( .B(XMT_datareg[3]), .A(Data_Bus[3]), .S(Load_XMT_DR), .Y(n33)
         );
  INVX1 U54 ( .A(n34), .Y(n71) );
  MUX2X1 U55 ( .B(XMT_datareg[2]), .A(Data_Bus[2]), .S(Load_XMT_DR), .Y(n34)
         );
  INVX1 U56 ( .A(n35), .Y(n68) );
  MUX2X1 U57 ( .B(XMT_datareg[1]), .A(Data_Bus[1]), .S(Load_XMT_DR), .Y(n35)
         );
  INVX1 U58 ( .A(n36), .Y(n65) );
  MUX2X1 U59 ( .B(XMT_datareg[0]), .A(Data_Bus[0]), .S(Load_XMT_DR), .Y(n36)
         );
  OAI21X1 U60 ( .A(bit_count[0]), .B(n37), .C(bit_count[3]), .Y(BC_lt_BCmax)
         );
  OR2X1 U61 ( .A(bit_count[1]), .B(bit_count[2]), .Y(n37) );
endmodule


module UART_XMTR ( Serial_out, Data_Bus, Load_XMT_datareg, Byte_ready, T_byte, 
        Clock, rst_b );
  input [7:0] Data_Bus;
  input Load_XMT_datareg, Byte_ready, T_byte, Clock, rst_b;
  output Serial_out;
  wire   Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, BC_lt_BCmax;

  Control_Unit control ( .Load_XMT_DR(Load_XMT_DR), .Load_XMT_shftreg(
        Load_XMT_shftreg), .start(start), .shift(shift), .clear(clear), 
        .Load_XMT_datareg(Load_XMT_datareg), .Byte_ready(Byte_ready), .T_byte(
        T_byte), .BC_lt_BCmax(BC_lt_BCmax), .Clock(Clock), .rst_b(rst_b) );
  Datapath_Unit datapath ( .Serial_out(Serial_out), .BC_lt_BCmax(BC_lt_BCmax), 
        .Data_Bus(Data_Bus), .Load_XMT_DR(Load_XMT_DR), .Load_XMT_shftreg(
        Load_XMT_shftreg), .start(start), .shift(shift), .clear(clear), 
        .Clock(Clock), .rst_b(rst_b) );
endmodule

