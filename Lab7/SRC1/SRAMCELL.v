module SRAMCELL (InData, OutData, bCS, bWE);

// Declare input/output signals
// ...
input InData;
output OutData;
input bCS;
input bWE;

// Internal register/wire
// ...
wire data_in;
wire cs_we;
reg d;

and(data_in, InData, !bWE);
and(cs_we, bWE, d);
or(d, data_in, cs_we);


// Functional Module Description
always @(d or bCS)	// Sensitivity
begin
        if(!bCS)
            OutData <= d;
end
endmodule

