/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP3
// Date      : Tue Mar 17 23:07:54 2020
/////////////////////////////////////////////////////////////


module Control_Unit ( Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, 
        Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b );
  input Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b;
  output Load_XMT_DR, Load_XMT_shftreg, start, shift, clear;
  wire   N29, N30, N31, N38, N39, N40, N41, N43, N44, N45, N46, n5, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48;
  wire   [2:0] state;
  wire   [2:0] next_state;

  DFFSR \state_reg[0]  ( .D(next_state[0]), .CLK(Clock), .R(1'b1), .S(rst_b), 
        .Q(state[0]) );
  LATCH \next_state_reg[2]  ( .CLK(N46), .D(N31), .Q(next_state[2]) );
  DFFSR \state_reg[2]  ( .D(next_state[2]), .CLK(Clock), .R(rst_b), .S(1'b1), 
        .Q(state[2]) );
  LATCH \next_state_reg[1]  ( .CLK(N46), .D(N30), .Q(next_state[1]) );
  DFFSR \state_reg[1]  ( .D(next_state[1]), .CLK(Clock), .R(rst_b), .S(1'b1), 
        .Q(state[1]) );
  LATCH \next_state_reg[0]  ( .CLK(N46), .D(N29), .Q(next_state[0]) );
  LATCH Load_XMT_shftreg_reg ( .CLK(N44), .D(N45), .Q(Load_XMT_shftreg) );
  LATCH Load_XMT_DR_reg ( .CLK(n5), .D(N43), .Q(Load_XMT_DR) );
  LATCH shift_reg ( .CLK(N39), .D(N40), .Q(shift) );
  LATCH start_reg ( .CLK(N39), .D(N38), .Q(start) );
  LATCH clear_reg ( .CLK(N39), .D(N41), .Q(clear) );
  INVX1 U6 ( .A(n27), .Y(n5) );
  NOR2X1 U7 ( .A(n28), .B(n29), .Y(N46) );
  OR2X1 U8 ( .A(n30), .B(n31), .Y(n29) );
  NOR2X1 U9 ( .A(n30), .B(n32), .Y(N45) );
  NAND2X1 U10 ( .A(n33), .B(n27), .Y(N44) );
  NOR2X1 U11 ( .A(n30), .B(n34), .Y(n27) );
  NOR2X1 U12 ( .A(n30), .B(n35), .Y(N43) );
  NOR2X1 U13 ( .A(n36), .B(n37), .Y(N41) );
  NAND2X1 U14 ( .A(rst_b), .B(n38), .Y(n37) );
  NOR2X1 U15 ( .A(n38), .B(n39), .Y(N40) );
  OR2X1 U16 ( .A(n36), .B(n30), .Y(n39) );
  OAI21X1 U17 ( .A(n31), .B(n28), .C(rst_b), .Y(N39) );
  XNOR2X1 U18 ( .A(n40), .B(n41), .Y(n28) );
  NOR2X1 U19 ( .A(n42), .B(n43), .Y(n31) );
  NOR2X1 U20 ( .A(n44), .B(n45), .Y(N38) );
  OR2X1 U21 ( .A(n33), .B(n30), .Y(n45) );
  INVX1 U22 ( .A(rst_b), .Y(n30) );
  OAI22X1 U23 ( .A(n36), .B(n38), .C(n33), .D(n44), .Y(N31) );
  INVX1 U24 ( .A(T_byte), .Y(n44) );
  INVX1 U25 ( .A(BC_lt_BCmax), .Y(n38) );
  OAI21X1 U26 ( .A(T_byte), .B(n33), .C(n32), .Y(N30) );
  NAND3X1 U27 ( .A(n34), .B(n35), .C(Byte_ready), .Y(n32) );
  INVX1 U28 ( .A(Load_XMT_datareg), .Y(n35) );
  NAND3X1 U29 ( .A(n43), .B(n40), .C(state[1]), .Y(n33) );
  INVX1 U30 ( .A(state[0]), .Y(n43) );
  OAI21X1 U31 ( .A(BC_lt_BCmax), .B(n36), .C(n46), .Y(N29) );
  OAI21X1 U32 ( .A(Load_XMT_datareg), .B(n47), .C(n34), .Y(n46) );
  INVX1 U33 ( .A(n48), .Y(n34) );
  NAND3X1 U34 ( .A(n42), .B(n40), .C(state[0]), .Y(n48) );
  INVX1 U35 ( .A(state[2]), .Y(n40) );
  INVX1 U36 ( .A(state[1]), .Y(n42) );
  INVX1 U37 ( .A(Byte_ready), .Y(n47) );
  NAND2X1 U38 ( .A(n41), .B(state[2]), .Y(n36) );
  NOR2X1 U39 ( .A(state[1]), .B(state[0]), .Y(n41) );
endmodule


module Datapath_Unit ( Serial_out, BC_lt_BCmax, Data_Bus, Load_XMT_DR, 
        Load_XMT_shftreg, start, shift, clear, Clock, rst_b );
  input [7:0] Data_Bus;
  input Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, Clock, rst_b;
  output Serial_out, BC_lt_BCmax;
  wire   n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n47,
         n48, n49, n50, n51, n52, n53, n54, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n55, n56, n57, n65, n68, n71, n74, n77, n80, n83, n86, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117;
  wire   [8:1] XMT_shftreg;
  wire   [3:0] bit_count;
  wire   [7:0] XMT_datareg;

  DFFSR \XMT_datareg_reg[7]  ( .D(n47), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[7]) );
  DFFSR \XMT_shftreg_reg[8]  ( .D(n91), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[8]) );
  DFFSR \XMT_datareg_reg[6]  ( .D(n48), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[6]) );
  DFFSR \XMT_shftreg_reg[7]  ( .D(n92), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[7]) );
  DFFSR \XMT_datareg_reg[5]  ( .D(n49), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[5]) );
  DFFSR \XMT_shftreg_reg[6]  ( .D(n93), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[6]) );
  DFFSR \XMT_datareg_reg[4]  ( .D(n50), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[4]) );
  DFFSR \XMT_shftreg_reg[5]  ( .D(n94), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[5]) );
  DFFSR \XMT_datareg_reg[3]  ( .D(n51), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[3]) );
  DFFSR \XMT_shftreg_reg[4]  ( .D(n95), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[4]) );
  DFFSR \XMT_datareg_reg[2]  ( .D(n52), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[2]) );
  DFFSR \XMT_shftreg_reg[3]  ( .D(n96), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[3]) );
  DFFSR \XMT_datareg_reg[1]  ( .D(n53), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[1]) );
  DFFSR \XMT_shftreg_reg[2]  ( .D(n97), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[2]) );
  DFFSR \XMT_datareg_reg[0]  ( .D(n54), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
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
  OAI22X1 U3 ( .A(n38), .B(n39), .C(start), .D(n40), .Y(n99) );
  AOI21X1 U4 ( .A(Serial_out), .B(n41), .C(n42), .Y(n40) );
  INVX1 U5 ( .A(XMT_shftreg[1]), .Y(n38) );
  OAI21X1 U6 ( .A(n39), .B(n43), .C(n44), .Y(n98) );
  AOI22X1 U7 ( .A(XMT_datareg[0]), .B(n42), .C(XMT_shftreg[1]), .D(n41), .Y(
        n44) );
  INVX1 U8 ( .A(XMT_shftreg[2]), .Y(n43) );
  OAI21X1 U9 ( .A(n39), .B(n45), .C(n46), .Y(n97) );
  AOI22X1 U10 ( .A(XMT_datareg[1]), .B(n42), .C(XMT_shftreg[2]), .D(n41), .Y(
        n46) );
  INVX1 U11 ( .A(XMT_shftreg[3]), .Y(n45) );
  OAI21X1 U12 ( .A(n39), .B(n55), .C(n56), .Y(n96) );
  AOI22X1 U13 ( .A(XMT_datareg[2]), .B(n42), .C(XMT_shftreg[3]), .D(n41), .Y(
        n56) );
  INVX1 U14 ( .A(XMT_shftreg[4]), .Y(n55) );
  OAI21X1 U15 ( .A(n39), .B(n57), .C(n65), .Y(n95) );
  AOI22X1 U16 ( .A(XMT_datareg[3]), .B(n42), .C(XMT_shftreg[4]), .D(n41), .Y(
        n65) );
  INVX1 U17 ( .A(XMT_shftreg[5]), .Y(n57) );
  OAI21X1 U18 ( .A(n39), .B(n68), .C(n71), .Y(n94) );
  AOI22X1 U19 ( .A(XMT_datareg[4]), .B(n42), .C(XMT_shftreg[5]), .D(n41), .Y(
        n71) );
  INVX1 U20 ( .A(XMT_shftreg[6]), .Y(n68) );
  OAI21X1 U21 ( .A(n39), .B(n74), .C(n77), .Y(n93) );
  AOI22X1 U22 ( .A(XMT_datareg[5]), .B(n42), .C(XMT_shftreg[6]), .D(n41), .Y(
        n77) );
  INVX1 U23 ( .A(XMT_shftreg[7]), .Y(n74) );
  OAI21X1 U24 ( .A(n39), .B(n80), .C(n83), .Y(n92) );
  AOI22X1 U25 ( .A(XMT_datareg[6]), .B(n42), .C(XMT_shftreg[7]), .D(n41), .Y(
        n83) );
  NOR2X1 U26 ( .A(n41), .B(shift), .Y(n42) );
  INVX1 U27 ( .A(XMT_shftreg[8]), .Y(n80) );
  NAND2X1 U28 ( .A(n86), .B(n39), .Y(n91) );
  MUX2X1 U29 ( .B(XMT_datareg[7]), .A(XMT_shftreg[8]), .S(n41), .Y(n86) );
  NOR2X1 U30 ( .A(shift), .B(Load_XMT_shftreg), .Y(n41) );
  AOI21X1 U31 ( .A(n39), .B(n100), .C(n101), .Y(n90) );
  MUX2X1 U32 ( .B(n102), .A(n101), .S(bit_count[1]), .Y(n89) );
  OR2X1 U33 ( .A(clear), .B(n103), .Y(n101) );
  NAND2X1 U34 ( .A(n103), .B(n104), .Y(n102) );
  INVX1 U35 ( .A(clear), .Y(n104) );
  NOR2X1 U36 ( .A(clear), .B(n105), .Y(n88) );
  XNOR2X1 U37 ( .A(bit_count[2]), .B(n106), .Y(n105) );
  NOR2X1 U38 ( .A(clear), .B(n107), .Y(n87) );
  XOR2X1 U39 ( .A(n108), .B(bit_count[3]), .Y(n107) );
  NAND2X1 U40 ( .A(n106), .B(bit_count[2]), .Y(n108) );
  AND2X1 U41 ( .A(n103), .B(bit_count[1]), .Y(n106) );
  NOR2X1 U42 ( .A(n100), .B(n39), .Y(n103) );
  INVX1 U43 ( .A(shift), .Y(n39) );
  INVX1 U44 ( .A(bit_count[0]), .Y(n100) );
  INVX1 U45 ( .A(n109), .Y(n54) );
  MUX2X1 U46 ( .B(XMT_datareg[0]), .A(Data_Bus[0]), .S(Load_XMT_DR), .Y(n109)
         );
  INVX1 U47 ( .A(n110), .Y(n53) );
  MUX2X1 U48 ( .B(XMT_datareg[1]), .A(Data_Bus[1]), .S(Load_XMT_DR), .Y(n110)
         );
  INVX1 U49 ( .A(n111), .Y(n52) );
  MUX2X1 U50 ( .B(XMT_datareg[2]), .A(Data_Bus[2]), .S(Load_XMT_DR), .Y(n111)
         );
  INVX1 U51 ( .A(n112), .Y(n51) );
  MUX2X1 U52 ( .B(XMT_datareg[3]), .A(Data_Bus[3]), .S(Load_XMT_DR), .Y(n112)
         );
  INVX1 U53 ( .A(n113), .Y(n50) );
  MUX2X1 U54 ( .B(XMT_datareg[4]), .A(Data_Bus[4]), .S(Load_XMT_DR), .Y(n113)
         );
  INVX1 U55 ( .A(n114), .Y(n49) );
  MUX2X1 U56 ( .B(XMT_datareg[5]), .A(Data_Bus[5]), .S(Load_XMT_DR), .Y(n114)
         );
  INVX1 U57 ( .A(n115), .Y(n48) );
  MUX2X1 U58 ( .B(XMT_datareg[6]), .A(Data_Bus[6]), .S(Load_XMT_DR), .Y(n115)
         );
  INVX1 U59 ( .A(n116), .Y(n47) );
  MUX2X1 U60 ( .B(XMT_datareg[7]), .A(Data_Bus[7]), .S(Load_XMT_DR), .Y(n116)
         );
  OAI21X1 U61 ( .A(bit_count[0]), .B(n117), .C(bit_count[3]), .Y(BC_lt_BCmax)
         );
  OR2X1 U62 ( .A(bit_count[1]), .B(bit_count[2]), .Y(n117) );
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

