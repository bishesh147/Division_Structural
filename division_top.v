// Define a module named "division_top"
module division_top(dividend, divisor, quotient, remainder, clk, reset, start, ready);
    // Inputs
    input [63:0] dividend;         // 64-bit dividend input
    input [63:0] divisor;          // 64-bit divisor input
    input clk, reset, start;       // Clock, reset, and start signals
    
    // Outputs
    output ready;                   // Ready signal
    output [63:0] remainder;       // Remainder output
    output [63:0] quotient;        // Quotient output

    // Internal wires
    wire [63:0] shifted_rem_q_out; // Shifted remainder and quotient output
    wire [63:0] divisor_out;       // Divisor output
    wire [63:0] subtractor_out;    // Subtractor output
    wire [63:0] rem_q_rem_out;     // Remainder output from rem_q_register
    wire [63:0] rem_q_q_out;       // Quotient output from rem_q_register
    wire control_wr;               // Write enable signal for control unit
    wire control_initial_wr;       // Initial write enable signal for control unit
    wire control_sh_left;          // Shift left signal for control unit

    // Instantiate modules
    // Divisor register instantiation
    divisor_register dvr1(
        .data_out(divisor_out),    // Output data from divisor register
        .data_in(divisor),         // Input data to divisor register
        .clk(clk),                 // Clock signal
        .reset(reset));            // Reset signal

    // Subtractor instantiation
    subtractor sub1(
        .diff(subtractor_out),     // Subtraction result output
        .a(shifted_rem_q_out),     // Input a to subtractor (shifted remainder and quotient)
        .b(divisor_out));          // Input b to subtractor (divisor)

    // Remainder quotient register instantiation
    rem_q_register remq1(
        .clk(clk),                  // Clock signal
        .reset(reset),              // Reset signal
        .data_in(subtractor_out),  // Input data to rem_q_register (subtraction result)
        .wr(control_wr),           // Write enable signal from control unit
        .initial_data_in(dividend),// Initial data input to rem_q_register (dividend)
        .initial_wr(control_initial_wr), // Initial write enable signal from control unit
        .rem_out(rem_q_rem_out),   // Remainder output from rem_q_register
        .q_out(rem_q_q_out),       // Quotient output from rem_q_register
        .sh_left(control_sh_left), // Shift left signal from control unit
        .shifted_rem_q(shifted_rem_q_out)); // Shifted remainder and quotient input to rem_q_register

    // Control unit instantiation
    control cu1(
        .clk(clk),                  // Clock signal
        .reset(reset),              // Reset signal
        .start(start),              // Start signal
        .data_in(subtractor_out),  // Input data to control unit (subtraction result)
        .ready(ready),              // Ready signal output from control unit
        .wr(control_wr),           // Write enable signal output to rem_q_register
        .initial_wr(control_initial_wr), // Initial write enable signal output to rem_q_register
        .sh_left(control_sh_left)); // Shift left signal output to rem_q_register

    // Assign outputs
    assign quotient = rem_q_q_out;    // Output quotient
    assign remainder = rem_q_rem_out; // Output remainder
endmodule
