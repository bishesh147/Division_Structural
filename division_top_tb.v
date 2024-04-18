`timescale 1ps/1ps // Define timescale for simulation accuracy

// Define testbench module named "division_top_tb"
module division_top_tb;
    // Declare testbench inputs
    reg [63:0] dividend, divisor; // 64-bit dividend and divisor
    reg clk, reset, start;        // Clock, reset, and start signals

    // Declare testbench outputs
    wire ready;                    // Ready signal
    wire [63:0] quotient, remainder; // Quotient and remainder outputs
    
    // Declare integer variable for loop iteration
    integer i;

    // Instantiate the DUT (Design Under Test), division_top module
    division_top dvt1(dividend, divisor, quotient, remainder, clk, reset, start, ready);

    // Generate clock signal
    always #1 clk = ~clk; // Toggle clk every 1 time unit

    // Initial block for testbench setup
    initial begin
        reset = 1;          // Assert reset
        clk = 1;            // Initialize clk
        dividend = 64'd0;   // Initialize dividend to 0
        divisor = 64'd0;    // Initialize divisor to 0
        start = 0;          // Initialize start signal to 0
        #2;                 // Wait for 2 time units
        
        reset = 0;          // Deassert reset
        dividend = 17;      // Set dividend
        divisor = 27;       // Set divisor
        start = 1;          // Assert start signal
        #4;                 // Wait for 4 time units
        
        // Loop for testing multiple iterations
        for (i = 0; i < 100; i = i + 1) begin
            // Wait until ready signal is asserted
            while (ready == 0) begin
                #2; // Wait for 2 time units
            end
            
            // Display iteration number, time, input values, quotient, and remainder
            $display("%d. \t time = %d \t dividend = %d \t divisor = %d \t quotient = %d \t remainder = %d", 
                      i+1, $time, dividend, divisor, quotient, remainder);
            
            start = 1;               // Assert start signal for next iteration
            dividend = dividend * 5; // Update dividend for next iteration
            divisor = divisor * 3;   // Update divisor for next iteration
            #2;                      // Wait for 2 time units
        end 
        
        #10 $finish; // Finish simulation after 10 time units
    end
endmodule
