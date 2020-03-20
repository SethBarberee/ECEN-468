/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP3
// Date      : Fri Mar 20 11:51:24 2020
/////////////////////////////////////////////////////////////


module Control_Unit ( Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, 
        Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b );
  input Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b;
  output Load_XMT_DR, Load_XMT_shftreg, start, shift, clear;
  wire   N37, N39, N40, N42, N43, N44, N45, n4, n6, n48, n49, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68;
  wire   [2:0] state;
  wire   [2:0] next_state;

  DFFSR \state_reg[0]  ( .D(next_state[0]), .CLK(Clock), .R(1'b1), .S(rst_b), 
        .Q(state[0]) );
  LATCH \next_state_reg[2]  ( .CLK(N42), .D(N45), .Q(next_state[2]) );
  DFFSR \state_reg[2]  ( .D(next_state[2]), .CLK(Clock), .R(rst_b), .S(1'b1), 
        .Q(state[2]) );
  LATCH \next_state_reg[1]  ( .CLK(N42), .D(N44), .Q(next_state[1]) );
  DFFSR \state_reg[1]  ( .D(next_state[1]), .CLK(Clock), .R(rst_b), .S(1'b1), 
        .Q(state[1]) );
  LATCH \next_state_reg[0]  ( .CLK(N42), .D(N43), .Q(next_state[0]) );
  LATCH start_reg ( .CLK(N42), .D(N37), .Q(start) );
  LATCH shift_reg ( .CLK(N42), .D(n6), .Q(shift) );
  LATCH clear_reg ( .CLK(N42), .D(N39), .Q(clear) );
  LATCH Load_XMT_shftreg_reg ( .CLK(N42), .D(n4), .Q(Load_XMT_shftreg) );
  LATCH Load_XMT_DR_reg ( .CLK(N42), .D(N40), .Q(Load_XMT_DR) );
  INVX1 U6 ( .A(n48), .Y(n4) );
  OR2X1 U7 ( .A(n6), .B(N37), .Y(N45) );
  INVX1 U8 ( .A(n49), .Y(n6) );
  NAND3X1 U9 ( .A(BC_lt_BCmax), .B(n50), .C(rst_b), .Y(n49) );
  OAI21X1 U10 ( .A(T_byte), .B(n51), .C(n48), .Y(N44) );
  NAND3X1 U11 ( .A(n52), .B(rst_b), .C(n53), .Y(n48) );
  INVX1 U12 ( .A(n54), .Y(n52) );
  NAND2X1 U13 ( .A(n55), .B(rst_b), .Y(N43) );
  AOI22X1 U14 ( .A(n53), .B(n54), .C(n50), .D(n56), .Y(n55) );
  NAND2X1 U15 ( .A(Byte_ready), .B(n57), .Y(n54) );
  OAI21X1 U16 ( .A(n58), .B(n59), .C(rst_b), .Y(N42) );
  XOR2X1 U17 ( .A(state[2]), .B(n60), .Y(n59) );
  NOR2X1 U18 ( .A(state[0]), .B(state[1]), .Y(n60) );
  NOR2X1 U19 ( .A(n61), .B(n62), .Y(n58) );
  NOR2X1 U20 ( .A(n57), .B(n63), .Y(N40) );
  NAND2X1 U21 ( .A(n53), .B(rst_b), .Y(n63) );
  NOR3X1 U22 ( .A(state[1]), .B(state[2]), .C(n61), .Y(n53) );
  INVX1 U23 ( .A(Load_XMT_datareg), .Y(n57) );
  NOR2X1 U24 ( .A(n64), .B(n65), .Y(N39) );
  NAND2X1 U25 ( .A(n50), .B(n56), .Y(n65) );
  INVX1 U26 ( .A(BC_lt_BCmax), .Y(n56) );
  INVX1 U27 ( .A(n66), .Y(n50) );
  NAND3X1 U28 ( .A(n61), .B(n62), .C(state[2]), .Y(n66) );
  INVX1 U29 ( .A(state[1]), .Y(n62) );
  INVX1 U30 ( .A(state[0]), .Y(n61) );
  INVX1 U31 ( .A(rst_b), .Y(n64) );
  NOR2X1 U32 ( .A(n67), .B(n51), .Y(N37) );
  NAND3X1 U33 ( .A(state[1]), .B(rst_b), .C(n68), .Y(n51) );
  NOR2X1 U34 ( .A(state[2]), .B(state[0]), .Y(n68) );
  INVX1 U35 ( .A(T_byte), .Y(n67) );
endmodule


module Datapath_Unit ( Serial_out, BC_lt_BCmax, Data_Bus, Load_XMT_DR, 
        Load_XMT_shftreg, start, shift, clear, Clock, rst_b );
  input [7:0] Data_Bus;
  input Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, Clock, rst_b;
  output Serial_out, BC_lt_BCmax;
  wire   n86, n87, n88, n89, n90, n91, n92, n93, n94, n103, n104, n105, n106,
         n82, n83, n84, n85, n95, n96, n97, n98, n142, n143, n144, n145, n146,
         n147, n148, n149, n150, n151, n152, n153, n154, n155, n156, n157,
         n158, n159, n160, n161, n162, n163, n164, n165, n166, n167, n168,
         n169, n170, n171, n172, n173, n174, n175, n176, n177, n178, n179,
         n180, n181, n182, n183, n184, n185, n186, n187, n188, n189, n190;
  wire   [8:1] XMT_shftreg;
  wire   [3:0] bit_count;
  wire   [7:0] XMT_datareg;

  DFFSR \bit_count_reg[0]  ( .D(n106), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[0]) );
  DFFSR \bit_count_reg[1]  ( .D(n105), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[1]) );
  DFFSR \bit_count_reg[2]  ( .D(n104), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[2]) );
  DFFSR \bit_count_reg[3]  ( .D(n103), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        bit_count[3]) );
  DFFSR \XMT_datareg_reg[7]  ( .D(n82), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[7]) );
  DFFSR \XMT_shftreg_reg[8]  ( .D(n86), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[8]) );
  DFFSR \XMT_datareg_reg[6]  ( .D(n83), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[6]) );
  DFFSR \XMT_shftreg_reg[7]  ( .D(n87), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[7]) );
  DFFSR \XMT_datareg_reg[5]  ( .D(n84), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[5]) );
  DFFSR \XMT_shftreg_reg[6]  ( .D(n88), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[6]) );
  DFFSR \XMT_datareg_reg[4]  ( .D(n85), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[4]) );
  DFFSR \XMT_shftreg_reg[5]  ( .D(n89), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[5]) );
  DFFSR \XMT_datareg_reg[3]  ( .D(n95), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[3]) );
  DFFSR \XMT_shftreg_reg[4]  ( .D(n90), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[4]) );
  DFFSR \XMT_datareg_reg[2]  ( .D(n96), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[2]) );
  DFFSR \XMT_shftreg_reg[3]  ( .D(n91), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[3]) );
  DFFSR \XMT_datareg_reg[1]  ( .D(n97), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[1]) );
  DFFSR \XMT_shftreg_reg[2]  ( .D(n92), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[2]) );
  DFFSR \XMT_datareg_reg[0]  ( .D(n98), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[0]) );
  DFFSR \XMT_shftreg_reg[1]  ( .D(n94), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[1]) );
  DFFSR \XMT_shftreg_reg[0]  ( .D(n93), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        Serial_out) );
  INVX1 U24 ( .A(n142), .Y(n98) );
  MUX2X1 U25 ( .B(Data_Bus[0]), .A(XMT_datareg[0]), .S(n143), .Y(n142) );
  INVX1 U26 ( .A(n144), .Y(n97) );
  MUX2X1 U27 ( .B(Data_Bus[1]), .A(XMT_datareg[1]), .S(n143), .Y(n144) );
  INVX1 U28 ( .A(n145), .Y(n96) );
  MUX2X1 U29 ( .B(Data_Bus[2]), .A(XMT_datareg[2]), .S(n143), .Y(n145) );
  INVX1 U30 ( .A(n146), .Y(n95) );
  MUX2X1 U31 ( .B(Data_Bus[3]), .A(XMT_datareg[3]), .S(n143), .Y(n146) );
  OAI21X1 U32 ( .A(n147), .B(n148), .C(n149), .Y(n94) );
  AOI22X1 U33 ( .A(n150), .B(XMT_datareg[0]), .C(XMT_shftreg[2]), .D(n151), 
        .Y(n149) );
  OR2X1 U34 ( .A(n150), .B(n152), .Y(n93) );
  MUX2X1 U35 ( .B(n153), .A(n148), .S(n147), .Y(n152) );
  INVX1 U36 ( .A(XMT_shftreg[1]), .Y(n148) );
  OAI21X1 U37 ( .A(Load_XMT_DR), .B(n154), .C(Serial_out), .Y(n153) );
  OAI21X1 U38 ( .A(n147), .B(n155), .C(n156), .Y(n92) );
  AOI22X1 U39 ( .A(n150), .B(XMT_datareg[1]), .C(XMT_shftreg[3]), .D(n151), 
        .Y(n156) );
  INVX1 U40 ( .A(XMT_shftreg[2]), .Y(n155) );
  OAI21X1 U41 ( .A(n147), .B(n157), .C(n158), .Y(n91) );
  AOI22X1 U42 ( .A(n150), .B(XMT_datareg[2]), .C(XMT_shftreg[4]), .D(n151), 
        .Y(n158) );
  INVX1 U43 ( .A(XMT_shftreg[3]), .Y(n157) );
  OAI21X1 U44 ( .A(n147), .B(n159), .C(n160), .Y(n90) );
  AOI22X1 U45 ( .A(n150), .B(XMT_datareg[3]), .C(XMT_shftreg[5]), .D(n151), 
        .Y(n160) );
  INVX1 U46 ( .A(XMT_shftreg[4]), .Y(n159) );
  OAI21X1 U47 ( .A(n147), .B(n161), .C(n162), .Y(n89) );
  AOI22X1 U48 ( .A(XMT_datareg[4]), .B(n150), .C(XMT_shftreg[6]), .D(n151), 
        .Y(n162) );
  INVX1 U49 ( .A(XMT_shftreg[5]), .Y(n161) );
  OAI21X1 U50 ( .A(n147), .B(n163), .C(n164), .Y(n88) );
  AOI22X1 U51 ( .A(XMT_datareg[5]), .B(n150), .C(XMT_shftreg[7]), .D(n151), 
        .Y(n164) );
  INVX1 U52 ( .A(XMT_shftreg[6]), .Y(n163) );
  OAI21X1 U53 ( .A(n147), .B(n165), .C(n166), .Y(n87) );
  AOI22X1 U54 ( .A(XMT_datareg[6]), .B(n150), .C(XMT_shftreg[8]), .D(n151), 
        .Y(n166) );
  INVX1 U55 ( .A(n167), .Y(n151) );
  AND2X1 U56 ( .A(Load_XMT_shftreg), .B(n147), .Y(n150) );
  INVX1 U57 ( .A(XMT_shftreg[7]), .Y(n165) );
  NAND2X1 U58 ( .A(n168), .B(n167), .Y(n86) );
  NAND2X1 U59 ( .A(n147), .B(n169), .Y(n167) );
  MUX2X1 U60 ( .B(XMT_shftreg[8]), .A(XMT_datareg[7]), .S(n147), .Y(n168) );
  AND2X1 U61 ( .A(n143), .B(n170), .Y(n147) );
  OAI21X1 U62 ( .A(start), .B(n171), .C(n169), .Y(n170) );
  INVX1 U63 ( .A(n172), .Y(n85) );
  MUX2X1 U64 ( .B(Data_Bus[4]), .A(XMT_datareg[4]), .S(n143), .Y(n172) );
  INVX1 U65 ( .A(n173), .Y(n84) );
  MUX2X1 U66 ( .B(Data_Bus[5]), .A(XMT_datareg[5]), .S(n143), .Y(n173) );
  INVX1 U67 ( .A(n174), .Y(n83) );
  MUX2X1 U68 ( .B(Data_Bus[6]), .A(XMT_datareg[6]), .S(n143), .Y(n174) );
  INVX1 U69 ( .A(n175), .Y(n82) );
  MUX2X1 U70 ( .B(Data_Bus[7]), .A(XMT_datareg[7]), .S(n143), .Y(n175) );
  MUX2X1 U71 ( .B(n176), .A(n177), .S(bit_count[0]), .Y(n106) );
  NAND2X1 U72 ( .A(n177), .B(shift), .Y(n176) );
  MUX2X1 U73 ( .B(n178), .A(n179), .S(bit_count[1]), .Y(n105) );
  MUX2X1 U74 ( .B(n180), .A(n181), .S(bit_count[2]), .Y(n104) );
  NAND2X1 U75 ( .A(n182), .B(bit_count[1]), .Y(n180) );
  MUX2X1 U76 ( .B(n183), .A(n184), .S(bit_count[3]), .Y(n103) );
  INVX1 U77 ( .A(n185), .Y(n184) );
  OAI21X1 U78 ( .A(n171), .B(bit_count[2]), .C(n181), .Y(n185) );
  INVX1 U79 ( .A(n186), .Y(n181) );
  OAI21X1 U80 ( .A(bit_count[1]), .B(n171), .C(n179), .Y(n186) );
  INVX1 U81 ( .A(n187), .Y(n179) );
  OAI21X1 U82 ( .A(bit_count[0]), .B(n171), .C(n177), .Y(n187) );
  INVX1 U83 ( .A(shift), .Y(n171) );
  NAND3X1 U84 ( .A(n182), .B(bit_count[1]), .C(bit_count[2]), .Y(n183) );
  INVX1 U85 ( .A(n178), .Y(n182) );
  NAND3X1 U86 ( .A(bit_count[0]), .B(shift), .C(n177), .Y(n178) );
  NOR2X1 U87 ( .A(n188), .B(n189), .Y(n177) );
  OAI21X1 U88 ( .A(clear), .B(shift), .C(n143), .Y(n189) );
  INVX1 U89 ( .A(Load_XMT_DR), .Y(n143) );
  NAND2X1 U90 ( .A(n169), .B(n154), .Y(n188) );
  INVX1 U91 ( .A(start), .Y(n154) );
  INVX1 U92 ( .A(Load_XMT_shftreg), .Y(n169) );
  OAI21X1 U93 ( .A(bit_count[0]), .B(n190), .C(bit_count[3]), .Y(BC_lt_BCmax)
         );
  OR2X1 U94 ( .A(bit_count[1]), .B(bit_count[2]), .Y(n190) );
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

