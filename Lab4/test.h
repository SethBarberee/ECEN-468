#include "systemc.h"

#define DATA_WIDTH		8
#define REG_ROW			5
#define REG_COL			5
#define MEMORY_ROW		512
#define MEMORY_COL		510

#define MODE_GAUSSIAN		0
#define MODE_SOBEL		1
#define MODE_NMS		2
#define MODE_HYSTERESIS		3

#define REG_GAUSSIAN		0
#define REG_GRADIENT		1
#define REG_DIRECTION		2
#define REG_NMS			3
#define REG_HYSTERESIS		4

#define WRITE_REGX		0
#define WRITE_REGY		1
#define WRITE_REGZ		2

//#define _DEBUG_

#define USHORT	unsigned short
#define UINT	unsigned int

SC_MODULE(test){
	// Input/Output Signal
  	sc_out 	< sc_uint<3> >		AddrRegRow;
  	sc_out 	< sc_uint<3> >		AddrRegCol;
  	sc_out 	< bool > 		bWE	;
  	sc_out 	< bool > 		bCE	;
  	sc_out 	< sc_uint<DATA_WIDTH> >	InData	;
  	sc_in 	< sc_uint<DATA_WIDTH> > OutData ;

  	sc_out	< sc_uint<3> >		OPMode	;	
	sc_out  < bool >		bOPEnable;
	sc_out  < sc_uint<4> >		dReadReg;
	sc_out 	< sc_uint<4> >		dWriteReg;

  	sc_in 	< bool > 		clk	;
  	sc_out 	< bool > 		rst_b	;

  	// Internal Variables
	struct BMPHEADER {
		char	sMagicNum[2];	// 2 Bytes
		UINT	dSizeFile;	// 4 Bytes
		USHORT	dUnusedA;	// 2 Bytes
		USHORT	dUnusedB;	// 2 Bytes
		UINT	dOffsetBmp;	// 4 Bytes			
	};
	typedef struct BMPHEADER structBMPHeader;
	structBMPHeader BMPH;

	struct DIBHEADER {
		UINT		dNumDIBHeader;		// 4 bytes
		UINT		dWidth;				// 4 bytes
		UINT		dHeight;			// 4 bytes
		USHORT		dColorPlane;		// 2 bytes
		USHORT		dBitsPerPixel;		// 2 bytes
		UINT		dCompression;		// 4 bytes
		UINT		dSizeData;			// 4 bytes
		UINT		dHResolution;		// 4 bytes
		UINT		dVResolution;		// 4 bytes
		UINT		dNumPalette;		// 4 bytes
		UINT		dImportance;		// 4 bytes
	};
	typedef struct DIBHEADER structDIBHeader;
	structDIBHeader DIBH;

	short** memX;	// Input Image
	short** memXG;	// Gaussian applied Image
	short** Gxy;	// Gradient
	short** Theta;	// Direction
	//char** memX;	// NMS Image
	short** bGxy;	// Final Binary Image(0:0 / 1:255)
	char FILE_HEADER[0x36];
	short dDummyData;

	USHORT GetUSHORT(char *ca, int pos);
	UINT GetUINT(char *ca, int pos);

	void send_5x5(UINT posRow, UINT posCol);
	void send_3x3(UINT posRow, UINT posCol);
	void read_pixel(UINT posRow, UINT posCol);
	void read_3x3(UINT posRow, UINT posCol);

	void do_test();
	void GetBMPHeader(FILE *fp, short bOnMsg);
	void GetDIBHeader(FILE *fp, short bOnMsg);
	void GetBMPData(FILE *fp);
	void LoadBMPFile();

	void WriteBMPOut(short dMode);
	
	short** refmemA;
	short** refmemB;
	
	void GetRefData(FILE *fp, short dmode);
	void LoadRefFiles(short dmode);
	void CompareData(short dmode);

	// Constructor
	SC_CTOR(test) {
          	SC_CTHREAD(do_test, clk.neg());	// falling edge of the clk
          	//SC_CTHREAD(do_test, clk);     // rising or falling edge of the clk
			// Initialize output signals
			bWE.initialize(1);
			bCE.initialize(1);
			rst_b.initialize(0);
	}
};
