// Define a module named "rem_q_register"
module rem_q_register(clk, reset, data_in, wr, initial_data_in, initial_wr, sh_left, rem_out, q_out, shifted_rem_q);
    // Inputs
    input [63:0] data_in;            // 64-bit data input
    input [63:0] initial_data_in;    // 64-bit initial data input
    input clk, reset, wr, initial_wr, sh_left;  // Clock, reset, write enable, initial write enable, and shift left signals
    
    // Outputs
    output [63:0] rem_out;           // Remainder output
    output [63:0] q_out;             // Quotient output
    output [63:0] shifted_rem_q;     // Shifted remainder and quotient
    
    // Registers for remainder and quotient
    reg [63:0] rem_reg;              // Remainder register
    reg [63:0] q_reg;                // Quotient register

    // Clocked always block
    always @(posedge clk) begin
        // Reset conditions
        if (reset) begin
            rem_reg <= 64'd0;        // Reset remainder register
            q_reg <= 64'd0;          // Reset quotient register
        end
        else begin
            // Check if initial write is enabled
            if (initial_wr == 1) begin
                rem_reg <= 64'd0;    // Reset remainder register
                q_reg <= initial_data_in; // Load initial data into quotient register
            end
            else begin
                // If write is enabled, update remainder and quotient registers
                if (wr == 1) begin
                    rem_reg <= data_in; // Update remainder register with input data, which is the subtracted value
                    q_reg <= {q_reg[62:0], 1'b1}; // Shift quotient register left and append '1'
                end        
                // If shift left is enabled, update registers with shifted remainder and quotient
                else if (sh_left == 1) begin 
                    rem_reg <= shifted_rem_q; // Update remainder register with shifted remainder and quotient
                    q_reg <= {q_reg[62:0], 1'b0}; // Shift quotient register left and append '0'
                end
            end
        end
    end
    
    // Assign shifted remainder and quotient
    assign shifted_rem_q = {rem_reg[62:0], q_reg[63]}; //We have two different registers, but we treat them as the same, so when we shift remainder, the largest bit of the quotient comes at the least significant bit
    // Assign outputs
    assign rem_out = rem_reg;  // Output remainder
    assign q_out = q_reg;      // Output quotient
endmodule
