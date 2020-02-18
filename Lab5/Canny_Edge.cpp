//===========================================
// Function : Canny Edge Detector
//===========================================
#include "Canny_Edge.h"

  // ----- Code Starts Here ----- 

void Canny_Edge::Write_Data() {
	if (!bCE.read() && !bWE.read()) {
		if(dWriteReg.read() == WRITE_REGX)
			regX[AddrRegRow.read()][AddrRegCol.read()] = InData.read();
                else if (dWriteReg.read() == WRITE_REGY)
                        regY[AddrRegRow.read()][AddrRegCol.read()] = InData.read();
                else
                        regZ[AddrRegRow.read()][AddrRegCol.read()] = InData.read();		
		// For debug	
		#if defined (_DEBUG_)
		cout << "@" << sc_time_stamp() << ":: Write: " << InData.read() << endl;
		#endif
	}
}

void Canny_Edge::Read_Data() {
	if (!bCE.read() && bWE.read()) {
		unsigned int dData;
		if(dReadReg.read() ==  REG_GAUSSIAN) 		dData = Out_gf;
                else if(dReadReg.read() == REG_GRADIENT)        dData = Out_gradient;
                else if(dReadReg.read() == REG_DIRECTION)       dData = Out_direction;
                // TODO fix this case
                else if(dReadReg.read() == REG_NMS)             dData = regX[AddrRegRow.read()][AddrRegCol.read()];
                else if(dReadReg.read() == REG_HYSTERESIS)      dData = Out_bThres;
		
                OutData.write(dData);
		
		// For debug	
		#if defined (_DEBUG_)
		cout << "@" << sc_time_stamp() << ":: Read[" << AddrRegRow.read() << "]";
		cout << "[" << AddrRegCol.read() << "]: " << dData << endl;
		#endif
	}
}

void Canny_Edge::Initialize() {
	if(!rst_b.read()){
		// Initialize 5x5 matrix
		short tRow, tCol;
		for(tRow=0; tRow<5; tRow++){
			for(tCol=0; tCol<5; tCol++){
				regX[tRow][tCol] = 0;
			}
		}
		// Initialize Gaussian matrix
		gf[0][0]=2;	gf[0][1]=4;	gf[0][2]=5;	gf[0][3]=4;	gf[0][4]=2;
		gf[1][0]=4;	gf[1][1]=9;	gf[1][2]=12;	gf[1][3]=9;	gf[1][4]=4;
		gf[2][0]=5;	gf[2][1]=12;	gf[2][2]=15;	gf[2][3]=12;	gf[2][4]=5;
		gf[3][0]=4;	gf[3][1]=9;	gf[3][2]=12;	gf[3][3]=9;	gf[3][4]=4;
		gf[4][0]=2;	gf[4][1]=4;	gf[4][2]=5;	gf[4][3]=4;	gf[4][4]=2;

		// Sobel dx
		Sobeldx[0][0]=-1;	Sobeldx[0][1]=0;	Sobeldx[0][2]=1;	
		Sobeldx[1][0]=-2;	Sobeldx[1][1]=0;	Sobeldx[1][2]=2;
		Sobeldx[2][0]=-1;	Sobeldx[2][1]=0;	Sobeldx[2][2]=1;
		// Sobel dy
		Sobeldy[0][0]=1;	Sobeldy[0][1]=2;	Sobeldy[0][2]=1;	
		Sobeldy[1][0]=0;	Sobeldy[1][1]=0;	Sobeldy[1][2]=0;
		Sobeldy[2][0]=-1;	Sobeldy[2][1]=-2;	Sobeldy[2][2]=-1;
	}
}

void Canny_Edge::Apply_Operation(){
	if(!bOPEnable.read()){
		if (OPMode.read() == MODE_GAUSSIAN){
			int c,d;	
			float sum = 0;
			// CONVOLUTION
                        for(c=-2; c<=2; c++){
                            for(d=-2; d<=2; d++){
                                sum = sum + (float) regX[c+2][d+2] * gf[c+2][d+2];
                            }
                        }
                        Out_gf = char(sum/159);
	    	}
		else if(OPMode.read() == MODE_SOBEL){
			int c,d;
			short Gx=0;		// X direction Component
			short Gy=0;		// Y direction Component
                        int alpha = 2;
	
			// 1. input : Sobeldx, Sobeldy, regX(Gaussian Filtered Image)
			// 2. Output : Out_gradient(0~255), Out_direction(0, 45, 90, 135)
			for(c=-1; c<=1; c++){
				for(d=-1; d<=1; d++){
                                  Gx = Gx + (regX[c + 1][d + 1] * Sobeldx[c + 1][d+1]);
                                  Gy = Gy + (regX[c + 1][d + 1] * Sobeldy[c + 1][d+1]);
				}
                        }
                        // Calculate out_gradient
                        Out_gradient = abs((abs(Gx) + abs(Gy)) / alpha);
                        // Calculate theta
                        if(Gy < 0) {
                            Gx = Gx * -1;
                            Gy = Gy * -1;
                        }
                        if(Gx >= 0){
                            if(Gy <= (0.4 * Gx)){
                                Out_direction = 0;
                            } 
                            else if(Gy <= (2.4 * Gx)){
                                Out_direction = 45;
                            }
                            else {
                                Out_direction = 90;
                            }
                        }
                        else {
                            if(Gy <= (-0.4 * Gx)){
                                Out_direction = 0;
                            } 
                            else if(Gy <= (-2.4 * Gx)){
                                Out_direction = 135;
                            }
                            else {
                                Out_direction = 90;
                            }
                        }
		}
		else if(OPMode.read() == MODE_NMS){
			// 1. input : regX(Gradient Image), regY(Direction Image)
			// 2. Output : regX(Gradient Image)
                      unsigned short pixelC_magnitude = regX[1][1];
                      unsigned short direction = regY[1][1];
                      unsigned short pixelA_magnitude = 0;
                      unsigned short pixelB_magnitude = 0;
                         if(direction == 0){
                           // direction is 0
                           // check left and right pixel
                           pixelA_magnitude = regX[1][0];
                           pixelB_magnitude = regX[1][2];
                           if((pixelC_magnitude >= pixelA_magnitude) && pixelC_magnitude >= pixelB_magnitude){
                             regX[1][0] = 0;
                             regX[1][2] = 0;
                           } else {
                             regX[1][1] = 0;
                           }
                         } else if (direction == 45){
                           // direction is 45
                           // check up 1, right 1 and down 1, left 1
                           pixelA_magnitude = regX[2][2];
                           pixelB_magnitude = regX[0][0];
                           if((pixelC_magnitude >= pixelA_magnitude) && pixelC_magnitude >= pixelB_magnitude){
                             regX[2][2] = 0;
                             regX[0][0] = 0;
                           } else {
                             regX[1][1] = 0;
                           }
                         }else if (direction == 90){
                           // direction is 90
                           // check above and below
                           pixelA_magnitude = regX[2][1];
                           pixelB_magnitude = regX[0][1];
                           if((pixelC_magnitude >= pixelA_magnitude) && pixelC_magnitude >= pixelB_magnitude){
                             regX[2][1] = 0;
                             regX[0][1] = 0;
                           } else {
                             regX[1][1] = 0;
                           }
                         }else {
                           // direction is 135
                           // check up 1, left 1 and down 1, right 1
                           pixelA_magnitude = regX[0][2];
                           pixelB_magnitude = regX[2][0];
                           if((pixelC_magnitude >= pixelA_magnitude) && pixelC_magnitude >= pixelB_magnitude){
                             regX[0][2] = 0;
                             regX[2][0] = 0;
                           } else {
                             regX[1][1] = 0;
                           }
                         }
		}
		else if(OPMode.read() == MODE_HYSTERESIS){
			// You should use these two threshold values.
			unsigned short dThresHigh = 35;
			unsigned short dThresLow = 1;
                        unsigned direction = regY[1][1];
                        Out_bThres = 0; // Default to off

			// 1. input : regX(Gradient Image), regY(Direction Image), regZ(On/Off Image)
			//            regZ[][]==1: On / regZ[][]==0: Off
			// 2. Output : Out_bThres (0(Off) or 1(On))
			// Insert Your Code here //
                        if(regX[1][1] >= dThresHigh){
                           // Strong pixel
                           Out_bThres = 1;
                           regZ[1][1] = 1;
                        }
                        else if(regX[1][1] <= dThresLow){
                           // Weak pixel
                           regZ[1][1] = 0;
                           Out_bThres = 0;
                        }
                        else {
                           // Candidate pixel
                           // Check to see if it's already drawn
                           if(regZ[1][1] != 1){
                             unsigned short pixelA = 0;
                             unsigned short pixelB = 0;
                             // Check pixels next to it
                             if(direction == 0){
                               // direction is 0
                               // check left and right pixel
                               pixelA = regZ[1][2];
                               pixelB = regZ[1][0];
                             } else if (direction == 45){
                               // direction is 45
                               // check up 1, right 1 and down 1, left 1
                               pixelA = regZ[2][2];
                               pixelB = regZ[0][0];
                             }else if (direction == 90){
                               // direction is 90
                               // check above and below
                               pixelA = regZ[2][1];
                               pixelB = regZ[0][1];
                           
                             }else {
                               // direction is 135
                               // check up 1, left 1 and down 1, right 1
                               pixelA = regZ[0][2];
                               pixelB = regZ[2][0];
                             }
                             if(pixelA == 1 || pixelB == 1){
                               Out_bThres = 1;
                               regZ[1][1] = 1;
                             }
                           } else {
                             // don't output the candidate
                             Out_bThres = 0;
                           }
                        }
		}
	}
}
