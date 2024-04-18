// Define a module named "divisor_register"
module divisor_register(data_out, data_in, clk, reset);
    // Define inputs and outputs
    input [63:0] data_in; // 64-bit input data
    input clk, reset;     // Clock and reset inputs
    output [63:0] data_out; // 64-bit output data
    
    // Declare a 64-bit register named div_reg
    reg [63:0] div_reg;
    
    // Register process block triggered at the positive edge of the clock
    always @(posedge clk) begin
        // If reset is asserted, reset the div_reg to zero
        if (reset) 
            div_reg <= 64'd0;
        else
            // Else, load the input data into the div_reg
            div_reg <= data_in;
    end
    
    // Assign the div_reg value to the data_out
    assign data_out = div_reg;
endmodule
