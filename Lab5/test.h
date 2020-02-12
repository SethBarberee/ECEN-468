#include "systemc.h"

#define WORD_SIZE         8 

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
        sc_in < bool >		clk;
        sc_out < bool >         bReset;
	sc_in < bool > 		Serial_out;

	sc_out < bool >		Breq;
	sc_in < bool >		Bgnt;

	sc_inout_rv < 8 >	DataBus;
	sc_inout_rv < 32 >	AddressBus;
	sc_inout_rv < 1 >	ControlBus;

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

	// BMP FILE PARCING 
	short** memX;
	short** memY;
	char FILE_HEADER[0x36];
	short dDummyData;
	void GetBMPHeader(FILE *fp, short bOnMsg);
	void GetDIBHeader(FILE *fp, short bOnMsg);
	void GetBMPData(FILE *fp);
	void LoadBMPFile();
	void WriteBMPOut(short dMode);
	
	// COMPARATOR
	short** refmemA;
	short** refmemB;
	void GetRefData(FILE *fp, short dmode);
	void LoadRefFiles(short dmode);
	void CompareData(short dmode);

	// USER DEFINED FUNCTIONS
	USHORT GetUSHORT(char *ca, int pos);
	UINT GetUINT(char *ca, int pos);
	UINT BITOFF(UINT dValue, UINT dPos);
	UINT BITON(UINT dValue, UINT dPos);
	
	// WITH CANNY EDGE DETECTOR
	void Init_to_Canny(void);
	void Do_3x3_Hysteresis(int posRow, int posCol);
	void Do_3x3_NMS(int posRow, int posCol);
	void Do_3x3_Sobel(int posRow, int posCol);
	void Do_5x5_Gaussian(int posRow, int posCol);
	UINT dReadReg, OPMode, dWriteReg;
	bool bOPEnable;

	// BUS CONTROL
	void ReleaseBus(void);

	// WITH MEMORY 
	void Send_Pixel_to_Mem(int posRow, int posCol, UINT data, UINT dOffset);
	UINT Read_Pixel_from_Mem(int posRow, int posCol, UINT dOffset);
	void Init_to_Mem(void);
	void GetMemoryData(short dReg, UINT dOffset);

	// WITH UART
	void SendUART(UINT dData);

	// TETS-BENCH TOP
	void do_test();
	
	// Constructor
	SC_CTOR(test) {
          SC_CTHREAD(do_test, clk.neg());// falling edge of the clk
          //SC_CTHREAD(do_test, clk);      // rising or falling edge of the clk
		// Initialize output signals
		bReset.initialize(0);
		Breq.initialize(0);
			
		DataBus.initialize("ZZZZZZZZ");
		AddressBus.initialize("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
		ControlBus.initialize("Z");
	}
};
