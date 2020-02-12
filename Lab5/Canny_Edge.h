//===========================================
// Function : Canny Edge Detector 
//===========================================
#include "systemc.h"

// #define _DEBUG_

// Data Width : 8 bits
#define DATA_WIDTH		8

// Register Matrix : 5x5 (also used for 3x3)
#define REG_ROW			5
#define REG_COL			5

// Operation Modes of Canny Edge Detector
#define MODE_GAUSSIAN		0		
#define MODE_SOBEL		1
#define MODE_NMS			2
#define MODE_HYSTERESIS		3

// Registers which store output values
#define REG_GAUSSIAN		0
#define REG_GRADIENT		1
#define REG_DIRECTION		2
#define REG_NMS			3
#define REG_HYSTERESIS		4

// Register Matrixs to store input values
#define WRITE_REGX		0
#define WRITE_REGY		1
#define WRITE_REGZ		2

SC_MODULE (Canny_Edge){
  sc_in 	< sc_uint<3> >		AddrRegRow;
  sc_in 	< sc_uint<3> >		AddrRegCol;
  sc_in 	< bool > 			bWE;
  sc_in 	< bool > 			bCE;
  sc_in 	< sc_uint<DATA_WIDTH> >	InData;
  sc_out 	< sc_uint<DATA_WIDTH> > OutData;

  sc_in	< sc_uint<3> >		OPMode;	
  sc_in 	< bool >			bOPEnable;
  sc_in	< sc_uint<4> >		dReadReg;
  sc_in	< sc_uint<4> >		dWriteReg;

  sc_in 	< bool > 			clk	;
  sc_in 	< bool > 			rst_b	;

  // Internal Variables
  sc_uint	< DATA_WIDTH > regX [REG_ROW][REG_COL];	// 5x5
  sc_uint	< DATA_WIDTH > regY [REG_ROW][REG_COL];	// 5x5
  sc_uint	< DATA_WIDTH > regZ [REG_ROW][REG_COL];	// 5x5

  // Gaussian Filter
  sc_uint	< DATA_WIDTH > gf [REG_ROW][REG_COL];	// 5x5

  // Sobel Operator
  sc_int	< DATA_WIDTH > Sobeldx [3][3]	;		// 3x3
  sc_int	< DATA_WIDTH > Sobeldy [3][3]	;		// 3x3

  sc_uint	< DATA_WIDTH > Out_gf, Out_gradient, Out_direction, Out_bThres;

  // ----- Code Starts Here ----- 
  void Write_Data();		// to Register array
  void Read_Data();		// from Register array
  void Initialize();		// Initialization of Gaussian Filter and Sobel operator
  void Apply_Operation();	// Main Operation

  // ----- Constructor for the SC_MODULE -----
  // sensitivity list
  SC_CTOR(Canny_Edge) {
    	SC_METHOD(Write_Data);
    	sensitive << clk.pos() << rst_b.neg();

    	SC_METHOD(Read_Data);
   	sensitive << clk.pos() << rst_b.neg();

	SC_METHOD(Apply_Operation);
	sensitive << clk.pos() << rst_b.neg();

    	SC_METHOD(Initialize);
    	sensitive << clk.pos() << rst_b.neg();
  }
};

