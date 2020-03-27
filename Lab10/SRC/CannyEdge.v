`timescale 1ns/10ps

`define MODE_GAUSSIAN	0
`define MODE_SOBEL	1
`define MODE_NMS	2
`define MODE_HYSTERESIS	3

`define DATA_WIDTH	8
`define REG_ROW		5
`define REG_COL		5

`define REG_GAUSSIAN	0
`define REG_GRADIENT	1
`define REG_DIRECTION	2
`define REG_NMS		3
`define REG_HYSTERESIS	4

`define WRITE_REGX	0
`define WRITE_REGY	1
`define WRITE_REGZ	2

`define DATA_WIDTH 8

module CannyEdge(dAddrRegRow, dAddrRegCol, bWE, bCE, InData, OutData,
	OPMode, bOPEnable, dReadReg, dWriteReg,	clk, rst_b);

input 	[2:0]			dAddrRegRow, dAddrRegCol;
input				bWE, bCE;
input 	[`DATA_WIDTH-1:0] 	InData;
output 	[`DATA_WIDTH-1:0] 	OutData;
reg     [`DATA_WIDTH-1:0] 	OutData;

input 	[2:0]			OPMode;
input 				bOPEnable;
input 	[3:0]			dReadReg, dWriteReg;

input				clk, rst_b;

reg 	[`DATA_WIDTH-1:0]	regX[0:24];	// Index = Row*5+Col // Index <= [5][5]
reg 	[`DATA_WIDTH-1:0]	regY[0:24];	// Index = Row*5+Col // Index <= [5][5]
reg 	[`DATA_WIDTH-1:0]	regZ[0:24];	// Index = Row*5+Col // Index <= [5][5]
reg 	[`DATA_WIDTH-1:0]	gf[0:24];	// 5x5 Gaussian Filter

// reg signed type can be used here to avoid warning while synthesis, also option +v2k should be used for simulation.

reg 	[`DATA_WIDTH-1:0]	Out_gf, Out_gradient, Out_direction, Out_bThres;

parameter 			dThresHigh = 15;
parameter			dThresLow = 10;

// Internal Signal;
reg 		[31:0]		tpSum;
reg		[1:0]		IntSignal;
reg signed 	[31:0] 		Gx, Gy, fGx, fGy;
reg signed	[1:0]		dx, dy;

integer signed i, j;
integer index1, index2;

always @(clk or rst_b)
begin
	if(!rst_b)
	begin
    		//$display("Initialize: Gauss Mask/Sobel Operators.\n");
		// Initialize Gaussian Mask 
	/*	
		// Filter A. Matlab : fspecial('gaussian', 5, 1.4)*159
		gf[0] =2;  gf[1] =4;  gf[2]=5;   gf[3]=4;   gf[4]=2;
		gf[5] =4;  gf[6] =9;  gf[7]=12;  gf[8]=9;   gf[9]=4;
		gf[10]=5;  gf[11]=12; gf[12]=15; gf[13]=12; gf[14]=5;
		gf[15]=4;  gf[16]=9;  gf[17]=12; gf[18]=9;  gf[19]=4;
		gf[20]=2;  gf[21]=4;  gf[22]=5;  gf[23]=4;  gf[24]=2;
	*/	
		// Filter B. Matlab : Approximation of fspecial('gaussian', 5, 1.4)*128
		gf[0] =1;  gf[1] =3;  gf[2]=4;   gf[3]=3;   gf[4]=1;
		gf[5] =3;  gf[6] =7;  gf[7]=10;  gf[8]=7;   gf[9]=3;
		gf[10]=4;  gf[11]=10; gf[12]=16; gf[13]=10; gf[14]=4;
		gf[15]=3;  gf[16]=7;  gf[17]=10; gf[18]=7;  gf[19]=3;
		gf[20]=1;  gf[21]=3;  gf[22]=4;  gf[23]=3;  gf[24]=1;
	end
end

// Apply operations for Edge Detection
always @(posedge clk or negedge rst_b)
begin
	if(!rst_b) begin
            IntSignal <= 2'b00;
            tpSum <= 0;
            Gx <= 0;
            Gy <= 0;
            fGx <= 0;
            fGy <= 0;
            dx <= 0;
            dy <= 0;
            Out_gf <= 0;
            Out_gradient <= 0;
            Out_direction <= 0;
            Out_bThres <= 0;
            i <= 0;
            j <= 0;
            index1 <= 0;
            index2 <= 0;
	end

	// Load data from Test Bench
	else if(bCE==1'b0 && bWE==1'b0) 
	begin
		if(dWriteReg == `WRITE_REGX)
			regX[dAddrRegRow*5+dAddrRegCol] <= InData;
		else if(dWriteReg == `WRITE_REGY)
			regY[dAddrRegRow*5+dAddrRegCol] <= InData;
		else
			regZ[dAddrRegRow*5+dAddrRegCol] <= InData;

		$display("Load Data from InData to Reg => Mode:%d\n",dWriteReg);	
	end

	// Read Data from Canny Edge Detector
	else if(bCE==1'b0 && bWE==1'b1)
	begin
		if(dReadReg == `REG_GAUSSIAN)
			OutData <= Out_gf;
		else if(dReadReg == `REG_GRADIENT)
			OutData <= Out_gradient;
		else if(dReadReg == `REG_DIRECTION)
			OutData <= Out_direction;
		else if(dReadReg == `REG_NMS)
			OutData <= regX[dAddrRegRow*5+dAddrRegCol];
		else if(dReadReg == `REG_HYSTERESIS)
			OutData <= Out_bThres;

		$display("Read Data from Register or Array to OutData => Mode:%d\n", dReadReg);
	end

	else
	begin
	if(bOPEnable==1'b0)
	begin
		if(OPMode == `MODE_GAUSSIAN)
		begin
			if(IntSignal == 2'b00)	begin
                            //tpSum <= (5x5 Guassian Filter) convolution (5x5 Pixels);
                            for(i = 0; i < 5; i = i + 1) begin
                                for(j = 0; j < 5; j = j + 1) begin
                                    // TODO I think this is right
                                    tpSum = tpSum + (regX[i*5+j] * gf[i*5+j]);
                                end
                            end
                            IntSignal <= 2'b01;
			end
			else if(IntSignal == 2'b01) begin
                            // tpSum/128
                            Out_gf <= (tpSum >> 7); // tpSum / 128
                            IntSignal <= 2'b00;
                            i <= 0;
                            j <= 0;
			end
			else begin
				Out_gf <= Out_gf;
				IntSignal <= IntSignal;
			end
		end
		else if(OPMode == `MODE_SOBEL)
		begin
			// Gradient
			if(IntSignal == 2'b00)	begin
                            // Calculate Gradient for X and Y
                            for(i = 0; i < 5; i = i + 1) begin
                                for(j = 0; j < 5; j = j + 1) begin
                                    // TODO I think this is right
                                    Gx = Gx + (regX[i*5+j] * gf[i*5+j]);
                                    Gy = Gy + (regX[i*5+j] * gf[i*5+j]);
                                end
                            end
                            IntSignal <= 2'b01;
			end
			else if(IntSignal == 2'b01) begin
                            i <= 0;
                            j <= 0;
                            //|G| = (|Gx|+|Gy|)/8
                            // Check the top bit of both Gx and Gy
                            if(Gx[31] == 1'b1)
                                fGx = -Gx;
                            else
                                fGx = Gx;
                            if(Gy[31] == 1'b1)
                                fGy = -Gy;
                            else
                                fGy = Gy;
                            // Add them and shift right 3 (divide by 8)
                            Out_gradient <= ((fGx + fGy) >> 3);
                            IntSignal <= 2'b10;
			end	
			else if(IntSignal == 2'b10) begin
                            // Direction (Theta)
                            if(Gy < 0)
                            begin
                                fGx <= -Gx;
                                fGy <= -Gy;
                            end
                            else
                            begin
                                fGx <= Gx;
                                fGy <= Gy;
                            end
                            IntSignal <= 2'b11;
			end
			else if(IntSignal == 2'b11) begin
                            // Edge Normal which is perpendicular to Edge Orientation
                            if(fGx >=0)
                            begin
                                if((0.5 * fGx) <= fGy)
                                    // degree 0
                                regY[6] <= 0;
                                else if(fGy <= (2.5 * fGx))
                                    // degree 45
                                regY[6] <= 45;
                                else
                                    // degree 90
                                regY[6] <= 90;
                            end
                            else // if(fGx<0)
                            begin
                                if((-0.5 * fGx) <= fGy)
                                    // degree 0
                                regY[6] <= 0;
                                else if(fGy <= (-2.5 * fGx))
                                    // degree 135
                                regY[6] <= 135;
                                else
                                    // degree 90
                                regY[6] <= 90;
                            end
                            IntSignal <= 2'b00;
			end
		end
		else if(OPMode == `MODE_NMS)
		begin
			// regX = Gradient Image
			// regY = Theta Image
			if(IntSignal == 2'b00) begin
                            // Direction is stored in regY[6], determining dx and dy

                            // Edge Normal : 0
                            // Edge Normal : 45
                            // Edge Normal : 90
                            // Edge Normal : 135
                            if(regY[6] == 0) begin
                                index1 <= 5;
                                index2 <= 7;
                            end
                            else if(regY[6] == 45) begin
                                index1 <= 12;
                                index2 <= 0;
                            end
                            else if(regY[6] == 90) begin
                                index1 <= 11;
                                index2 <= 1;
                            end
                            else begin
                                index1 <= 2;
                                index2 <= 10;
                            end
                            IntSignal <= 2'b01;
			end
			else if(IntSignal == 2'b01) begin
                            // Non-maximum suppression
                            // check two pixels against pixel A (regX[6])
                            if((regX[6] >= regX[index1]) && (regX[6] >= regX[index2])) begin
                                regX[index1] <= 0;
                                regX[index2] <= 0;
                            end
                            else begin
                                regX[6] <= 0;
                            end
				IntSignal <= 2'b00;
			end
		end
		else if(OPMode == `MODE_HYSTERESIS)
		begin
			// regX = Gradient Image
			// regY = Theta Image
			// regZ = bGxy Image (On/Off)
			if(IntSignal == 2'b00) begin

                            // Edge Normal:0 -> Direction:90
                            // Edge Normal:45 -> Direction : 135
                            // Edge Normal:90 -> Direction : 0
                            // Edge Normal:135 -> Direction : 45
                                //if(regY[6] == 0)
                                //else if(regY[6] == 45)
                                //else if(regY[6] == 45)
                                //else
				
				IntSignal <= 2'b01;
			end	
			else if(IntSignal == 2'b01) begin
                            if(regX[6] >= dThresHigh)		// Keep Edge Info
                                Out_bThres <= 1;
                            else if(regX[6] <= dThresLow)		// Discard Pixel
                                Out_bThres <= 0;
                            else					// Follow Edge Trace
                            begin
                                if(regX[6-5*dy-dx] >= dThresHigh || regX[6+5*dy+dx] >= dThresHigh)
                                    Out_bThres <= 1;
                                else
                                    Out_bThres <= 0;
                            end

                            IntSignal <= IntSignal;
			end
		end
	end	
	else
		IntSignal <= 2'b00;

	end // of 'else' of '!rst_b'
end

endmodule

