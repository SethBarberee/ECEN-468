`timescale 1ns/10ps
`include "systemtop.v"

`define MODE_GAUSSIAN		0
`define MODE_SOBEL		1
`define MODE_NMS		2
`define MODE_HYSTERESIS		3

`define DATA_WIDTH		8
`define REG_ROW			5
`define REG_COL			5

`define REG_GAUSSIAN		0
`define REG_GRADIENT		1
`define REG_DIRECTION		2
`define REG_NMS			3
`define REG_HYSTERESIS		4

`define WRITE_REGX		0
`define WRITE_REGY		1
`define WRITE_REGZ		2

`define EOF				32'hFFFF_FFFF
`define NULL			0
`define LEN_HEADER		54   // 0x36

`define	IDX_MEM_bCE		19
`define IDX_CANNY_bCE		0
`define IDX_CANNY_bOPEnable 	27

module stimulus;

	parameter 		AddrSize = 18;
	parameter 		WordSize = 8;

   	reg 			clk;
   	wire 			Serial_out;
   
   	reg 			Breq;
   	wire 			Bgnt;
  
	wire 	[7:0]		DataBus;
	wire 	[31:0]		AddrBus;
	wire       		ControlBus;

	reg 			bReset;
   	reg 	[7:0]		dRcvData;
   
   	systemtop systemtop_01(Serial_out, clk, Breq, Bgnt, DataBus, AddrBus, ControlBus, bReset);
	
	// FILE I/O
	integer 		fileI, fileO, c, r;
	reg	[7:0]		FILE_HEADER[0:`LEN_HEADER-1];
   	reg   	[31:0]		LHEADER;
	reg	[7:0]		memX[0:40000-1];	// 200x200
	reg	[7:0]		memY[0:40000-1];	// 200x200

   	reg   [7:0]   	memLine[0:600-1];
   	reg   [31:0]   	HeaderLine[0:12];
   	reg   [7:0]   	rG, rB, rR;
   
	parameter	dWidth = 200;
	parameter   	dHeight = 200;

	integer		i,j,k,l;
	integer		t;
   
   	reg 		bWE, bCE;
	reg 	[17:0]	dAddr;
	parameter 	IDMEM = 1;
	reg 	[31:0]	AddressOut;
	
	reg 	[2:0] 	OPMode;
	reg 	[3:0] 	dReadReg, dWriteReg;
	parameter 	IDCANNY = 4;
   	
	reg 		bOPEnable;
	reg 	[7:0] 	dBlock5x5[0:24];
	reg 	[7:0] 	dBlock3x3[0:9];
	reg 	[7:0] 	dBlockA3x3[0:9];
	reg 	[7:0] 	dBlockB3x3[0:9];
	reg 	[7:0] 	dBlockC3x3[0:9];
	reg 	[7:0] 	tValue;
	reg 	[7:0] 	tGradient, tDirection;
	
	initial
	begin
	    	// MEMORY INIT // ----------------------------------------------------
   		for(i=0; i<40000; i=i+1)
		begin
			memX[i] = 0;		
			memY[i] = 0;
		end

		// Input Image READ function // --------------------------------------
		//fileI = $fopen("cman_200.bmp","rb");
		fileI = $fopen("kodim20_200.bmp","rb");
		if (fileI == `NULL) 	$display("> FAIL: The file is not exist !!!\n");
		else	           	$display("> SUCCESS : The file was read successfully.\n");
	
      		r = $fread(FILE_HEADER, fileI, 0, `LEN_HEADER); 
      		$display("$fread read %0d bytes: \n", r); 
      
		for(i=0; i<dHeight; i=i+1)
		begin
			for(j=0; j<dWidth; j=j+1)
			begin	
				c = $fgetc(fileI);
				c = $fgetc(fileI);
				memX[(dHeight-i-1)*dWidth+j] = $fgetc(fileI);
			end
		end
		$display("> memX[] Array is created.");			
		$display("> memY[] Array is created.");			
		$display("\n");		
		$fclose(fileI);
		
		// WRITE function // ---------------------------------------------------
		fileO = $fopen("OutputInput.bmp","wb");
      		
		// BMP HEADER
		for(i=0; i<2; i=i+1)
		begin
			$fwrite(fileO, "%c", FILE_HEADER[i]);
			//$display("[%d]:%x",i, FILE_HEADER[i]);
		end
      
      		// BMP HEADER for 200x200 size of image
      		HeaderLine[0]=32'h00_01_d4_f8;
      		HeaderLine[1]=32'h00_00_00_00;
      		HeaderLine[2]=32'h00_00_00_36;
      		HeaderLine[3]=32'h00_00_00_28;
      		HeaderLine[4]=32'h00_00_00_c8;
      		HeaderLine[5]=32'h00_00_00_c8;
      		HeaderLine[6]=32'h00_18_00_01;
      		HeaderLine[7]=32'h00_00_00_00;
      		HeaderLine[8]=32'h00_00_00_00;
      		HeaderLine[9]=32'h00_00_0b_12;
      		HeaderLine[10]=32'h00_00_0b_12;
      		HeaderLine[11]=32'h00_00_00_00;
      		HeaderLine[12]=32'h00_00_00_00;
		
		for(i=0; i<13; i=i+1) begin
			$fwrite(fileO, "%u", HeaderLine[i]);	
		end

      		for(i=0; i<dHeight; i=i+1)
		begin
		   	for(j=0; j<dWidth; j=j+1)
			begin
			   	memLine[j*3+0]=memX[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+1]=memX[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+2]=memX[(dHeight-i-1)*dWidth+j];
			end
			for(j=0; j<150; j=j+1)   // dWidth*3/4
			begin
			   	$fwrite(fileO, "%u", {memLine[j*4+3],memLine[j*4+2],memLine[j*4+1],memLine[j*4+0]});		
		   	end
		end
		$display("> OutputInput.bmp is created.\n");
		$fclose(fileO);
	end	

   	// Initial Condition -------------------------------------------------------
   	initial
   	begin
	   	bReset = 1'b1;
		clk = 1'b0;
		Breq = 1'b0;
		force DataBus = 8'hzz;
		force AddrBus = 32'h0000_0000;
		
		#100   bReset = 1'b0;  
		#100   bReset = 1'b1;  
		release DataBus;
   	end

   	// Clock Generation ---------------------------------------------------------
   	always begin
          	#10 clk = !clk;
   	end

   	// MAIN Test Bench ----------------------------------------------------------
   	initial
   	begin
      		#200;
		// Release Bus
		force AddrBus = 32'h1000_0000;
		#100;
		
 		// -----------------------------------------------------------------------
		// Memory Reset
		// -----------------------------------------------------------------------
      		// Black(0) -> Memory[1st Area] ----------------
      		for(k=0; k<5; k=k+1) begin
			for(i=0; i<dHeight; i=i+1)   begin
				for(j=0; j<dWidth; j=j+1)   begin
	         			// Send_Pixel_to_Mem(i, j, data, dOffset) --------
	         			bWE = 0;	                // Write Mode
	         			bCE = 1;			// Chip Disable
	         			dAddr = k*dWidth*dHeight+(i*dWidth+j);	
	         			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	         			// WRITE TO MEMORY  
	         			force DataBus = 0;   force AddrBus = AddressOut; 
	         			// Write Operation
	         			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	         			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	         			#20;
	         			// -----------------------------------------------
				end
			end
		end
		// -----------------------------------------------------------------------
		// Original Image to Memory & Memory to test-bench
		// -----------------------------------------------------------------------
		
                // Input Image **X -> Memory[1st Area] ----------------
                // *****************************************
                // Insert your code here
                for(i=0; i<dHeight; i=i+1)   begin
                    for(j=0; j<dWidth; j=j+1)   begin
                            // Send_Pixel_to_Mem(i, j, data, dOffset) --------
                            bWE = 0;	                // Write Mode
                            bCE = 1;			// Chip Disable
                            //dAddr = dWidth*dHeight+(i*dWidth+j);	
                            dAddr = (i*dWidth+(j));	
                            AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
                            // WRITE TO MEMORY  
                            force DataBus = memX[i*dWidth+j];   force AddrBus = AddressOut; 
                            // Write Operation
                            #20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                            #20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                            #20;
                            // -----------------------------------------------
                    end
                end
		// *****************************************
		
		// Memory[1st Area] -> **Y -----------------------------
	  	// *****************************************
		// Insert your code here
	   	for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
		      		// Read_Pixel_from_Mem(i,j,dOffset);
	         		bWE = 1;		// Read Mode
           			bCE = 1;		// Chip Disable
                                //dAddr = dWidth*dHeight+(i*dWidth+j);	
                                dAddr = (i*dWidth+(j));	
	        		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	         		force AddrBus = AddressOut;
	         		// Read Operation
	         		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
            			#20 memY[i*dWidth+j] = DataBus;
            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
            			#20;
		   	end
	   	end
		// *****************************************
	
		// WriteBMPOut(BMP_ORIGIN);		// -----------------------------------------
		fileO = $fopen("0.OutputOrigin.bmp","wb");
      		// BMP HEADER MAGIC NUMBER
		for(i=0; i<2; i=i+1) $fwrite(fileO, "%c", FILE_HEADER[i]);
		for(i=0; i<13; i=i+1)	$fwrite(fileO, "%u", HeaderLine[i]);

      		// Data
      		for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
				memLine[j*3+0]=memY[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+1]=memY[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+2]=memY[(dHeight-i-1)*dWidth+j];
			end
			for(j=0; j<150; j=j+1)      // dWidth*3/4
			   	$fwrite(fileO, "%u", {memLine[j*4+3],memLine[j*4+2],memLine[j*4+1],memLine[j*4+0]});		
		end
		$fclose(fileO);
		$display("> 0.OutputOrigin.bmp is created.\n");
		
      		// SendUART(0x4E)---------------------------------------------------------
 	  	// *****************************************
		// Insert your code here
		// ...
                #60 force AddrBus = 32'h20000000; // Load_XMT_datareg  = 1
                force DataBus = 8'h4E;
                #60 force AddrBus = 32'h20000001; // Load_XMT_datareg  = 1
                #60 release DataBus; force AddrBus = 32'h20000002; // Byte_ready = 1
                #60 force AddrBus = 32'h20000004; // T_byte = 1;
		// ***************************************** 
		// -----------------------------------------------------------------------
		// Applying Gaussian Filter
      		// Memory[1st Area] : Original Image
		// Memory[2nd Area] : Gaussian Image
		// -----------------------------------------------------------------------

		// NOISE REDUCTION ------------------------------------------------------
		dWriteReg = `WRITE_REGX;
		dReadReg = `REG_GAUSSIAN;
		OPMode = `MODE_GAUSSIAN;

		for(i=0; i<dHeight; i=i+1)   begin
			for(j=0; j<dWidth; j=j+1)   begin
				// Do_5x5_Gaussian(i,j);
	         		if(i<2 || j<2 || i>=dHeight-2 || j>=dWidth-2)   begin
		         		// Non Gaussian Smoothing
	            			// Send_Pixel_to_Mem(i, j, data, dOffset) -------
	            			bWE = 0;	                     // Write Mode
	            			bCE = 1;	                     // Chip Disable
	            			dAddr = dHeight*dWidth*1+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = memX[i*dWidth+j];   force AddrBus = AddressOut; 
	            			// Write Operation
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;
	            			// -----------------------------------------
	         		end
	         		else begin
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
               
		         		// Read 5x5 block from Memory
		         		for(k=0; k<5; k=k+1)   begin
			         		for(l=0; l<5; l=l+1)   begin
				         		//dBlock5x5[k*5+l]=Read_Pixel_from_Mem(i+(k-2),j+(l-2),0);	//IMAGE_ORIGIN
		               				// Read_Pixel_from_Mem(i,j,dOffset); -------
	                  				bWE = 1;		// Read Mode
                     					bCE = 1;		// Chip Disable
	                  				dAddr = 0+((i+(k-2))*dWidth+(j+(l-2)));	
	                  				AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	                  				force AddrBus = AddressOut;
	                  
							// Read Operation
	                  				#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                     					#20 dBlock5x5[k*5+l] = DataBus;
                     					#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                     					#20;
                     					// -----------------------------------------
			         		end
		         		end
		         		#20
		         		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		         		#20 release DataBus;      		   release AddrBus;

		         		//Init_to_Canny();
	            			bWE = 0;   bCE = 1;   bOPEnable = 1;
	            			AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
               				release DataBus;      force AddrBus = AddressOut; #60;
	
		         		bWE = 0;
		         		bCE = 1;
		         		bOPEnable = 1;
		         		
					// Send 5x5 block to Canny
		         		for(k=0; k<5; k=k+1)   begin
			         		for(l=0; l<5; l=l+1)   begin
				         		force DataBus = dBlock5x5[k*5+l];
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end
		         
					// Operation Enable
		         		#20	force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bOPEnable);   //bOPEnable = 0;
		         		#80	force AddrBus = AddressOut | (1<<`IDX_CANNY_bOPEnable);    //bOPEnable = 1;
		
		         		// Read pixel from Canny 
		         		k = 2; 	l = 2;	
		         		bWE = 1;	bCE = 1;
		         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
		         		release DataBus;      force AddrBus = AddressOut; #60;
		         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
		         		#80 tValue = DataBus;
		         		#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
		         		#20;
	
		         		// Send pixel to Memory	
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
	            			
					// Send_Pixel_to_Mem(i, j, data, dOffset) ---------
	            			bWE = 0;	                     // Write Mode
	            			bCE = 1;		             // Chip Disable
	            			dAddr = dHeight*dWidth*1+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = tValue;   force AddrBus = AddressOut; 
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;
	            			// -------------------------------------------------
               				release DataBus;
	         		end
			end
		end
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;

		// Memory[2nd Area] -> **memY -----------------------------
		// GetMemoryData(1, dHeight*dWidth);	// BMP_GAUSSIAN
	   	for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
		      		// Read_Pixel_from_Mem(i,j,dOffset);
	         		bWE = 1;		// Read Mode
           			bCE = 1;		// Chip Disable
	         		dAddr = dHeight*dWidth+(i*dWidth+j);	
	        		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	         		force AddrBus = AddressOut;
	         		// Read Operation
	         		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
            			#20 memY[i*dWidth+j] = DataBus;
            			#20	force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
            			#20;
		   	end
	   	end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;

		//WriteBMPOut(BMP_GAUSSIAN);			// Image Gaussian applied ----------------
		fileO = $fopen("1.OutputGauss.bmp","wb");
      		// BMP HEADER MAGIC NUMBER
		for(i=0; i<2; i=i+1) $fwrite(fileO, "%c", FILE_HEADER[i]);
		for(i=0; i<13; i=i+1)	$fwrite(fileO, "%u", HeaderLine[i]);	
      		
		// Data
      		for(i=0; i<dHeight; i=i+1)   begin
			for(j=0; j<dWidth; j=j+1)   begin
			   	memLine[j*3+0]=memY[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+1]=memY[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+2]=memY[(dHeight-i-1)*dWidth+j];
			end
			for(j=0; j<150; j=j+1)   // dWidth*3/4
			   	$fwrite(fileO, "%u", {memLine[j*4+3],memLine[j*4+2],memLine[j*4+1],memLine[j*4+0]});		
		end
		$fclose(fileO);
		$display("> 1.OutputGauss.bmp is created.\n");
		// -----------------------------------------------------------------------
		
      		// SendUART(0x47)---------------------------------------------------------
	  	// *****************************************
		// Insert your code here
		// ...
                force DataBus = 8'h47;
                #60 force AddrBus = 32'h20000001; // Load_XMT_datareg  = 1
                #60 release DataBus; force AddrBus = 32'h20000002; // Byte_ready = 1
                #60 force AddrBus = 32'h20000004; // T_byte = 1;
		// *****************************************
		// ----------------------------------------------------------------------- 
		// -----------------------------------------------------------------------
		// Applying Sobel Operators
	    	// Memory[3rd Area] : Gradient Image
		// Memory[4th Area] : Direction Image
		// -----------------------------------------------------------------------
		dWriteReg = `WRITE_REGX;
		OPMode = `MODE_SOBEL;
		dReadReg = `REG_GRADIENT;
		
		for(i=0; i<dHeight; i=i+1)   begin
			for(j=0; j<dWidth; j=j+1)   begin
				//Do_3x3_Sobel(i,j); ------------------------------------------
	         		if(i<1 || j<1 || i>=dHeight-1 || j>=dWidth-1) begin
		         		// Non Gradient and Angle
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
		         		
					//Send_Pixel_to_Mem(i, j, 0x00, dHeight*dWidth*2);	// IMAGE_GRADIENT
	            			bWE = 0;			                     	// Write Mode
	            			bCE = 1;						// Chip Disable
	            			dAddr = dHeight*dWidth*2+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = 8'h00;   force AddrBus = AddressOut; 
	            			// Write Operation
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;
	            			// -----------------------------------------
		         		//Send_Pixel_to_Mem(i, j, 0x00, dHeight*dWidth*3);	// IMAGE_DIRECTION
	            			bWE = 0;			                     	// Write Mode
	            			bCE = 1;			                     	// Chip Disable
	            			dAddr = dHeight*dWidth*3+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			
					// WRITE TO MEMORY  
	            			force DataBus = 8'h00;   force AddrBus = AddressOut; 
	            			// Write Operation
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;
	            			// -----------------------------------------
	         		end
	         		else begin
		         		// *****************************************
					// Insert your code here
					// ... 
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
               
		         		// Read 3x3 block from Memory
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
		               				// Read_Pixel_from_Mem(i,j,dOffset); -------
	                  				bWE = 1;		// Read Mode
                     					bCE = 1;		// Chip Disable
                                                        // TODO verify dAddr
                                                        dAddr = dHeight*dWidth*1+(k*dWidth+l);	
                                                        //AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
	                  				AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	                  				force AddrBus = AddressOut;
	                  
							// Read Operation
	                  				#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                     					#20 dBlock3x3[k*3+l] = DataBus;
                     					#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                     					#20;
                     					// -----------------------------------------
			         		end
		         		end
		         		#20
		         		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		         		#20 release DataBus;      		   release AddrBus;

		         		//Init_to_Canny();
	            			bWE = 0;   bCE = 1;   bOPEnable = 1;
	            			AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
               				release DataBus;      force AddrBus = AddressOut; #60;
	
		         		bWE = 0;
		         		bCE = 1;
		         		bOPEnable = 1;
		         		
					// Send 3x3 block to Canny
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		force DataBus = dBlock3x3[k*3+l];
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end
		         
					// Operation Enable
		         		#20	force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bOPEnable);   //bOPEnable = 0;
		         		#80	force AddrBus = AddressOut | (1<<`IDX_CANNY_bOPEnable);    //bOPEnable = 1;
		
		         		// Read pixel from Canny 
		         		k = 1; 	l = 1;	
		         		bWE = 1;	bCE = 1;
                                        dReadReg = `REG_GRADIENT;
		         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
		         		release DataBus;      force AddrBus = AddressOut; #60;
		         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
		         		#80 tGradient = DataBus;
		         		#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
		         		#20;
	
                                        dReadReg = `REG_DIRECTION;
		         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
		         		release DataBus;      force AddrBus = AddressOut; #60;
		         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
		         		#80 tDirection = DataBus;
		         		#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
		         		#20;

		         		// Send pixel to Memory	
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
	            			
					// Send_Pixel_to_Mem(i, j, data, dOffset) ---------
	            			bWE = 0;	                     // Write Mode
	            			bCE = 1;		             // Chip Disable
	            			dAddr = dHeight*dWidth*2+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = tGradient;   force AddrBus = AddressOut; 
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;

					// Send_Pixel_to_Mem(i, j, data, dOffset) ---------
	            			bWE = 0;	                     // Write Mode
	            			bCE = 1;		             // Chip Disable
	            			dAddr = dHeight*dWidth*3+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = tDirection;   force AddrBus = AddressOut; 
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;

                                        
					// *****************************************
	            	         	release DataBus;
           			end
			end
		end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;
		
		// Memory[3rd Area] -> **X
		// GetMemoryData(0, DIBH.dHeight*DIBH.dWidth*2);	// BMP_GRADIENT
	   	for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
		      		// Read_Pixel_from_Mem(i,j,dOffset);
	         		bWE = 1;				// Read Mode
           			bCE = 1;				// Chip Disable
	         		dAddr = dHeight*dWidth*2+(i*dWidth+j);	
	         		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	         		force AddrBus = AddressOut;
	         		
				// Read Operation
	         		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
            			#20 memX[i*dWidth+j] = DataBus;
            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
            			#20;
		   	end
	   	end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;

		//WriteBMPOut(BMP_GRADIENT);			// Gradient Image ----------------
		fileO = $fopen("2.OutputGradient.bmp","wb");
      		// BMP HEADER MAGIC NUMBER
		for(i=0; i<2; i=i+1) 	$fwrite(fileO, "%c", FILE_HEADER[i]);
		for(i=0; i<13; i=i+1)	$fwrite(fileO, "%u", HeaderLine[i]);	

      		// Data
      		for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
			   	memLine[j*3+0]=memX[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+1]=memX[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+2]=memX[(dHeight-i-1)*dWidth+j];
			end
			for(j=0; j<150; j=j+1)   // dWidth*3/4
			   	$fwrite(fileO, "%u", {memLine[j*4+3],memLine[j*4+2],memLine[j*4+1],memLine[j*4+0]});		
		end
		$fclose(fileO);
		$display("> 2.OutputGradient.bmp is created.\n");
		
		// Memory[4th Area] -> **Y
		dReadReg = `REG_DIRECTION;
                dWriteReg = `WRITE_REGY;
		// GetMemoryData(1, DIBH.dHeight*DIBH.dWidth*3);	// BMP_DIRECTION
	   	for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
		      		// Read_Pixel_from_Mem(i,j,dOffset);
	         		bWE = 1;				// Read Mode
            			bCE = 1;				// Chip Disable
	         		dAddr = dHeight*dWidth*3+(i*dWidth+j);	
	         		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	         		force AddrBus = AddressOut;
	         		
				// Read Operation
	         		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
            			#20 memY[i*dWidth+j] = DataBus;
            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
            			#20;
	   		end
	   	end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;

		//WriteBMPOut(BMP_DIRECTION);			// Angle Image ----------------
		fileO = $fopen("3.OutputDirection.bmp","wb");
      		// BMP HEADER MAGIC NUMBER
		for(i=0; i<2; i=i+1) 	$fwrite(fileO, "%c", FILE_HEADER[i]);
		for(i=0; i<13; i=i+1)	$fwrite(fileO, "%u", HeaderLine[i]);	

      		// Data
      		for(i=0; i<dHeight; i=i+1)
		begin
		   	for(j=0; j<dWidth; j=j+1)
			begin
			   	rG=8'h00; rB=8'h00; rR=8'h00;
			   	// Edge Direction 90 = Edge Normal 0 Degree
			   	if(memY[(dHeight-i-1)*dWidth+j]==90) begin
			       		rG = 8'hff;   rB = 8'h00;   rR = 8'hff;
			   	end
			   	// Edge Direction 135 = Edge Normal 45 Degree
			   	else if(memY[(dHeight-i-1)*dWidth+j]==135) begin
			       		rG = 8'hff;   rB = 8'h00;   rR = 8'h00;
			   	end
			   	// Edge Direction 0 = Edge Normal 90 Degree
			   	else if(memY[(dHeight-i-1)*dWidth+j]==0) begin
			       		rG = 8'h00;   rB = 8'hff;   rR = 8'h00;
			   	end
			   	// Edge Direction 45 = Edge Normal 135 Degree
			   	else begin //if(memY[(dHeight-i-1)*dWidth+j]==90) begin
			       		rG = 8'h00;   rB = 8'h00;   rR = 8'hff;
			   	end
			   	memLine[j*3+0]=rB;
			   	memLine[j*3+1]=rG;
			   	memLine[j*3+2]=rR;
			end
			for(j=0; j<150; j=j+1)   // dWidth*3/4
			   	$fwrite(fileO, "%u", {memLine[j*4+3],memLine[j*4+2],memLine[j*4+1],memLine[j*4+0]});		
			end

		$fclose(fileO);
		$display("> 3.OutputDirection.bmp is created.\n");
		
      		// SendUART(0x53)---------------------------------------------------------
      	  	// *****************************************
		// Insert your code here
		// ...
                force DataBus = 8'h53;
                #60 force AddrBus = 32'h20000001; // Load_XMT_datareg  = 1
                #60 release DataBus; force AddrBus = 32'h20000002; // Byte_ready = 1
                #60 force AddrBus = 32'h20000004; // T_byte = 1;
		// *****************************************	 
		// -----------------------------------------------------------------------
		// Applying Non Maximum Suppression
		// Memory[3rd Area] : NMS Image	
		// -----------------------------------------------------------------------      
		OPMode = `MODE_NMS;
                dWriteReg = `WRITE_REGX;
                dReadReg = `REG_NMS;
		for(i=0; i<dHeight; i=i+1)   begin
			for(j=0; j<dWidth; j=j+1)   begin
				//Do_3x3_NMS(i,j);
	         		if(i<1 || j<1 || i>=dHeight-1 || j>=dWidth-1)   begin
		         		// Non Gradient and Angle
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
		         		
					//Send_Pixel_to_Mem(i, j, 0x00, dHeight*dWidth*2);	// IMAGE_GRADIENT
	            			bWE = 0;	                     // Write Mode
	            			bCE = 1;	                     // Chip Disable
	            			dAddr = dHeight*dWidth*2+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = 8'h00;   force AddrBus = AddressOut; 
	            			// Write Operation
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;
	            			// -----------------------------------------
	         		end
	         		else begin
		         		// *****************************************
					// Insert your code here 
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
               
		         		// Read 3x3 block from Memory
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		//dBlock5x5[k*5+l]=Read_Pixel_from_Mem(i+(k-2),j+(l-2),0);	//IMAGE_ORIGIN
		               				// Read_Pixel_from_Mem(i,j,dOffset); -------
	                  				bWE = 1;		// Read Mode
                     					bCE = 1;		// Chip Disable
                                                        dAddr = dHeight*dWidth*1+(i*dWidth+j);	
                                                        //AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
	                  				AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	                  				force AddrBus = AddressOut;
	                  
							// Read Operation
	                  				#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                     					#20 dBlockA3x3[k*3+l] = DataBus;
                     					#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                     					#20;
                     					// -----------------------------------------
			         		end
		         		end
		         		#20
		         		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		         		#20 release DataBus;      		   release AddrBus;
		         		// Read 3x3 block from Memory
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		//dBlock5x5[k*5+l]=Read_Pixel_from_Mem(i+(k-2),j+(l-2),0);	//IMAGE_ORIGIN
		               				// Read_Pixel_from_Mem(i,j,dOffset); -------
	                  				bWE = 1;		// Read Mode
                     					bCE = 1;		// Chip Disable
                                                        dAddr = dHeight*dWidth*1+(i*dWidth+j);	
                                                        //AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
	                  				AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	                  				force AddrBus = AddressOut;
	                  
							// Read Operation
	                  				#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                     					#20 dBlockB3x3[k*5+l] = DataBus;
                     					#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                     					#20;
                     					// -----------------------------------------
			         		end
		         		end
		         		#20
		         		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		         		#20 release DataBus;      		   release AddrBus;

		         		//Init_to_Canny();
	            			bWE = 0;   bCE = 1;   bOPEnable = 1;
	            			AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
               				release DataBus;      force AddrBus = AddressOut; #60;
	
		         		bWE = 0;
		         		bCE = 1;
		         		bOPEnable = 1;
		         		
					// Send 3x3 block to Canny
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		force DataBus = dBlockA3x3[k*3+l];
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end

					// Send 3x3 block to Canny
                                        dWriteReg = `WRITE_REGY;
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		force DataBus = dBlockB3x3[k*3+l];
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end

		         
					// Operation Enable
		         		#20	force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bOPEnable);   //bOPEnable = 0;
		         		#80	force AddrBus = AddressOut | (1<<`IDX_CANNY_bOPEnable);    //bOPEnable = 1;
		
		         		// Read pixel from Canny 
		         		bWE = 1;	bCE = 1;
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
                                                        dBlockC3x3[k*3+l] = DataBus;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end

                                        // TODO fix to send 3x3
		         		// Send pixel to Memory	
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
	            			
					// Send_Pixel_to_Mem(i, j, data, dOffset) ---------
	            			bWE = 0;	                     // Write Mode
	            			bCE = 1;		             // Chip Disable
	            			dAddr = dHeight*dWidth*2+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = tValue;   force AddrBus = AddressOut; 
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;

					// *****************************************
	            	         	release DataBus;
            			end
			end
		end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;

		// Memory[3rd Area] -> **X
		// GetMemoryData(0, DIBH.dHeight*DIBH.dWidth*2);	// BMP_NMS
	   	for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
		      		// Read_Pixel_from_Mem(i,j,dOffset);
	         		bWE = 1;				// Read Mode
            			bCE = 1;				// Chip Disable
	         		dAddr = dHeight*dWidth*2+(i*dWidth+j);	
	         		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	         		force AddrBus = AddressOut;
	         		// Read Operation
	         		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
            			#20 memX[i*dWidth+j] = DataBus;
            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
            			#20;
		   	end
	   	end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;	force AddrBus = 32'h0000_0000;
		#20 release DataBus;      	release AddrBus;

		//WriteBMPOut(BMP_NMS);			// NMS Image ----------------
		fileO = $fopen("4.OutputNMS.bmp","wb");
      		// BMP HEADER MAGIC NUMBER
		for(i=0; i<2; i=i+1) $fwrite(fileO, "%c", FILE_HEADER[i]);
		for(i=0; i<13; i=i+1)	$fwrite(fileO, "%u", HeaderLine[i]);	

      		// Data
      		for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
			   	memLine[j*3+0]=memX[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+1]=memX[(dHeight-i-1)*dWidth+j];
			   	memLine[j*3+2]=memX[(dHeight-i-1)*dWidth+j];
			end
			for(j=0; j<150; j=j+1)   // dWidth*3/4
			   	$fwrite(fileO, "%u", {memLine[j*4+3],memLine[j*4+2],memLine[j*4+1],memLine[j*4+0]});		
		end
		$fclose(fileO);
		$display("> 4.OutputNMS.bmp is created.\n");
		
      		// SendUART(0x48)---------------------------------------------------------
       	  	// *****************************************
		// Insert your code here
		// ...
                force DataBus = 8'h48;
                #60 force AddrBus = 32'h20000001; // Load_XMT_datareg  = 1
                #60 release DataBus; force AddrBus = 32'h20000002; // Byte_ready = 1
                #60 force AddrBus = 32'h20000004; // T_byte = 1;
		// *****************************************	
		// -----------------------------------------------------------------------
		// Applying Hysteresiis Thresholding
		// Memory[5hd Area] : Hysteresis Image	
		// -----------------------------------------------------------------------        		
		OPMode = `MODE_HYSTERESIS;
		dReadReg = `REG_HYSTERESIS;
                dWriteReg = `WRITE_REGX;
		for(i=0; i<dHeight; i=i+1)   begin
			for(j=0; j<dWidth; j=j+1)   begin
				//Do_3x3_Hysteresis(i,j);
	         		if(i<1 || j<1 || i>=dHeight-1 || j>=dWidth-1)   begin
		         		// Non Hysteresis
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
		         
					//Send_Pixel_to_Mem(i, j, 0x00, dHeight*dWidth*4);	// IMAGE_HYSTERESIS
	            			bWE = 0;					// Write Mode
	            			bCE = 1;					// Chip Disable
	            			dAddr = dHeight*dWidth*4+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = 8'h00;   force AddrBus = AddressOut; 
	            			// Write Operation
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;
	            			// -----------------------------------------
	         		end
	         		else begin
		         		// *****************************************
					// Insert your code here 
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
               
		         		// Read 3x3 block from Memory
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		//dBlock5x5[k*5+l]=Read_Pixel_from_Mem(i+(k-2),j+(l-2),0);	//IMAGE_ORIGIN
		               				// Read_Pixel_from_Mem(i,j,dOffset); -------
	                  				bWE = 1;		// Read Mode
                     					bCE = 1;		// Chip Disable
	                  				dAddr = 0+((i+(k-2))*dWidth+(j+(l-2)));	
	                  				AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	                  				force AddrBus = AddressOut;
	                  
							// Read Operation
	                  				#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                     					#20 dBlockA3x3[k*3+l] = DataBus;
                     					#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                     					#20;
                     					// -----------------------------------------
			         		end
		         		end
		         		#20
		         		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		         		#20 release DataBus;      		   release AddrBus;

		         		// Read 3x3 block from Memory
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		//dBlock5x5[k*5+l]=Read_Pixel_from_Mem(i+(k-2),j+(l-2),0);	//IMAGE_ORIGIN
		               				// Read_Pixel_from_Mem(i,j,dOffset); -------
	                  				bWE = 1;		// Read Mode
                     					bCE = 1;		// Chip Disable
	                  				dAddr = 0+((i+(k-2))*dWidth+(j+(l-2)));	
	                  				AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	                  				force AddrBus = AddressOut;
	                  
							// Read Operation
	                  				#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                     					#20 dBlockB3x3[k*3+l] = DataBus;
                     					#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                     					#20;
                     					// -----------------------------------------
			         		end
		         		end
		         		#20
		         		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		         		#20 release DataBus;      		   release AddrBus;
		         		
		         		// Read 3x3 block from Memory
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		//dBlock5x5[k*5+l]=Read_Pixel_from_Mem(i+(k-2),j+(l-2),0);	//IMAGE_ORIGIN
		               				// Read_Pixel_from_Mem(i,j,dOffset); -------
	                  				bWE = 1;		// Read Mode
                     					bCE = 1;		// Chip Disable
	                  				dAddr = 0+((i+(k-2))*dWidth+(j+(l-2)));	
	                  				AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	                  				force AddrBus = AddressOut;
	                  
							// Read Operation
	                  				#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
                     					#20 dBlockC3x3[k*3+l] = DataBus;
                     					#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
                     					#20;
                     					// -----------------------------------------
			         		end
		         		end
		         		#20
		         		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		         		#20 release DataBus;      		   release AddrBus;

                                        //Init_to_Canny();
	            			bWE = 0;   bCE = 1;   bOPEnable = 1;
	            			AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
               				release DataBus;      force AddrBus = AddressOut; #60;
	
		         		bWE = 0;
		         		bCE = 1;
		         		bOPEnable = 1;
		         		
					// Send 3x3 block to Canny
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		force DataBus = dBlockA3x3[k*3+l];
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end
		         
					// Send 3x3 block to Canny
                                        dWriteReg = `WRITE_REGY;
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		force DataBus = dBlockB3x3[k*3+l];
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end

                                        // Send 3x3 block to Canny
                                        dWriteReg = `WRITE_REGZ;
		         		for(k=0; k<3; k=k+1)   begin
			         		for(l=0; l<3; l=l+1)   begin
				         		force DataBus = dBlockC3x3[k*3+l];
				         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
				         		force AddrBus = AddressOut;
				         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
				         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
			         		end
		         		end
				
                                        // Operation Enable
		         		#20	force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bOPEnable);   //bOPEnable = 0;
		         		#80	force AddrBus = AddressOut | (1<<`IDX_CANNY_bOPEnable);    //bOPEnable = 1;
		
		         		// Read pixel from Canny 
		         		k = 1; 	l = 1;	
		         		bWE = 1;	bCE = 1;
		         		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(k<<5)+(l<<2)+(bWE<<1)+bCE;
		         		release DataBus;      force AddrBus = AddressOut; #60;
		         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
		         		#80 tValue = DataBus;
		         		#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
		         		#20;
	
		         		// Send pixel to Memory	
		         		//Init_to_Mem();
	            			bWE = 0;   bCE = 1;   dAddr = 0;
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            			release DataBus;      force AddrBus = AddressOut; #60;
	            			
					// Send_Pixel_to_Mem(i, j, data, dOffset) ---------
	            			bWE = 0;	                     // Write Mode
	            			bCE = 1;		             // Chip Disable
	            			dAddr = dHeight*dWidth*4+(i*dWidth+j);	
	            			AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	            
					// WRITE TO MEMORY  
	            			force DataBus = tValue;   force AddrBus = AddressOut; 
	            			#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
	            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
	            			#20;
                                
					// *****************************************
	            	         	release DataBus;
            			end
			end
		end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;

		// Memory[5th Area] -> **X
		// GetMemoryData(1, DIBH.dHeight*DIBH.dWidth*4);	// BMP_HYSTERESIS
	   	for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
		      		// Read_Pixel_from_Mem(i,j,dOffset);
	         		bWE = 1;				// Read Mode
           			bCE = 1;				// Chip Disable
	         		dAddr = dHeight*dWidth*4+(i*dWidth+j);	
	         		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
	         		force AddrBus = AddressOut;
	         		// Read Operation
	         		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
            			#20 memX[i*dWidth+j] = DataBus;
            			#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
            			#20;
		   	end
	   	end
		#20;
		// Release Bus
		#20 force DataBus = 8'hzz;		   force AddrBus = 32'h0000_0000;
		#20 release DataBus;      		   release AddrBus;

		//WriteBMPOut(BMP_HYSTERESIS);			// Hysteresis Image ----------------
		fileO = $fopen("5.OutputHysteresis.bmp","wb");
      		// BMP HEADER MAGIC NUMBER
		for(i=0; i<2; i=i+1) $fwrite(fileO, "%c", FILE_HEADER[i]);
		for(i=0; i<13; i=i+1)	$fwrite(fileO, "%u", HeaderLine[i]);	

      		// Data
      		for(i=0; i<dHeight; i=i+1)   begin
		   	for(j=0; j<dWidth; j=j+1)   begin
				rG=8'h00; rB=8'h00; rR=8'h00;
			   	// Edge Direction 90 = Edge Normal 0 Degree
			   	if(memX[(dHeight-i-1)*dWidth+j]==0) begin
			       		memLine[j*3+0] = 8'h00;
			       		memLine[j*3+1] = 8'h00;
			       		memLine[j*3+2] = 8'h00;
			   	end
			   	else begin
			       		memLine[j*3+0] = 8'hff;
			       		memLine[j*3+1] = 8'hff;
			       		memLine[j*3+2] = 8'hff;
			   	end
			end
			for(j=0; j<150; j=j+1)   // dWidth*3/4
			   	$fwrite(fileO, "%u", {memLine[j*4+3],memLine[j*4+2],memLine[j*4+1],memLine[j*4+0]});		
		end
		$fclose(fileO);
		$display("> 5.OutputHysteresis.bmp is created.\n");
		
      		#3000 $finish;	//$stop;		// stop
   	end
  
	//initial
	//begin 
	//	#200
	//	$monitor($time, "CLK[%b->%b] SerialOut: %b", clk, !clk, Serial_out);
	//end
	//initial
	//	$sdf_annotate("MAINSYSTEM.sdf", MAINSYSTEM_01);

endmodule
