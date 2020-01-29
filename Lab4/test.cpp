#include "test.h"

#define TRUE 	1
#define FALSE	0

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
	else if(dMode == 0){
		cout << " >> OUT: ORIGIN >>" << endl;	fp = fopen("0.OutputOrigin.bmp", "wb");
	}
	else if(dMode == 1){
		cout << " >> OUT: GAUSSIAN >>" << endl;	fp = fopen("1.OutputGauss.bmp", "wb");
	}
	else if(dMode == 2){
		cout << " >> OUT: GRADIENT >>" << endl;	fp = fopen("2.OutputGradient.bmp", "wb");
	}
	else if(dMode == 3){
		cout << " >> OUT: ANGLE >>" << endl;	fp = fopen("3.OutputAngle.bmp", "wb");
	}
	else if(dMode == 4){
		cout << " >> OUT: NMS >>" << endl;	fp = fopen("4.OutputNMS.bmp", "wb");
	}
	else if(dMode == 5){
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

	float compsum = 0;

	for(j=0; j < DIBH.dHeight; j++){
		for(k=0; k < DIBH.dWidth; k++){
			reverse = DIBH.dHeight-j-1;
			if(dMode == 1)		dValue=memXG[reverse][k];
			else if(dMode == 2)	dValue=Gxy[reverse][k];
			else if(dMode == 3)	dValue=Theta[reverse][k];
			else if(dMode == 4)	dValue=Gxy[reverse][k];
			else if(dMode == 5)	dValue=bGxy[reverse][k];
			else			dValue=memX[reverse][k];

			if(dMode == 5){
				if(dValue!=0){
					fprintf(fp,"%c",255);
					fprintf(fp,"%c",255);
					fprintf(fp,"%c",255);
				}
				else {
					fprintf(fp, "%c", 0);
					fprintf(fp, "%c", 0);
					fprintf(fp, "%c", 0);
				}
			}
			else if(dMode != 3){
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

		if(dDummyData != 0){	
			fprintf(fp,"%c%c",0x00,0x00);
		}
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

	memX = (short**) malloc (sizeof(short*)*DIBH.dHeight);

	UINT i;
	for(i=0; i<DIBH.dHeight; i++){
		memX[i] = (short*) malloc (sizeof(short)*DIBH.dWidth);
	}
	
	memXG = (short**) malloc (sizeof(short*)*DIBH.dHeight);
	for(i=0; i<DIBH.dHeight; i++){
		memXG[i] = (short*) malloc (sizeof(short)*DIBH.dWidth);
	}
	
	Gxy = (short**) malloc (sizeof(short*)*DIBH.dHeight);
	for(i=0; i<DIBH.dHeight; i++){
		Gxy[i] = (short*) malloc (sizeof(short)*DIBH.dWidth);
	}
		
	Theta = (short**) malloc (sizeof(short*)*DIBH.dHeight);
	for(i=0; i<DIBH.dHeight; i++){
		Theta[i] = (short*) malloc (sizeof(short)*DIBH.dWidth);
	}
	
	bGxy = (short**) malloc (sizeof(short*)*DIBH.dHeight);
	for(i=0; i<DIBH.dHeight; i++){
		bGxy[i] = (short*) malloc (sizeof(short)*DIBH.dWidth);
	}
	
	UINT k;
	// Initialization
	for(i=0; i<DIBH.dHeight; i++){
		for(k=0; k < DIBH.dWidth; k++){
			Gxy[i][k]=0;
			Theta[i][k]=0;
			bGxy[i][k]=0;
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
			memXG[reverse][k]=dValue;
		}
	}

	cout << " > Create memX[][] Array" << endl;
	cout << " > Create memXG[][] Array" << endl;
	cout << " > Create Gxy[][] Array" << endl;
	cout << " > Create Theta[][] Array" << endl;
	cout << " > Create bGxy[][] Array" << endl;
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
	sum = sum / (DIBH.dHeight*DIBH.dWidth*3);
	sum = (float)100 - sum;

	cout << " > " << dmode << "th Matching Ratio : " << sum << "percent" << endl;
}

void test::LoadBMPFile(){
	FILE *fp;
	//fp = fopen("kodim06_200.bmp", "rb");
	fp = fopen("cman_200.bmp", "rb");
	//fp = fopen("cman_190.bmp", "rb");
	dDummyData=0;
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

void test::send_3x3(UINT posRow, UINT posCol)
{
	// Initial Setting
	bWE = 0;		// Write to Memory
	bCE = 1;		// Chip Disable
	wait(1);
	short i,j;		// i:row, j:column
	for(i=-1; i<=1; i++){
		for(j=-1; j<=1; j++){
			bCE = 1;
			AddrRegRow = i+1;
			AddrRegCol = j+1;
			if(posRow+i<0 || posCol+j<0 || posRow+i>=DIBH.dHeight || posCol+j>=DIBH.dWidth){
				InData = 0;
			}
			else {
				if(OPMode.read() == MODE_SOBEL){
					InData = memXG[posRow+i][posCol+j];
				}
				else if(OPMode.read() == MODE_NMS){
					if(dWriteReg.read() == WRITE_REGX)
						InData = Gxy[posRow+i][posCol+j];
					else
						InData = Theta[posRow+i][posCol+j];
				}
				else if(OPMode.read() == MODE_HYSTERESIS){
					if(dWriteReg.read() == WRITE_REGX)
						InData = Gxy[posRow+i][posCol+j];
					else if(dWriteReg.read() == WRITE_REGY)
						InData = Theta[posRow+i][posCol+j];
					else
						InData = bGxy[posRow+i][posCol+j];
				}
			}

			wait(1);	bCE = 0;
			wait(1);	bCE = 1;
			wait(1);
#if defined (_DEBUG_)
                  cout << "@" << sc_time_stamp() << ":: > Send: 0d" << InData << endl;
#endif
		}
	}
}

void test::send_5x5(UINT posRow, UINT posCol)
{
	// Initial Setting
	bWE = 0;		// Write to Memory
	bCE = 1;		// Chip Disable

	short i,j;		// i:row, j:column
	for(i=-2; i<=2; i++){
		for(j=-2; j<=2; j++){
			bCE = 1;
			AddrRegRow = i+2;
			AddrRegCol = j+2;
			InData = memX[posRow+i][posCol+j];

			wait(1);	bCE = 0;
			wait(1);	bCE = 1;
			wait(1);
#if defined (_DEBUG_)
                  cout << "@" << sc_time_stamp() << ":: > Send: 0d" << InData << endl;
#endif
		}
	}
}

void test::read_3x3(UINT posRow, UINT posCol)
{
	bWE = 1;	// Read from Memory
	bCE = 1;

	short i,j;		// i:row, j:column
	for(i=-1; i<=1; i++){
		for(j=-1; j<=1; j++){
			AddrRegRow = i+1;
			AddrRegCol = j+1;
			wait(1);	bCE = 0;
			wait(1);
			if(posRow+i<0 || posRow+i>=DIBH.dHeight || posCol+j<0 || posCol+j>=DIBH.dWidth){
				;
			}
			else {
				//if(dReadReg.read() == REG_NMS)	
				Gxy[posRow+i][posCol+j] = OutData.read();
			}
			wait(1);	bCE = 1;
			wait(1);
		}
	}
}

void test::read_pixel(UINT posRow, UINT posCol)
{
	// Output
	bWE = 1;	// Read from Memory
	bCE = 1;
	wait(1);	bCE = 0;
	wait(1);
	AddrRegRow=1;
	AddrRegCol=1;	
	if(dReadReg.read() == REG_GAUSSIAN)		memXG[posRow][posCol] = OutData.read();
	else if(dReadReg.read() == REG_GRADIENT)	Gxy[posRow][posCol] = OutData.read();
	else if(dReadReg.read() == REG_DIRECTION)	Theta[posRow][posCol] = OutData.read();
	//else if(dReadReg.read() == REG_NMS)		memXG[posRow][posCol] = OutData.read();
	else if(dReadReg.read() == REG_HYSTERESIS)	{
		bGxy[posRow][posCol] = OutData.read();
	}
	wait(1);	bCE = 1;
	wait(1);
#if defined (_DEBUG_)
        cout << "@" << sc_time_stamp() << ":: > Received: 0d" << OutData << endl;
#endif
}

void test::do_test(){
	wait();

	while(true){
		// Initialize
		rst_b = 0;
		wait(2);
		rst_b = 1;
		wait(2);

		WriteBMPOut(0);		// Original Image

		// Noise Reduction
		UINT i,j;
		dReadReg = REG_GAUSSIAN;
		OPMode = MODE_GAUSSIAN;
		bOPEnable = 0;
		for(i=2; i<DIBH.dHeight-2; i++){
			for(j=2; j<DIBH.dWidth-2; j++){
				send_5x5(i, j);
				wait(1);	bOPEnable = 0;	
				wait(4);	bOPEnable = 1;
				read_pixel(i, j);
			}
		}
		WriteBMPOut(1);		// Image Gaussian applied

		// Gradient & Direction
		OPMode = MODE_SOBEL;
		bOPEnable = 0;
		for(i=1; i<DIBH.dHeight-1; i++){
			for(j=1; j<DIBH.dWidth-1; j++){
				send_3x3(i,j);
				wait(1);	bOPEnable = 0;	
				wait(10);	bOPEnable = 1;
				dReadReg = REG_GRADIENT;	
				read_pixel(i,j);
				dReadReg = REG_DIRECTION;
				read_pixel(i,j);
			}
		}
		WriteBMPOut(2);		// Gradient Image
		WriteBMPOut(3);		// Angle Image

		// Non-Maximum Compression
		OPMode = MODE_NMS;
		bOPEnable = 0;
		for(i=0; i<DIBH.dHeight; i++){
			for(j=0; j<DIBH.dWidth; j++){
				dWriteReg = WRITE_REGX;
				send_3x3(i,j);
				dWriteReg = WRITE_REGY;
				send_3x3(i,j);
				wait(1);	bOPEnable = 0;
				wait(10);	bOPEnable = 1;
				dReadReg = REG_NMS;
				read_3x3(i,j);
			}
		}
		WriteBMPOut(4);

		// Hysteresiis Thresholding
		OPMode = MODE_HYSTERESIS;
		bOPEnable = 0;
		for(i=0; i<DIBH.dHeight; i++){
			for(j=0; j<DIBH.dWidth; j++){
				dWriteReg = WRITE_REGX;
				send_3x3(i,j);
				dWriteReg = WRITE_REGY;
				send_3x3(i,j);
				dWriteReg = WRITE_REGZ;
				send_3x3(i,j);
				wait(1);	bOPEnable = 0;
				wait(10);	bOPEnable = 1;
				dReadReg = REG_HYSTERESIS;
				read_pixel(i,j);
			}
		}
		WriteBMPOut(5);
		
		free(bGxy);
		free(Theta);
		free(Gxy);
		free(memXG);
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
