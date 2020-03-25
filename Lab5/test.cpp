#include "test.h"

#define TRUE 	1
#define FALSE	0

#define BMP_INPUT	0
#define BMP_ORIGIN	1
#define BMP_GAUSSIAN	2
#define BMP_GRADIENT	3
#define BMP_DIRECTION	4
#define BMP_NMS		5
#define BMP_HYSTERESIS	6

USHORT test::GetUSHORT(char *ca, int pos)
{
	short c0 = ca[pos];		if(c0<0)	c0=256+c0;
	short c1 = ca[pos+1];		if(c1<0)	c1=256+c1;

	UINT rtnV = c0+(c1<<8);
	return rtnV;
}

UINT test::GetUINT(char *ca, int pos)
{
	short c0 = ca[pos];		if(c0<0)	c0=256+c0;
	short c1 = ca[pos+1];		if(c1<0)	c1=256+c1;
	short c2 = ca[pos+2];		if(c2<0)	c2=256+c2;
	short c3 = ca[pos+3];		if(c3<0)	c3=256+c3;

	UINT rtnV = c0+(c1<<8)+(c2<<16)+(c3<<24);
	return rtnV;
}

void test::WriteBMPOut(short dMode){
	FILE *fp;
	
	if(dMode == 10){
		cout << " >> OUT: FINAL >>" << endl;	fp = fopen("OutputFinal.bmp", "wb");
	}
	else if(dMode == BMP_INPUT){
		cout << " >> OUT: INPUT >>" << endl;	fp = fopen("OutputInput.bmp", "wb");
	}
	else if(dMode == BMP_ORIGIN){
		cout << " >> OUT: ORIGIN >>" << endl;	fp = fopen("0.OutputOrigin.bmp", "wb");
	}
	else if(dMode == BMP_GAUSSIAN){
		cout << " >> OUT: GAUSSIAN >>" << endl;	fp = fopen("1.OutputGauss.bmp", "wb");
	}
	else if(dMode == BMP_GRADIENT){
		cout << " >> OUT: GRADIENT >>" << endl;	fp = fopen("2.OutputGradient.bmp", "wb");
	}
	else if(dMode == BMP_DIRECTION){
		cout << " >> OUT: ANGLE >>" << endl;	fp = fopen("3.OutputAngle.bmp", "wb");
	}
	else if(dMode == BMP_NMS){
		cout << " >> OUT: NMS >>" << endl;	fp = fopen("4.OutputNMS.bmp", "wb");
	}
	else if(dMode == BMP_HYSTERESIS){
		cout << " >> OUT: HYSTERESIS >>" << endl;fp = fopen("5.OutputThres.bmp", "wb");
	}
	else {
		cout << " >> OUT: DEFAULT >>" << endl;	fp = fopen("OutputDefault.bmp", "wb");
	}
	
	#define IX_END_OF_DIBHEADER	0x36

	int i;
	for(i=0; i<IX_END_OF_DIBHEADER; i++){
		fprintf(fp,"%c",FILE_HEADER[i]);
	}

	UINT j,k;
	short dValue;
	UINT reverse;
	for(j=0; j < DIBH.dHeight; j++){
		for(k=0; k < DIBH.dWidth; k++){
			reverse = DIBH.dHeight-j-1;
			if(dMode == BMP_INPUT)		dValue = memX[reverse][k];
			else if(dMode == BMP_GRADIENT)	dValue = memX[reverse][k];
			else				dValue = memY[reverse][k];

			if(dMode == BMP_HYSTERESIS){
				if(dValue!=0){
					fprintf(fp,"%c",255);
					fprintf(fp,"%c",255);
					fprintf(fp,"%c",255);
				}
				else {
					fprintf(fp,"%c",0);
					fprintf(fp,"%c",0);
					fprintf(fp,"%c",0);
				}
			}
			else if(dMode != BMP_DIRECTION){
				fprintf(fp,"%c",dValue);
				fprintf(fp,"%c",dValue);
				fprintf(fp,"%c",dValue);
			}
			else {
				char dValueG=0;
				char dValueB=0;
				char dValueR=0;
				// Edge Direction 90 = Edge Normal 0 Degree
				if(dValue==90){			
					dValueG = 255;
					dValueR = 255;
				}
				// Edge Direction 135 = Edge Normal 45 Degree
				else if(dValue==135){
					dValueG = 255;
				}
				// Edge Direction 0 = Edge Normal 90 Degree
				else if(dValue==0){
					dValueB = 255;
				}
				// Edge Direction 45 = Edge Normal 135 Degree
				else {
					dValueR = 255;
				}
				fprintf(fp,"%c",dValueB);
				fprintf(fp,"%c",dValueG);
				fprintf(fp,"%c",dValueR);
			}
		}
		if(dDummyData != 0)	
			fprintf(fp,"%c%c",0x00,0x00);
	}
	fclose(fp);
}

void test::GetBMPHeader(FILE *fp, short bOnMsg){
	
	#define IX_MAGIC_NUMBER		0x00
	#define IX_SIZE_FILE		0x02
	#define IX_UNUSED_A		0x06
	#define IX_UNUSED_B		0x08
	#define IX_OFFSET_DATA		0x0A
	#define IX_END_OF_BMPHEADER	0x0E

	char c[IX_END_OF_BMPHEADER];
	short i;
	for(i=0; i<IX_END_OF_BMPHEADER; i++){
		c[i]=fgetc(fp);
		FILE_HEADER[i]=c[i];
	}

	BMPH.sMagicNum[0]	= c[IX_MAGIC_NUMBER];
	BMPH.sMagicNum[1]	= c[IX_MAGIC_NUMBER+1];
	BMPH.dSizeFile		= GetUINT(c, IX_SIZE_FILE);
	BMPH.dOffsetBmp		= GetUINT(c, IX_OFFSET_DATA);

	if(bOnMsg){
		cout << endl << " ----- BMP HEADER -----" << endl;
		cout << "> MAGIC NUMBER : " << BMPH.sMagicNum[0] << BMPH.sMagicNum[1] << endl;
		cout << "> FILE SIZE : " << dec << BMPH.dSizeFile << " bytes" << endl;
		cout << "> OFFSET OF BMP DATA : 0x" << hex << BMPH.dOffsetBmp << endl;
	}
}

void test::GetDIBHeader(FILE *fp, short bOnMsg){
	#define IX_NUM_DIBHEADER	0x0E
	#define IX_WIDTH		0x12
	#define IX_HEIGHT		0x16
	#define IX_COLOR_PLANE		0x1A
	#define IX_BIT_PER_PIXEL	0x1C
	// THE BELOWS ARE ONLY FOR 24BITS/pPIXEL
	#define IX_COMPRESSION		0x1E
	#define IX_SIZE_DATA		0x22
	#define IX_H_RESOLUTION		0x26
	#define IX_V_RESOLUTION		0x2A
	#define IX_NUM_PALETTE		0x2E
	#define IX_IMPORTANCE		0x32
	#define IX_END_OF_DIBHEADER	0x36

	char c[IX_END_OF_DIBHEADER];
	short i;
	for(i=IX_NUM_DIBHEADER; i<IX_END_OF_DIBHEADER; i++){
		c[i]=fgetc(fp);
		FILE_HEADER[i]=c[i];
	}

	DIBH.dNumDIBHeader		= GetUINT(c, IX_NUM_DIBHEADER);
	DIBH.dWidth			= GetUINT(c, IX_WIDTH);
	DIBH.dHeight			= GetUINT(c, IX_HEIGHT);
	DIBH.dColorPlane		= GetUINT(c, IX_COLOR_PLANE);
	DIBH.dBitsPerPixel		= GetUINT(c, IX_BIT_PER_PIXEL);
	DIBH.dCompression		= GetUINT(c, IX_COMPRESSION);
	DIBH.dSizeData			= GetUINT(c, IX_SIZE_DATA);
	DIBH.dHResolution		= GetUINT(c, IX_H_RESOLUTION);
	DIBH.dVResolution		= GetUINT(c, IX_V_RESOLUTION);
	DIBH.dNumPalette		= GetUINT(c, IX_NUM_PALETTE);
	DIBH.dImportance		= GetUINT(c, IX_IMPORTANCE);

	// Error Correction
	DIBH.dSizeData = DIBH.dHeight*(DIBH.dWidth*3+2);

	if(bOnMsg){
		cout << endl << " ----- DIB HEADER -----" << endl;
		cout << " > NUMBER OF DIB HEADER : 0d" 	<< dec << DIBH.dNumDIBHeader 	<< " bytes" << endl;
		cout << " > WIDTH : " 			<< dec << DIBH.dWidth		<< " Pixels" << endl;
		cout << " > HEIGHT : "			<< dec << DIBH.dHeight		<< " Pixels" << endl;
		cout << " > COLOR PLANE : "		<< dec << DIBH.dColorPlane	<< " Plane" << endl;
		cout << " > BITS/PIXEL : "		<< dec << DIBH.dBitsPerPixel	<< " bpp" << endl;
		cout << " > COMPRESSION : "		<< dec << DIBH.dCompression	<< endl;
		cout << " > SIZE OF DATA : "		<< dec << DIBH.dSizeData	<< " bytes" << endl;
		cout << " > H-RESOLUTION : "		<< dec << DIBH.dHResolution	<< " Pixels/Meter" << endl;
		cout << " > V-RESOLUTION : "		<< dec << DIBH.dVResolution	<< " Pixels/Meter" << endl;
		cout << " > NUMBER OF PALETTE :	"	<< dec << DIBH.dNumPalette	<< endl;
		cout << " > IMPORTANCE : "		<< dec << DIBH.dImportance	<< endl;
	}
}

void test::GetBMPData(FILE *fp)
{
	char* c;
	UINT dSizeLine=DIBH.dWidth*3+2;
	c = (char*) malloc (dSizeLine*sizeof(char));

	cout << endl << " ----- BMP DATA -----" << endl;

	UINT i;
	memX = (short**) malloc (sizeof(short*)*DIBH.dHeight);
	for(i=0; i<DIBH.dHeight; i++){
		memX[i] = (short*) malloc (sizeof(short)*DIBH.dWidth);
	}
	memY = (short**) malloc (sizeof(short*)*DIBH.dHeight);
	for(i=0; i<DIBH.dHeight; i++){
		memY[i] = (short*) malloc (sizeof(short)*DIBH.dWidth);
	}
	
	UINT k;
	// Initialization
	for(i=0; i<DIBH.dHeight; i++){
		for(k=0; k < DIBH.dWidth; k++){
			memY[i][k]=0;
		}
	}

	USHORT dValue;
	UINT pos;
	UINT reverse;

	for(i=0; i<DIBH.dHeight; i++){
		int dNumLineData;
		if(dDummyData != 0)
			dNumLineData = fread(c, sizeof(char), DIBH.dWidth*3+2, fp);
		else
			dNumLineData = fread(c, sizeof(char), DIBH.dWidth*3, fp);

		for(k=0; k < DIBH.dWidth; k++){
			pos = 3*k;
			short cG = c[pos];		if(cG<0)	cG=256+cG;
			short cB = c[pos+1];		if(cB<0)	cB=256+cB;
			short cR = c[pos+2];		if(cR<0)	cR=256+cR;
			dValue = cG;

			reverse = DIBH.dHeight-i-1;
			memX[reverse][k]=dValue;
		}
	}

	cout << " > Create memX[][] Array" << endl;
	cout << " > Create memY[][] Array" << endl;
	free(c);
}

void test::LoadRefFiles(short dmode){
	FILE *fp;
	FILE *fp2;
	if(dmode==0)		fp = fopen("0.ref.bmp", "rb");
	else if(dmode==1)	fp = fopen("1.ref.bmp", "rb");
	else if(dmode==2)	fp = fopen("2.ref.bmp", "rb");
	else if(dmode==3)	fp = fopen("3.ref.bmp", "rb");
	else if(dmode==4)	fp = fopen("4.ref.bmp", "rb");
	else if(dmode==5)	fp = fopen("5.ref.bmp", "rb");

	dDummyData = 0;

	// Parcing Information
	// The variable 'dDummyData' can be 2 or 0 whether the bmp image which is used has dummy data or not.
	
	if(fp==NULL){
	        cout << "> FAIL: The reference file is not exist !!!" << endl;
	}
	else {
		//cout << "> SUCCESS: The reference file was read successfully." << endl;

		// DO SOMETHING ..
		GetBMPHeader(fp, 0);
		GetDIBHeader(fp, 0);
		GetRefData(fp, 0);
		
		if(dmode==0)		fp2 = fopen("0.OutputOrigin.bmp", "rb");
		else if(dmode==1)	fp2 = fopen("1.OutputGauss.bmp", "rb");
		else if(dmode==2)	fp2 = fopen("2.OutputGradient.bmp", "rb");
		else if(dmode==3)	fp2 = fopen("3.OutputAngle.bmp", "rb");
		else if(dmode==4)	fp2 = fopen("4.OutputNMS.bmp", "rb");
		else if(dmode==5)	fp2 = fopen("5.OutputThres.bmp", "rb");

		
		if(fp==NULL){
		        cout << "> FAIL: The output file is not exist !!!" << endl;
		}
		else {
			//cout << "> SUCCESS: The output file was read successfully." << endl;
	
			// DO SOMETHING ..
			GetBMPHeader(fp2, 0);
			GetDIBHeader(fp2, 0);
			GetRefData(fp2, 1);
			
			fclose(fp2);
		}	

		fclose(fp);
	}
}

void test::GetRefData(FILE *fp, short dmode)
{
	char* c;
	UINT dSizeLine=DIBH.dWidth*3+2;
	c = (char*) malloc (dSizeLine*sizeof(char));

	//cout << endl << " ----- BMP DATA -----" << endl;
	UINT i;

	if(dmode == 0){	
		refmemA = (short**) malloc (sizeof(short*)*DIBH.dHeight);
		for(i=0; i<DIBH.dHeight; i++){
			refmemA[i] = (short*) malloc (sizeof(short)*DIBH.dWidth*3);
		}
	}
	else if(dmode == 1){
		refmemB = (short**) malloc (sizeof(short*)*DIBH.dHeight);
		for(i=0; i<DIBH.dHeight; i++){
			refmemB[i] = (short*) malloc (sizeof(short)*DIBH.dWidth*3);
		}
	}

	USHORT dValue;
	UINT pos;
	UINT reverse;

	UINT k;	
	for(i=0; i<DIBH.dHeight; i++){
		int dNumLineData;
		if(dDummyData != 0)
			dNumLineData = fread(c, sizeof(char), DIBH.dWidth*3+2, fp);
		else
			dNumLineData = fread(c, sizeof(char), DIBH.dWidth*3, fp);

		for(k=0; k < DIBH.dWidth*3; k++){
			reverse = DIBH.dHeight-i-1;
			if(dmode==0)			refmemA[reverse][k]=c[k];
			else if(dmode==1)		refmemB[reverse][k]=c[k];

		}
	}

	//cout << " > Create reference Array" << endl;
	free(c);
}

void test::CompareData(short dmode){
	float sum=0;
	UINT i,j;
	float diff=0;
	for(i=0; i<DIBH.dHeight; i++){
		for(j=0; j<DIBH.dWidth*3; j++){
			diff = refmemA[i][j] - refmemB[i][j];
			if(diff > 0)	sum = sum + diff;
			else		sum = sum - diff;
		}
	}
	sum = (sum) / (DIBH.dHeight*DIBH.dWidth*3);
	sum = (float)100 - sum;

	cout << " > " << dmode << "th Matching Ratio : " << sum << "percent" << endl;
}


void test::LoadBMPFile(){
	FILE *fp;
	//fp = fopen("cman.bmp", "rb");
	//fp = fopen("cman_190.bmp", "rb");
	fp = fopen("cman_200.bmp", "rb");
    //fp = fopen("kodim23_50.bmp", "rb"); 
	//fp = fopen("kodim21_200.bmp", "rb");
	dDummyData = 0;
	// Parcing Information
	// The variable 'dDummyData' can be 2 or 0 whether the bmp image which is used has dummy data or not.

	if(fp==NULL){
	        cout << "> FAIL: The file is not exist !!!" << endl;
	}
	else {
		cout << "> SUCCESS: The file was read successfully." << endl;

		// DO SOMETHING ..
		GetBMPHeader(fp, 1);
		GetDIBHeader(fp, 1);
		GetBMPData(fp);

		fclose(fp);
	}
}

#define IDX_CANNY_bCE	0
#define IDX_CANNY_bOPEnable 27

void test::Init_to_Canny(void)
{
	UINT IDCANNY = 4;
	bool bWE = 0;
	bool bCE = 1;
	UINT Addr;
	UINT AddressOut=0;
	bOPEnable = 1;
	int tRow = 1;
	int tCol = 1;
	AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
	AddressBus.write(AddressOut);
	DataBus.write("ZZZZZZZZ");
	wait(3);
}

void test::Do_3x3_Hysteresis(int posRow, int posCol)
{
	short dBlockA3x3[3][3];
	short dBlockB3x3[3][3];
	short dBlockC3x3[3][3];
	UINT dOffsetBlock = DIBH.dHeight*DIBH.dWidth;

	int tRow, tCol;
	if(posRow<1 || posCol<1 || posRow>=(int)(DIBH.dHeight-1) || posCol>=int(DIBH.dWidth-1)){
		// Non Gradient and Angle
		Init_to_Mem();
		Send_Pixel_to_Mem(posRow, posCol, 0x00, dOffsetBlock*4);	// IMAGE_HYSTERESIS
	}
	else {
		Init_to_Mem();
		// Read 3x3 block from Memory
		for(tRow=-1; tRow<=1; tRow++){
			for(tCol=-1; tCol<=1; tCol++){
				// ( dBlockA3x3 <= dOffsetBlock*2(IMAGE_NMS) in memory )
                            dBlockA3x3[tRow+1][tCol+1]=Read_Pixel_from_Mem(posRow+tRow,posCol+tCol,dOffsetBlock*2);	//IMAGE_DIRECTION
			}
		}
		// Read 3x3 block from Memory
		for(tRow=-1; tRow<=1; tRow++){
			for(tCol=-1; tCol<=1; tCol++){
                                // ( dBlockB3x3<= dOffsetBlock*3(IMAGE_DIRECTION) in memory )
                            dBlockB3x3[tRow+1][tCol+1]=Read_Pixel_from_Mem(posRow+tRow,posCol+tCol,dOffsetBlock*3);	//IMAGE_DIRECTION

			}
		}
		// Read 3x3 block from Memory
		for(tRow=-1; tRow<=1; tRow++){
			for(tCol=-1; tCol<=1; tCol++){
				// ( dBlockC3x3<= dOffsetBlock*4(IMAGE_HYSTERESIS) in memory )
                            dBlockC3x3[tRow+1][tCol+1]=Read_Pixel_from_Mem(posRow+tRow,posCol+tCol,dOffsetBlock*4);	//IMAGE_HYSTERESIS
			}
		}
		wait(1);
		ReleaseBus();

		Init_to_Canny();
		// (Setting Control variables)
                UINT IDCANNY = 4;
                bool bWE = 0;
                bool bCE = 1;
                UINT Addr;
                UINT AddressOut=0;
		// Send 3x3 block to Canny
		// a. Set the variable dWriteReg to WRITE_REGX
		// b. Send dBlockA3x3 to Canny
                dWriteReg = WRITE_REGX;
		for(tRow=0; tRow<3; tRow++){
			for(tCol=0; tCol<3; tCol++){
				DataBus.write(dBlockA3x3[tRow][tCol]);
				AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
				AddressBus.write(AddressOut);
				wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
				wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
			}
		}
		// Send 3x3 block to Canny
		// a. Set the variable dWriteReg to WRITE_REGY
		// b. Send dBlockB3x3 to Canny
                dWriteReg = WRITE_REGY;
		for(tRow=0; tRow<3; tRow++){
			for(tCol=0; tCol<3; tCol++){
				DataBus.write(dBlockB3x3[tRow][tCol]);
				AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
				AddressBus.write(AddressOut);
				wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
				wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
			}
		}
		// Send 3x3 block to Canny
		// a. Set the variable dWriteReg to WRITE_REGZ
		// b. Send dBlockBCx3 to Canny
                dWriteReg = WRITE_REGZ;
		for(tRow=0; tRow<3; tRow++){
			for(tCol=0; tCol<3; tCol++){
				DataBus.write(dBlockC3x3[tRow][tCol]);
				AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
				AddressBus.write(AddressOut);
				wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
				wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
			}
		}
		// Operation Enable
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bOPEnable));		
		wait(4);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bOPEnable));   

		// Read pixel from Canny
		tRow = 1; 	tCol = 1;	
		bWE = 1;	bCE = 1;
		dReadReg = REG_HYSTERESIS;
		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
		AddressBus.write(AddressOut);
		DataBus.write("ZZZZZZZZ");
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
        // Read from the DataBus
		wait(4);	UINT tValue = DataBus.read().to_uint();
		wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
		wait(1);	//ReleaseBus();
	
		// Send pixel to Memory	
		// Send pixel(tValue) to Memory(dOffsetBlock*4)
		Init_to_Mem();
		Send_Pixel_to_Mem(posRow, posCol, tValue, dOffsetBlock*4);	// IMAGE_HYSTERIES
		DataBus.write("ZZZZZZZZ");            
	}
}

void test::Do_3x3_NMS(int posRow, int posCol)
{
	short dBlockA3x3[3][3];
	short dBlockB3x3[3][3];
	UINT dOffsetBlock = DIBH.dHeight*DIBH.dWidth;
	
	int tRow, tCol;
	UINT Addr;
	UINT AddressOut;
	if(posRow<1 || posCol<1 || posRow>=(int)(DIBH.dHeight-1) || posCol>=int(DIBH.dWidth-1)){
		// Non Gradient and Angle
		Init_to_Mem();
		Send_Pixel_to_Mem(posRow, posCol, 0x00, dOffsetBlock*2);	// IMAGE_NMS
	}
	else {
		Init_to_Mem();
		// Read 3x3 block from Memory 
		for(tRow=-1; tRow<=1; tRow++){
			for(tCol=-1; tCol<=1; tCol++){
				// ( dBlockA3x3 <= dOffsetBlock*2(IMAGE_GRADIENT) in memory )
				dBlockA3x3[tRow+1][tCol+1]=Read_Pixel_from_Mem(posRow+tRow,posCol+tCol, dOffsetBlock * 2);	//IMAGE_GRADIENT
			}
		}

		// Read 3x3 block from Memory
		for(tRow=-1; tRow<=1; tRow++){
			for(tCol=-1; tCol<=1; tCol++){
				// ( dBlockB3x3 <= dOffsetBlock*3(IMAGE_DIRECTION) in memory )
                            dBlockB3x3[tRow+1][tCol+1]=Read_Pixel_from_Mem(posRow+tRow,posCol+tCol,dOffsetBlock*3);	//IMAGE_DIRECTION
			}
		}
		wait(1);
		ReleaseBus();

		Init_to_Canny();
		// (Setting Control variables)
                UINT IDCANNY = 4;
                bool bWE = 0;
                bool bCE = 1;
                bOPEnable = 1;
                dWriteReg = WRITE_REGX;
                UINT AddressOut = 0;
		// Send 3x3 block to Canny
		// a. Set the variable dWriteReg to WRITE_REGX
		// b. Send dBlockA3x3 to Canny
		for(tRow=0; tRow<3; tRow++){
			for(tCol=0; tCol<3; tCol++){
				DataBus.write(dBlockA3x3[tRow][tCol]);
				AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
				AddressBus.write(AddressOut);
                                wait(1); AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
                                wait(1); AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
			}
		}                
		// Send 3x3 block to Canny
		// a. Set the variable dWriteReg to WRITE_REGY
		// b. Send dBlockB3x3 to Canny
                dWriteReg = WRITE_REGY;
		for(tRow=0; tRow<3; tRow++){
			for(tCol=0; tCol<3; tCol++){
				DataBus.write(dBlockB3x3[tRow][tCol]);
				AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
				AddressBus.write(AddressOut);
                                wait(1); AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
                                wait(1); AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
			}
		}                
		// Operation Enable
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bOPEnable));		
		wait(10);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bOPEnable));   	
		// Read 3x3 block from Canny to dBlockC3x3[tRow][tCol] 
		UINT dBlockC3x3[3][3];
		dReadReg = REG_NMS;
		bWE = 1;	bCE = 1;
		// Read NMS
		for(tRow=0; tRow<3; tRow++){
                  for(tCol=0; tCol<3; tCol++){
                    AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+((tRow)<<5)+((tCol)<<2)+(bWE<<1)+bCE;
		    AddressBus.write(AddressOut);
                    DataBus.write("ZZZZZZZZ");
                    wait(1); AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
                    wait(4); dBlockC3x3[tRow][tCol] = DataBus.read().to_uint();
                    wait(1); AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE)); 
                    wait(1);
                  }
                }
		// Send 3x3 block to Memory	
		Init_to_Mem();
		for(tRow=-1; tRow<1; tRow++){
			for(tCol=-1; tCol<1; tCol++){
				Send_Pixel_to_Mem(posRow+tRow, posCol+tCol, dBlockC3x3[tRow + 1][tCol + 1], dOffsetBlock*2);	// IMAGE_NMS
			}
		}
		DataBus.write("ZZZZZZZZ");
	}
}

void test::Do_3x3_Sobel(int posRow, int posCol)
{
	short dBlock3x3[3][3];
	UINT dOffsetBlock = DIBH.dHeight*DIBH.dWidth;
	
	int tRow, tCol;
	if(posRow<1 || posCol<1 || posRow>=(int)(DIBH.dHeight-1) || posCol>=int(DIBH.dWidth-1)){
		// Non Gradient and Angle
		Init_to_Mem();
		Send_Pixel_to_Mem(posRow, posCol, 0x00, dOffsetBlock*2);	// IMAGE_GRADIENT
		Send_Pixel_to_Mem(posRow, posCol, 0x00, dOffsetBlock*3);	// IMAGE_DIRECTION
	}
	else {
		Init_to_Mem();
		// Read 3x3 block from Memory
		for(tRow=-1; tRow<=1; tRow++){
			for(tCol=-1; tCol<=1; tCol++){
				dBlock3x3[tRow+1][tCol+1]=Read_Pixel_from_Mem(posRow+tRow,posCol+tCol,dOffsetBlock*1);	//IMAGE_GAUSSIAN
			}
		}
		wait(1);
		ReleaseBus();

		Init_to_Canny();
		UINT IDCANNY = 4;
		bool bWE = 0;
		bool bCE = 1;
		UINT Addr;
		UINT AddressOut=0;
		bOPEnable = 1;
		// Send 3x3 block to Canny
		for(tRow=0; tRow<3; tRow++){
			for(tCol=0; tCol<3; tCol++){
				DataBus.write(dBlock3x3[tRow][tCol]);
				AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
				AddressBus.write(AddressOut);
				wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
				wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
			}
		}
		// Operation Enable
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bOPEnable));		
		wait(4);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bOPEnable));		
		
		// Read pixel from Canny
		UINT tGradient, tDirection;
		tRow = 1; 	tCol = 1;	
		bWE = 1;	bCE = 1;
		// Read Gradient
		dReadReg = REG_GRADIENT;
		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
		AddressBus.write(AddressOut);
		DataBus.write("ZZZZZZZZ");
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
		wait(4);	tGradient = DataBus.read().to_uint();
		wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
		wait(1);	
		// Read Direction
		dReadReg = REG_DIRECTION;
		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
		AddressBus.write(AddressOut);
		DataBus.write("ZZZZZZZZ");
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
		wait(4);	tDirection = DataBus.read().to_uint();
		wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
		wait(1);	
	
		// Send pixel to Memory	
		Init_to_Mem();
		Send_Pixel_to_Mem(posRow, posCol, tGradient, dOffsetBlock*2);	// IMAGE_GRADIENT
		Send_Pixel_to_Mem(posRow, posCol, tDirection, dOffsetBlock*3);	// IMAGE_DIRECTION
		DataBus.write("ZZZZZZZZ");
	}
}
void test::Do_5x5_Gaussian(int posRow, int posCol)
{
	short dBlock5x5[5][5];
	UINT dOffsetBlock = DIBH.dHeight*DIBH.dWidth;

	int tRow, tCol;
	if(posRow<2 || posCol<2 || posRow>=(int)(DIBH.dHeight-2) || posCol>=int(DIBH.dWidth-2)){
		// Non Gaussian Smoothing
		Send_Pixel_to_Mem(posRow, posCol, memX[posRow][posCol], dOffsetBlock*1);	// IMAGE_GAUSSIAN
	}
	else {
		Init_to_Mem();
		// Read 5x5 block from Memory
		for(tRow=-2; tRow<=2; tRow++){
			for(tCol=-2; tCol<=2; tCol++){
				dBlock5x5[tRow+2][tCol+2]=Read_Pixel_from_Mem(posRow+tRow,posCol+tCol,0);	//IMAGE_ORIGIN
			}
		}
		wait(1);
		ReleaseBus();

		Init_to_Canny();
		UINT IDCANNY = 4;
		bool bWE = 0;
		bool bCE = 1;
		UINT Addr;
		UINT AddressOut=0;
		bOPEnable = 1;
		// Send 5x5 block to Canny
		for(tRow=0; tRow<5; tRow++){
			for(tCol=0; tCol<5; tCol++){
				DataBus.write(dBlock5x5[tRow][tCol]);
				AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
				AddressBus.write(AddressOut);
				wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
				wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
			}
		}
		// Operation Enable
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bOPEnable));		
		wait(4);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bOPEnable));		
		
		// Read pixel from Canny
		tRow = 2; 	tCol = 2;	
		bWE = 1;	bCE = 1;
		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(tRow<<5)+(tCol<<2)+(bWE<<1)+bCE;
		AddressBus.write(AddressOut);
		DataBus.write("ZZZZZZZZ");
		wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_CANNY_bCE));
		wait(4);	UINT tValue = DataBus.read().to_uint();
		wait(1);	AddressBus.write(BITON(AddressOut, IDX_CANNY_bCE));
		wait(1);	//ReleaseBus();
	
		// Send pixel to Memory	
		Init_to_Mem();
		Send_Pixel_to_Mem(posRow, posCol, tValue, dOffsetBlock*1);	// IMAGE_GAUSSIAN
		DataBus.write("ZZZZZZZZ");
	}
}

void test::ReleaseBus(void){
  	// Reset
	wait(1);
	DataBus.write("ZZZZZZZZ");
	AddressBus.write(0x00000000);
	wait(1);
	AddressBus.write("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
}

#define	IDX_MEM_bCE		19

UINT test::BITOFF(UINT dValue, UINT dPos)
{
	UINT rtnV = dValue & ~(1<<dPos);
	return rtnV;
}

UINT test::BITON(UINT dValue, UINT dPos)
{
	UINT rtnV = dValue | (1<<dPos);
	return rtnV;
}

void test::Init_to_Mem(void)
{
	bool bWE = 0;
	bool bCE = 1;
	UINT dAddr = 0;
	UINT IDMEM = 1;
	UINT AddressOut = 0;
	AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	AddressBus.write(AddressOut);
	DataBus.write("ZZZZZZZZ");
	wait(3);
}

void test::Send_Pixel_to_Mem(int posRow, int posCol, UINT data, UINT dOffset)
{
	bool bWE, bCE;
	UINT dAddr;
	UINT IDMEM = 1;
	UINT AddressOut=0;
	
	// Initial Setting : bWE=0, bCE=1, dAddr=dOffset+posRow+posCol*DIBH.dWidth, 
	bWE = 0;						// Write Mode
	bCE = 1;						// Chip Disable
	dAddr = dOffset+(posCol+(posRow*DIBH.dWidth));	
	AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	DataBus.write(data);
	AddressBus.write(AddressOut);
	// Write Operation
	wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_MEM_bCE));	//bCE = 0;
	wait(1);	AddressBus.write(BITON(AddressOut, IDX_MEM_bCE));	//bCE = 1;

#if defined (_DEBUG_)
cout << "[" << posRow << "][" << posCol << "]";
cout << "@" << sc_time_stamp() << ":: > Send: 0d" << memX[posRow][posCol] << endl;
#endif
}

UINT test::Read_Pixel_from_Mem(int posRow, int posCol, UINT dOffset)
{
	bool bWE, bCE;
	UINT dAddr;
	UINT IDMEM = 1;
	UINT AddressOut=0;
	
	UINT rdValue=0;

	// Initial Setting : bWE=1, bCE=1, dAddr=dOffset+posRow+posCol*DIBH.dWidth, 
	bWE = 1;						// Read Mode
	bCE = 1;						// Chip Disable
	dAddr = dOffset+(posCol+(posRow*DIBH.dWidth));	
	AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	AddressBus.write(AddressOut);
	// Read Operation
	wait(1);	AddressBus.write(BITOFF(AddressOut, IDX_MEM_bCE));	//bCE = 0;
	wait(1);	rdValue=DataBus.read().to_uint();
	wait(1);	AddressBus.write(BITON(AddressOut, IDX_MEM_bCE));	//bCE = 1;

#if defined (_DEBUG_)
cout << "[" << posRow << "][" << posCol << "]";
cout << "@" << sc_time_stamp() << ":: > Read: 0d" << memY[posRow][posCol] << endl;
#endif
	return rdValue;
}

void test::GetMemoryData(short dReg, UINT dOffset)
{
	// **(Memory+dOffset) -> **X or **Y
	UINT i,j;
	for(i=0; i<DIBH.dHeight; i++){
		for(j=0; j<DIBH.dWidth; j++){
			if(dReg==0) 	memX[i][j]=Read_Pixel_from_Mem(i,j,dOffset);
			else		memY[i][j]=Read_Pixel_from_Mem(i,j,dOffset);
		}
	}	
	wait(1);
	ReleaseBus();
}

void test::SendUART(UINT dData)
{
	ReleaseBus();
	AddressBus.write(0x20000000);

	// Write to UART : UART
	wait(4);
	DataBus.write(dData);		AddressBus.write(0x20000001);
	wait(4);
        DataBus.write("ZZZZZZZZ");   	AddressBus.write(0x20000002);
	wait(4);
					AddressBus.write(0x20000004);
	wait(10);
}

void test::do_test(){
	wait();

	while(true){
		// Initialize
		bReset = 0;
		wait(2);
		bReset = 1;
		wait(2);
		ReleaseBus();	

		WriteBMPOut(BMP_INPUT);			// Input Image
	
		// Input Image **X -> Memory[1st Area]
		UINT i,j;
		for(i=0; i<DIBH.dHeight; i++){
			for(j=0; j<DIBH.dWidth; j++){
				Send_Pixel_to_Mem(i,j,memX[i][j], 0/*IMAGE_ORIGIN*/);
			}
		}
		wait(1);
		ReleaseBus();

		// Memory[1st Area] -> **Y
		GetMemoryData(1, 0);			// BMP_ORIGIN
		WriteBMPOut(BMP_ORIGIN);		// Original Image

		SendUART(0x4E);

		// Noise Reduction
		dWriteReg = WRITE_REGX;
		dReadReg = REG_GAUSSIAN;
		OPMode = MODE_GAUSSIAN;
		int k,l;
		for(k=0; k<(UINT)DIBH.dHeight; k++){
			for(l=0; l<(UINT)DIBH.dWidth; l++){
				Do_5x5_Gaussian(k,l);
			}
		}
		wait(1);
		ReleaseBus();
	
		// Memory[2nd Area] -> **Y
		GetMemoryData(1, DIBH.dHeight*DIBH.dWidth);	// BMP_GAUSSIAN
		WriteBMPOut(BMP_GAUSSIAN);			// Image Gaussian applied

		SendUART(0x47);

		// Gradient & Direction
		dWriteReg = WRITE_REGX;
		OPMode = MODE_SOBEL;
		for(k=0; k<DIBH.dHeight; k++){
			for(l=0; l<DIBH.dWidth; l++){
				Do_3x3_Sobel(k,l);
			}
		}
		wait(1);
		ReleaseBus();

		// Memory[3rd Area] -> **X
		GetMemoryData(0, DIBH.dHeight*DIBH.dWidth*2);	// BMP_GRADIENT
		WriteBMPOut(BMP_GRADIENT);			// Gradient Image
		// Memory[4th Area] -> **Y
		GetMemoryData(1, DIBH.dHeight*DIBH.dWidth*3);	// BMP_DIRECTION
		WriteBMPOut(BMP_DIRECTION);			// Angle Image
		
		SendUART(0x53);

		// Non-Maximum Compression
		OPMode = MODE_NMS;
		for(k=0; k<DIBH.dHeight; k++){
			for(l=0; l<DIBH.dWidth; l++){
				Do_3x3_NMS(k,l);
			}
		}
		wait(1);
		ReleaseBus();

		// Memory[3rd Area] -> **Y
		GetMemoryData(1, DIBH.dHeight*DIBH.dWidth*2);	// BMP_NMS
		WriteBMPOut(BMP_NMS);
		
		SendUART(0x48);

		// Hysteresiis Thresholding
		OPMode = MODE_HYSTERESIS;
		for(k=0; k<DIBH.dHeight; k++){
			for(l=0; l<DIBH.dWidth; l++){
				Do_3x3_Hysteresis(k,l);
			}
		}
		wait(1);
		ReleaseBus();

		// Memory[5th Area] -> **Y
		GetMemoryData(1, DIBH.dHeight*DIBH.dWidth*4);	// BMP_HYSTERESIS
		WriteBMPOut(BMP_HYSTERESIS);

		free(memY);
		free(memX);
	
		short t=0;
		for(t=0; t<6; t++){
			LoadRefFiles(t);
			CompareData(t);
			free(refmemA);
			free(refmemB);
		}
 
                sc_stop();
        }
}
