/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP3
// Date      : Sat Mar 21 16:01:45 2020
/////////////////////////////////////////////////////////////

module WRAP_SRAM ( DataBus, AddressBus, ControlBus, InData, OutData, Address, 
        bCE, bWE, Breq, Bgnt, clk, bReset );
  inout [7:0] DataBus;
  inout [31:0] AddressBus;
  output [7:0] InData;
  input [7:0] OutData;
  output [17:0] Address;
  input Bgnt, clk, bReset;
  output bCE, bWE, Breq;
  inout ControlBus;
  wire   IntEnable, n41, n42, n43, n44, n45, n46, n47, n48, n49, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n2,
         n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39;
  tri   [7:0] DataBus;
  tri   AddressBus_31;
  tri   AddressBus_30;
  tri   AddressBus_29;
  tri   AddressBus_28;
  tri   [31:0] AddressBus;
  tri   ControlBus;
  tran( AddressBus_31, AddressBus[31]);
  tran( AddressBus_30, AddressBus[30]);
  tran( AddressBus_29, AddressBus[29]);
  tran( AddressBus_28, AddressBus[28]);

  DFFPOSX1 IntEnable_reg ( .D(n80), .CLK(clk), .Q(IntEnable) );
  DFFPOSX1 bWE_reg ( .D(n59), .CLK(clk), .Q(bWE) );
  DFFPOSX1 bCE_reg ( .D(n60), .CLK(clk), .Q(bCE) );
  DFFPOSX1 \InData_reg[7]  ( .D(n61), .CLK(clk), .Q(InData[7]) );
  DFFPOSX1 \Address_reg[17]  ( .D(n62), .CLK(clk), .Q(Address[17]) );
  DFFPOSX1 \Address_reg[16]  ( .D(n63), .CLK(clk), .Q(Address[16]) );
  DFFPOSX1 \Address_reg[15]  ( .D(n64), .CLK(clk), .Q(Address[15]) );
  DFFPOSX1 \Address_reg[14]  ( .D(n65), .CLK(clk), .Q(Address[14]) );
  DFFPOSX1 \Address_reg[13]  ( .D(n66), .CLK(clk), .Q(Address[13]) );
  DFFPOSX1 \Address_reg[12]  ( .D(n67), .CLK(clk), .Q(Address[12]) );
  DFFPOSX1 \Address_reg[11]  ( .D(n68), .CLK(clk), .Q(Address[11]) );
  DFFPOSX1 \Address_reg[10]  ( .D(n69), .CLK(clk), .Q(Address[10]) );
  DFFPOSX1 \Address_reg[9]  ( .D(n70), .CLK(clk), .Q(Address[9]) );
  DFFPOSX1 \Address_reg[8]  ( .D(n71), .CLK(clk), .Q(Address[8]) );
  DFFPOSX1 \Address_reg[7]  ( .D(n72), .CLK(clk), .Q(Address[7]) );
  DFFPOSX1 \Address_reg[6]  ( .D(n73), .CLK(clk), .Q(Address[6]) );
  DFFPOSX1 \Address_reg[5]  ( .D(n74), .CLK(clk), .Q(Address[5]) );
  DFFPOSX1 \Address_reg[4]  ( .D(n75), .CLK(clk), .Q(Address[4]) );
  DFFPOSX1 \Address_reg[3]  ( .D(n76), .CLK(clk), .Q(Address[3]) );
  DFFPOSX1 \Address_reg[2]  ( .D(n77), .CLK(clk), .Q(Address[2]) );
  DFFPOSX1 \Address_reg[1]  ( .D(n78), .CLK(clk), .Q(Address[1]) );
  DFFPOSX1 \Address_reg[0]  ( .D(n79), .CLK(clk), .Q(Address[0]) );
  DFFPOSX1 \InData_reg[6]  ( .D(n52), .CLK(clk), .Q(InData[6]) );
  DFFPOSX1 \InData_reg[5]  ( .D(n53), .CLK(clk), .Q(InData[5]) );
  DFFPOSX1 \InData_reg[4]  ( .D(n54), .CLK(clk), .Q(InData[4]) );
  DFFPOSX1 \InData_reg[3]  ( .D(n55), .CLK(clk), .Q(InData[3]) );
  DFFPOSX1 \InData_reg[2]  ( .D(n56), .CLK(clk), .Q(InData[2]) );
  DFFPOSX1 \InData_reg[1]  ( .D(n57), .CLK(clk), .Q(InData[1]) );
  DFFPOSX1 \InData_reg[0]  ( .D(n58), .CLK(clk), .Q(InData[0]) );
  DFFPOSX1 Breq_reg ( .D(n51), .CLK(clk), .Q(Breq) );
  TBUFX1 \DataBus_tri[0]  ( .A(n47), .EN(IntEnable), .Y(DataBus[0]) );
  TBUFX1 \DataBus_tri[1]  ( .A(n46), .EN(IntEnable), .Y(DataBus[1]) );
  TBUFX1 \DataBus_tri[2]  ( .A(n45), .EN(IntEnable), .Y(DataBus[2]) );
  TBUFX1 \DataBus_tri[3]  ( .A(n44), .EN(IntEnable), .Y(DataBus[3]) );
  TBUFX1 \DataBus_tri[4]  ( .A(n43), .EN(IntEnable), .Y(DataBus[4]) );
  TBUFX1 \DataBus_tri[5]  ( .A(n42), .EN(IntEnable), .Y(DataBus[5]) );
  TBUFX1 \DataBus_tri[6]  ( .A(n41), .EN(IntEnable), .Y(DataBus[6]) );
  TBUFX1 ControlBus_tri ( .A(1'b1), .EN(IntEnable), .Y(ControlBus) );
  OAI22X1 U83 ( .A(1'b1), .B(IntEnable), .C(n49), .D(n48), .Y(DataBus[7]) );
  BUFX2 U3 ( .A(n5), .Y(n2) );
  NOR2X1 U4 ( .A(n3), .B(n4), .Y(n80) );
  AOI21X1 U5 ( .A(n48), .B(Bgnt), .C(n2), .Y(n4) );
  INVX1 U6 ( .A(n6), .Y(n79) );
  MUX2X1 U7 ( .B(Address[0]), .A(AddressBus[0]), .S(n2), .Y(n6) );
  INVX1 U8 ( .A(n7), .Y(n78) );
  MUX2X1 U9 ( .B(Address[1]), .A(AddressBus[1]), .S(n2), .Y(n7) );
  INVX1 U10 ( .A(n8), .Y(n77) );
  MUX2X1 U11 ( .B(Address[2]), .A(AddressBus[2]), .S(n2), .Y(n8) );
  INVX1 U12 ( .A(n9), .Y(n76) );
  MUX2X1 U13 ( .B(Address[3]), .A(AddressBus[3]), .S(n2), .Y(n9) );
  INVX1 U14 ( .A(n10), .Y(n75) );
  MUX2X1 U15 ( .B(Address[4]), .A(AddressBus[4]), .S(n2), .Y(n10) );
  INVX1 U16 ( .A(n11), .Y(n74) );
  MUX2X1 U17 ( .B(Address[5]), .A(AddressBus[5]), .S(n2), .Y(n11) );
  INVX1 U18 ( .A(n12), .Y(n73) );
  MUX2X1 U19 ( .B(Address[6]), .A(AddressBus[6]), .S(n2), .Y(n12) );
  INVX1 U20 ( .A(n13), .Y(n72) );
  MUX2X1 U21 ( .B(Address[7]), .A(AddressBus[7]), .S(n2), .Y(n13) );
  INVX1 U22 ( .A(n14), .Y(n71) );
  MUX2X1 U23 ( .B(Address[8]), .A(AddressBus[8]), .S(n2), .Y(n14) );
  INVX1 U24 ( .A(n15), .Y(n70) );
  MUX2X1 U25 ( .B(Address[9]), .A(AddressBus[9]), .S(n2), .Y(n15) );
  INVX1 U26 ( .A(n16), .Y(n69) );
  MUX2X1 U27 ( .B(Address[10]), .A(AddressBus[10]), .S(n2), .Y(n16) );
  INVX1 U28 ( .A(n17), .Y(n68) );
  MUX2X1 U29 ( .B(Address[11]), .A(AddressBus[11]), .S(n2), .Y(n17) );
  INVX1 U30 ( .A(n18), .Y(n67) );
  MUX2X1 U31 ( .B(Address[12]), .A(AddressBus[12]), .S(n2), .Y(n18) );
  INVX1 U32 ( .A(n19), .Y(n66) );
  MUX2X1 U33 ( .B(Address[13]), .A(AddressBus[13]), .S(n2), .Y(n19) );
  INVX1 U34 ( .A(n20), .Y(n65) );
  MUX2X1 U35 ( .B(Address[14]), .A(AddressBus[14]), .S(n2), .Y(n20) );
  INVX1 U36 ( .A(n21), .Y(n64) );
  MUX2X1 U37 ( .B(Address[15]), .A(AddressBus[15]), .S(n2), .Y(n21) );
  INVX1 U38 ( .A(n22), .Y(n63) );
  MUX2X1 U39 ( .B(Address[16]), .A(AddressBus[16]), .S(n2), .Y(n22) );
  INVX1 U40 ( .A(n23), .Y(n62) );
  MUX2X1 U41 ( .B(Address[17]), .A(AddressBus[17]), .S(n2), .Y(n23) );
  INVX1 U42 ( .A(n24), .Y(n61) );
  MUX2X1 U43 ( .B(InData[7]), .A(DataBus[7]), .S(n2), .Y(n24) );
  INVX1 U44 ( .A(n25), .Y(n60) );
  MUX2X1 U45 ( .B(bCE), .A(AddressBus[19]), .S(n2), .Y(n25) );
  INVX1 U46 ( .A(n26), .Y(n59) );
  MUX2X1 U47 ( .B(bWE), .A(AddressBus[18]), .S(n2), .Y(n26) );
  INVX1 U48 ( .A(n27), .Y(n58) );
  MUX2X1 U49 ( .B(InData[0]), .A(DataBus[0]), .S(n2), .Y(n27) );
  INVX1 U50 ( .A(n28), .Y(n57) );
  MUX2X1 U51 ( .B(InData[1]), .A(DataBus[1]), .S(n2), .Y(n28) );
  INVX1 U52 ( .A(n29), .Y(n56) );
  MUX2X1 U53 ( .B(InData[2]), .A(DataBus[2]), .S(n2), .Y(n29) );
  INVX1 U54 ( .A(n30), .Y(n55) );
  MUX2X1 U55 ( .B(InData[3]), .A(DataBus[3]), .S(n2), .Y(n30) );
  INVX1 U56 ( .A(n31), .Y(n54) );
  MUX2X1 U57 ( .B(InData[4]), .A(DataBus[4]), .S(n2), .Y(n31) );
  INVX1 U58 ( .A(n32), .Y(n53) );
  MUX2X1 U59 ( .B(InData[5]), .A(DataBus[5]), .S(n2), .Y(n32) );
  INVX1 U60 ( .A(n33), .Y(n52) );
  MUX2X1 U61 ( .B(InData[6]), .A(DataBus[6]), .S(n2), .Y(n33) );
  NOR2X1 U62 ( .A(n34), .B(n3), .Y(n51) );
  INVX1 U63 ( .A(bReset), .Y(n3) );
  AOI22X1 U64 ( .A(n35), .B(n36), .C(Breq), .D(n2), .Y(n34) );
  NOR2X1 U65 ( .A(n37), .B(n48), .Y(n5) );
  INVX1 U66 ( .A(n37), .Y(n36) );
  NAND3X1 U67 ( .A(AddressBus_28), .B(n38), .C(n39), .Y(n37) );
  NOR2X1 U68 ( .A(AddressBus_31), .B(AddressBus_30), .Y(n39) );
  INVX1 U69 ( .A(AddressBus_29), .Y(n38) );
  NOR2X1 U70 ( .A(IntEnable), .B(Bgnt), .Y(n35) );
  INVX1 U71 ( .A(OutData[7]), .Y(n49) );
  INVX1 U72 ( .A(IntEnable), .Y(n48) );
  INVX1 U73 ( .A(OutData[0]), .Y(n47) );
  INVX1 U74 ( .A(OutData[1]), .Y(n46) );
  INVX1 U75 ( .A(OutData[2]), .Y(n45) );
  INVX1 U76 ( .A(OutData[3]), .Y(n44) );
  INVX1 U77 ( .A(OutData[4]), .Y(n43) );
  INVX1 U78 ( .A(OutData[5]), .Y(n42) );
  INVX1 U79 ( .A(OutData[6]), .Y(n41) );
endmodule


module Control_Unit ( Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, 
        Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b );
  input Load_XMT_datareg, Byte_ready, T_byte, BC_lt_BCmax, Clock, rst_b;
  output Load_XMT_DR, Load_XMT_shftreg, start, shift, clear;
  wire   N37, N39, N40, N42, N43, N44, N45, n4, n5, n6, n7, n8, n9, n10, n11,
         n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26;
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
  LATCH Load_XMT_DR_reg ( .CLK(N42), .D(N40), .Q(Load_XMT_DR) );
  LATCH Load_XMT_shftreg_reg ( .CLK(N42), .D(n4), .Q(Load_XMT_shftreg) );
  LATCH shift_reg ( .CLK(N42), .D(n5), .Q(shift) );
  LATCH start_reg ( .CLK(N42), .D(N37), .Q(start) );
  LATCH clear_reg ( .CLK(N42), .D(N39), .Q(clear) );
  INVX1 U6 ( .A(n6), .Y(n4) );
  OR2X1 U7 ( .A(n5), .B(N37), .Y(N45) );
  INVX1 U8 ( .A(n7), .Y(n5) );
  NAND3X1 U9 ( .A(BC_lt_BCmax), .B(n8), .C(rst_b), .Y(n7) );
  OAI21X1 U10 ( .A(T_byte), .B(n9), .C(n6), .Y(N44) );
  NAND3X1 U11 ( .A(n10), .B(rst_b), .C(n11), .Y(n6) );
  INVX1 U12 ( .A(n12), .Y(n10) );
  NAND2X1 U13 ( .A(n13), .B(rst_b), .Y(N43) );
  AOI22X1 U14 ( .A(n11), .B(n12), .C(n8), .D(n14), .Y(n13) );
  NAND2X1 U15 ( .A(Byte_ready), .B(n15), .Y(n12) );
  OAI21X1 U16 ( .A(n16), .B(n17), .C(rst_b), .Y(N42) );
  XOR2X1 U17 ( .A(state[2]), .B(n18), .Y(n17) );
  NOR2X1 U18 ( .A(state[0]), .B(state[1]), .Y(n18) );
  NOR2X1 U19 ( .A(n19), .B(n20), .Y(n16) );
  NOR2X1 U20 ( .A(n15), .B(n21), .Y(N40) );
  NAND2X1 U21 ( .A(n11), .B(rst_b), .Y(n21) );
  NOR3X1 U22 ( .A(state[1]), .B(state[2]), .C(n19), .Y(n11) );
  INVX1 U23 ( .A(Load_XMT_datareg), .Y(n15) );
  NOR2X1 U24 ( .A(n22), .B(n23), .Y(N39) );
  NAND2X1 U25 ( .A(n8), .B(n14), .Y(n23) );
  INVX1 U26 ( .A(BC_lt_BCmax), .Y(n14) );
  INVX1 U27 ( .A(n24), .Y(n8) );
  NAND3X1 U28 ( .A(n19), .B(n20), .C(state[2]), .Y(n24) );
  INVX1 U29 ( .A(state[1]), .Y(n20) );
  INVX1 U30 ( .A(state[0]), .Y(n19) );
  INVX1 U31 ( .A(rst_b), .Y(n22) );
  NOR2X1 U32 ( .A(n25), .B(n9), .Y(N37) );
  NAND3X1 U33 ( .A(state[1]), .B(rst_b), .C(n26), .Y(n9) );
  NOR2X1 U34 ( .A(state[2]), .B(state[0]), .Y(n26) );
  INVX1 U35 ( .A(T_byte), .Y(n25) );
endmodule


module Datapath_Unit ( Serial_out, BC_lt_BCmax, Data_Bus, Load_XMT_DR, 
        Load_XMT_shftreg, start, shift, clear, Clock, rst_b );
  input [7:0] Data_Bus;
  input Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, Clock, rst_b;
  output Serial_out, BC_lt_BCmax;
  wire   n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n1, n2, n24, n25, n26, n27,
         n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
         n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n70, n71;
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
  DFFSR \XMT_datareg_reg[7]  ( .D(n102), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[7]) );
  DFFSR \XMT_shftreg_reg[8]  ( .D(n86), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[8]) );
  DFFSR \XMT_datareg_reg[6]  ( .D(n101), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[6]) );
  DFFSR \XMT_shftreg_reg[7]  ( .D(n87), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[7]) );
  DFFSR \XMT_datareg_reg[5]  ( .D(n100), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[5]) );
  DFFSR \XMT_shftreg_reg[6]  ( .D(n88), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[6]) );
  DFFSR \XMT_datareg_reg[4]  ( .D(n99), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[4]) );
  DFFSR \XMT_shftreg_reg[5]  ( .D(n89), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[5]) );
  DFFSR \XMT_datareg_reg[3]  ( .D(n98), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[3]) );
  DFFSR \XMT_shftreg_reg[4]  ( .D(n90), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[4]) );
  DFFSR \XMT_datareg_reg[2]  ( .D(n97), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[2]) );
  DFFSR \XMT_shftreg_reg[3]  ( .D(n91), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[3]) );
  DFFSR \XMT_datareg_reg[1]  ( .D(n96), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[1]) );
  DFFSR \XMT_shftreg_reg[2]  ( .D(n92), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[2]) );
  DFFSR \XMT_datareg_reg[0]  ( .D(n95), .CLK(Clock), .R(rst_b), .S(1'b1), .Q(
        XMT_datareg[0]) );
  DFFSR \XMT_shftreg_reg[1]  ( .D(n94), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        XMT_shftreg[1]) );
  DFFSR \XMT_shftreg_reg[0]  ( .D(n93), .CLK(Clock), .R(1'b1), .S(rst_b), .Q(
        Serial_out) );
  INVX1 U24 ( .A(n1), .Y(n99) );
  MUX2X1 U25 ( .B(Data_Bus[4]), .A(XMT_datareg[4]), .S(n2), .Y(n1) );
  INVX1 U26 ( .A(n24), .Y(n98) );
  MUX2X1 U27 ( .B(Data_Bus[3]), .A(XMT_datareg[3]), .S(n2), .Y(n24) );
  INVX1 U28 ( .A(n25), .Y(n97) );
  MUX2X1 U29 ( .B(Data_Bus[2]), .A(XMT_datareg[2]), .S(n2), .Y(n25) );
  INVX1 U30 ( .A(n26), .Y(n96) );
  MUX2X1 U31 ( .B(Data_Bus[1]), .A(XMT_datareg[1]), .S(n2), .Y(n26) );
  INVX1 U32 ( .A(n27), .Y(n95) );
  MUX2X1 U33 ( .B(Data_Bus[0]), .A(XMT_datareg[0]), .S(n2), .Y(n27) );
  OAI21X1 U34 ( .A(n28), .B(n29), .C(n30), .Y(n94) );
  AOI22X1 U35 ( .A(n31), .B(XMT_datareg[0]), .C(XMT_shftreg[2]), .D(n32), .Y(
        n30) );
  OR2X1 U36 ( .A(n31), .B(n33), .Y(n93) );
  MUX2X1 U37 ( .B(n34), .A(n29), .S(n28), .Y(n33) );
  INVX1 U38 ( .A(XMT_shftreg[1]), .Y(n29) );
  OAI21X1 U39 ( .A(Load_XMT_DR), .B(n35), .C(Serial_out), .Y(n34) );
  OAI21X1 U40 ( .A(n28), .B(n36), .C(n37), .Y(n92) );
  AOI22X1 U41 ( .A(n31), .B(XMT_datareg[1]), .C(XMT_shftreg[3]), .D(n32), .Y(
        n37) );
  INVX1 U42 ( .A(XMT_shftreg[2]), .Y(n36) );
  OAI21X1 U43 ( .A(n28), .B(n38), .C(n39), .Y(n91) );
  AOI22X1 U44 ( .A(n31), .B(XMT_datareg[2]), .C(XMT_shftreg[4]), .D(n32), .Y(
        n39) );
  INVX1 U45 ( .A(XMT_shftreg[3]), .Y(n38) );
  OAI21X1 U46 ( .A(n28), .B(n40), .C(n41), .Y(n90) );
  AOI22X1 U47 ( .A(n31), .B(XMT_datareg[3]), .C(XMT_shftreg[5]), .D(n32), .Y(
        n41) );
  INVX1 U48 ( .A(XMT_shftreg[4]), .Y(n40) );
  OAI21X1 U49 ( .A(n28), .B(n42), .C(n43), .Y(n89) );
  AOI22X1 U50 ( .A(n31), .B(XMT_datareg[4]), .C(XMT_shftreg[6]), .D(n32), .Y(
        n43) );
  INVX1 U51 ( .A(XMT_shftreg[5]), .Y(n42) );
  OAI21X1 U52 ( .A(n28), .B(n44), .C(n45), .Y(n88) );
  AOI22X1 U53 ( .A(XMT_datareg[5]), .B(n31), .C(XMT_shftreg[7]), .D(n32), .Y(
        n45) );
  INVX1 U54 ( .A(XMT_shftreg[6]), .Y(n44) );
  OAI21X1 U55 ( .A(n28), .B(n46), .C(n47), .Y(n87) );
  AOI22X1 U56 ( .A(XMT_datareg[6]), .B(n31), .C(XMT_shftreg[8]), .D(n32), .Y(
        n47) );
  INVX1 U57 ( .A(n48), .Y(n32) );
  AND2X1 U58 ( .A(Load_XMT_shftreg), .B(n28), .Y(n31) );
  INVX1 U59 ( .A(XMT_shftreg[7]), .Y(n46) );
  NAND2X1 U60 ( .A(n49), .B(n48), .Y(n86) );
  NAND2X1 U61 ( .A(n28), .B(n50), .Y(n48) );
  MUX2X1 U62 ( .B(XMT_shftreg[8]), .A(XMT_datareg[7]), .S(n28), .Y(n49) );
  AND2X1 U63 ( .A(n51), .B(n2), .Y(n28) );
  OAI21X1 U64 ( .A(start), .B(n52), .C(n50), .Y(n51) );
  MUX2X1 U65 ( .B(n53), .A(n54), .S(n55), .Y(n106) );
  NAND2X1 U66 ( .A(shift), .B(n53), .Y(n54) );
  INVX1 U67 ( .A(bit_count[0]), .Y(n53) );
  MUX2X1 U68 ( .B(n56), .A(n57), .S(bit_count[1]), .Y(n105) );
  MUX2X1 U69 ( .B(n58), .A(n59), .S(bit_count[2]), .Y(n104) );
  NAND2X1 U70 ( .A(n60), .B(bit_count[1]), .Y(n58) );
  MUX2X1 U71 ( .B(n61), .A(n62), .S(bit_count[3]), .Y(n103) );
  INVX1 U72 ( .A(n63), .Y(n62) );
  OAI21X1 U73 ( .A(n52), .B(bit_count[2]), .C(n59), .Y(n63) );
  INVX1 U74 ( .A(n64), .Y(n59) );
  OAI21X1 U75 ( .A(bit_count[1]), .B(n52), .C(n57), .Y(n64) );
  INVX1 U76 ( .A(n65), .Y(n57) );
  OAI21X1 U77 ( .A(bit_count[0]), .B(n52), .C(n55), .Y(n65) );
  INVX1 U78 ( .A(shift), .Y(n52) );
  NAND3X1 U79 ( .A(n60), .B(bit_count[1]), .C(bit_count[2]), .Y(n61) );
  INVX1 U80 ( .A(n56), .Y(n60) );
  NAND3X1 U81 ( .A(n55), .B(shift), .C(bit_count[0]), .Y(n56) );
  NOR2X1 U82 ( .A(n66), .B(n67), .Y(n55) );
  OAI21X1 U83 ( .A(clear), .B(shift), .C(n2), .Y(n67) );
  NAND2X1 U84 ( .A(n50), .B(n35), .Y(n66) );
  INVX1 U85 ( .A(start), .Y(n35) );
  INVX1 U86 ( .A(Load_XMT_shftreg), .Y(n50) );
  INVX1 U87 ( .A(n68), .Y(n102) );
  MUX2X1 U88 ( .B(Data_Bus[7]), .A(XMT_datareg[7]), .S(n2), .Y(n68) );
  INVX1 U89 ( .A(n69), .Y(n101) );
  MUX2X1 U90 ( .B(Data_Bus[6]), .A(XMT_datareg[6]), .S(n2), .Y(n69) );
  INVX1 U91 ( .A(n70), .Y(n100) );
  MUX2X1 U92 ( .B(Data_Bus[5]), .A(XMT_datareg[5]), .S(n2), .Y(n70) );
  INVX1 U93 ( .A(Load_XMT_DR), .Y(n2) );
  OAI21X1 U94 ( .A(bit_count[0]), .B(n71), .C(bit_count[3]), .Y(BC_lt_BCmax)
         );
  OR2X1 U95 ( .A(bit_count[1]), .B(bit_count[2]), .Y(n71) );
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


module WRAP_UART ( DataBus, AddressBus, ControlBus, InData, Load_XMT_datareg, 
        Byte_ready, T_byte, Breq, Bgnt, clk, bReset );
  inout [7:0] DataBus;
  inout [31:0] AddressBus;
  output [7:0] InData;
  input Bgnt, clk, bReset;
  output Load_XMT_datareg, Byte_ready, T_byte, Breq;
  inout ControlBus;
  wire   IntEnable, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15,
         n16, n17, n18, n19, n20, n21, n22, n23, n24;
  tri   [7:0] DataBus;
  tri   [31:0] AddressBus;
  tri   AddressBus_2;
  tri   AddressBus_1;
  tri   AddressBus_0;
  tri   ControlBus;
  tran( AddressBus_2, AddressBus[2]);
  tran( AddressBus_1, AddressBus[1]);
  tran( AddressBus_0, AddressBus[0]);

  DFFPOSX1 IntEnable_reg ( .D(n37), .CLK(clk), .Q(IntEnable) );
  DFFPOSX1 Load_XMT_datareg_reg ( .D(n26), .CLK(clk), .Q(Load_XMT_datareg) );
  DFFPOSX1 Byte_ready_reg ( .D(n27), .CLK(clk), .Q(Byte_ready) );
  DFFPOSX1 T_byte_reg ( .D(n28), .CLK(clk), .Q(T_byte) );
  DFFPOSX1 \InData_reg[7]  ( .D(n29), .CLK(clk), .Q(InData[7]) );
  DFFPOSX1 \InData_reg[6]  ( .D(n30), .CLK(clk), .Q(InData[6]) );
  DFFPOSX1 \InData_reg[5]  ( .D(n31), .CLK(clk), .Q(InData[5]) );
  DFFPOSX1 \InData_reg[4]  ( .D(n32), .CLK(clk), .Q(InData[4]) );
  DFFPOSX1 \InData_reg[3]  ( .D(n33), .CLK(clk), .Q(InData[3]) );
  DFFPOSX1 \InData_reg[2]  ( .D(n34), .CLK(clk), .Q(InData[2]) );
  DFFPOSX1 \InData_reg[1]  ( .D(n35), .CLK(clk), .Q(InData[1]) );
  DFFPOSX1 \InData_reg[0]  ( .D(n36), .CLK(clk), .Q(InData[0]) );
  DFFPOSX1 Breq_reg ( .D(n25), .CLK(clk), .Q(Breq) );
  TBUFX1 ControlBus_tri ( .A(1'b1), .EN(IntEnable), .Y(ControlBus) );
  NOR2X1 U3 ( .A(n2), .B(n3), .Y(n37) );
  MUX2X1 U4 ( .B(Bgnt), .A(n4), .S(IntEnable), .Y(n3) );
  INVX1 U5 ( .A(bReset), .Y(n2) );
  INVX1 U6 ( .A(n5), .Y(n36) );
  AOI22X1 U7 ( .A(DataBus[0]), .B(n6), .C(InData[0]), .D(n7), .Y(n5) );
  INVX1 U8 ( .A(n8), .Y(n35) );
  AOI22X1 U9 ( .A(DataBus[1]), .B(n6), .C(InData[1]), .D(n7), .Y(n8) );
  INVX1 U10 ( .A(n9), .Y(n34) );
  AOI22X1 U11 ( .A(DataBus[2]), .B(n6), .C(InData[2]), .D(n7), .Y(n9) );
  INVX1 U12 ( .A(n10), .Y(n33) );
  AOI22X1 U13 ( .A(DataBus[3]), .B(n6), .C(InData[3]), .D(n7), .Y(n10) );
  INVX1 U14 ( .A(n11), .Y(n32) );
  AOI22X1 U15 ( .A(DataBus[4]), .B(n6), .C(InData[4]), .D(n7), .Y(n11) );
  INVX1 U16 ( .A(n12), .Y(n31) );
  AOI22X1 U17 ( .A(DataBus[5]), .B(n6), .C(InData[5]), .D(n7), .Y(n12) );
  INVX1 U18 ( .A(n13), .Y(n30) );
  AOI22X1 U19 ( .A(DataBus[6]), .B(n6), .C(InData[6]), .D(n7), .Y(n13) );
  INVX1 U20 ( .A(n14), .Y(n29) );
  AOI22X1 U21 ( .A(DataBus[7]), .B(n6), .C(InData[7]), .D(n7), .Y(n14) );
  INVX1 U22 ( .A(n15), .Y(n28) );
  AOI22X1 U23 ( .A(AddressBus_2), .B(n6), .C(T_byte), .D(n7), .Y(n15) );
  INVX1 U24 ( .A(n16), .Y(n27) );
  AOI22X1 U25 ( .A(AddressBus_1), .B(n6), .C(Byte_ready), .D(n7), .Y(n16) );
  INVX1 U26 ( .A(n17), .Y(n26) );
  AOI22X1 U27 ( .A(AddressBus_0), .B(n6), .C(Load_XMT_datareg), .D(n7), .Y(n17) );
  INVX1 U28 ( .A(n18), .Y(n7) );
  AND2X1 U29 ( .A(IntEnable), .B(n18), .Y(n6) );
  NAND2X1 U30 ( .A(IntEnable), .B(n19), .Y(n18) );
  NOR2X1 U31 ( .A(n20), .B(n21), .Y(n25) );
  NAND2X1 U32 ( .A(n4), .B(bReset), .Y(n21) );
  INVX1 U33 ( .A(n19), .Y(n4) );
  NAND3X1 U34 ( .A(AddressBus[29]), .B(n22), .C(n23), .Y(n19) );
  NOR2X1 U35 ( .A(AddressBus[31]), .B(AddressBus[30]), .Y(n23) );
  INVX1 U36 ( .A(AddressBus[28]), .Y(n22) );
  MUX2X1 U37 ( .B(n24), .A(Breq), .S(IntEnable), .Y(n20) );
  INVX1 U38 ( .A(Bgnt), .Y(n24) );
endmodule


module Arbiter ( BREQn, BGNTn );
  input [2:0] BREQn;
  output [2:0] BGNTn;
  wire   \BREQn[2] , n1, n2, n3;
  assign BGNTn[2] = \BREQn[2] ;
  assign \BREQn[2]  = BREQn[2];

  INVX1 U1 ( .A(n1), .Y(BGNTn[1]) );
  NAND3X1 U2 ( .A(n2), .B(n3), .C(BREQn[1]), .Y(n1) );
  INVX1 U3 ( .A(\BREQn[2] ), .Y(n2) );
  NOR2X1 U4 ( .A(\BREQn[2] ), .B(n3), .Y(BGNTn[0]) );
  INVX1 U5 ( .A(BREQn[0]), .Y(n3) );
endmodule


module MAINSYSTEM ( Serial_out, clk, Breq, Bgnt, DataBus, AddressBus, 
        ControlBus, bReset );
  inout [7:0] DataBus;
  inout [31:0] AddressBus;
  input clk, Breq, bReset;
  output Serial_out, Bgnt;
  inout ControlBus;
  wire   bCE, bWE, Load_XMT_datareg, Byte_ready, T_byte;
  wire   [1:0] Bgntn;
  wire   [1:0] Breqn;
  wire   [7:0] InData;
  wire   [7:0] OutData;
  wire   [17:0] Address;
  wire   [7:0] DataToUART;
  tri   [7:0] DataBus;
  tri   [31:0] AddressBus;
  tri   ControlBus;

  SRAM SRAM_01 ( .InData(InData), .OutData(OutData), .Address(Address), .bCE(
        bCE), .bWE(bWE) );
  WRAP_SRAM WRAP_SRAM_01 ( .DataBus(DataBus), .AddressBus(AddressBus), 
        .ControlBus(ControlBus), .InData(InData), .OutData(OutData), .Address(
        Address), .bCE(bCE), .bWE(bWE), .Breq(Breqn[0]), .Bgnt(Bgntn[0]), 
        .clk(clk), .bReset(bReset) );
  UART_XMTR UART_XMTR_01 ( .Serial_out(Serial_out), .Data_Bus(DataToUART), 
        .Load_XMT_datareg(Load_XMT_datareg), .Byte_ready(Byte_ready), .T_byte(
        T_byte), .Clock(clk), .rst_b(bReset) );
  WRAP_UART WRAP_UART_01 ( .DataBus(DataBus), .AddressBus(AddressBus), 
        .ControlBus(ControlBus), .InData(DataToUART), .Load_XMT_datareg(
        Load_XMT_datareg), .Byte_ready(Byte_ready), .T_byte(T_byte), .Breq(
        Breqn[1]), .Bgnt(Bgntn[1]), .clk(clk), .bReset(bReset) );
  Arbiter Arbiter_01 ( .BREQn({Breq, Breqn}), .BGNTn({Bgnt, Bgntn}) );
endmodule

