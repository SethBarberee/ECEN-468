module SRAMCELL (InData, OutData, bCS, bWE);

// Declare input/output signals
input InData;
output OutData;
input bCS;
input bWE;

// Internal register/wire
reg d;
reg OutData;



// Functional Module Description
always @(InData or bCS or bWE)	// Sensitivity
begin
        if (!bCS && !bWE)
            d <= InData;
        else if(!bCS)
            OutData <= d;
end
endmodule

