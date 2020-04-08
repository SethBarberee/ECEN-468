module num3(clock, pedx, light)
    input clock;
    input pedx;
    output light;
    reg [0:1] light; // 00 is green, 01 is yellow, and 10 is red
    reg [0:1] state, next_state;
    reg [0:6] counter;

    assign light = state;

    always(@posedge clock or @posedge pedx) begin
        case(state)
            2'00:
                if(counter > 7'd120 || pedx) begin
                    // Advance to the yellow and reset counter
                    next_state => 2'b01;
                    counter => 7'b0;
                end
                else
                    counter => counter + 1;
            2'01:
                if(counter > 7'd20) begin
                    // advance to red and reset counter
                    next_state => 2'b10;
                    counter => 7'b0;
                end
                else
                    counter => counter + 1;
            2'10:
                if(counter > 7'd30) begin
                    // advance to green and reset counter
                    next_state => 2'b00;
                    counter => 7'b0;
                end
                else
                    counter => counter + 1;
        endcase
    end

    always(@posedge clock) begin
        state <= next_state;
    end

endmodule
