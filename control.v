// Define a module named "control"
module control(clk, reset, start, data_in, ready, wr, initial_wr, sh_left);
    // Inputs
    input clk, reset, start;        // Clock, reset, and start signals
    input [63:0] data_in;           // 64-bit input data

    // Outputs
    output wr;                      // Write enable signal
    output initial_wr;              // Initial write enable signal
    output sh_left;                 // Shift left signal
    output ready;                   // Ready signal
    
    // Internal wires for checking conditions
    wire wr_check;
    wire initial_wr_check;
    wire sh_left_check;
    wire ready_check;
    
    // Registers for state and counter
    reg [1:0] state;                // State register
    reg [9:0] counter;              // Counter register

    // Clocked always block
    always @(posedge clk) begin
        // Reset conditions
        if (reset) begin
            state <= 2'd0;         // Reset state to idle
            counter <= 10'd0;      // Reset counter to zero
        end
        else begin
            // State machine logic
            case (state)
                // Idle state
                2'b00: begin
                    // Transition to Load state when start signal is asserted
                    if (start == 1) state <= 2'b01;
                end

                // Load state
                2'b01: begin
                    counter <= 0;    // Reset counter
                    state <= 2'b10;  // Transition to Operation state
                end

                // Operation state
                2'b10: begin
                    // Transition to Idle state when counter reaches 63
                    if (counter == 63) state <= 2'b00;
                    counter <= counter + 1;  // Increment counter
                end
            endcase
        end
    end

    // Assignments for output signals based on state and data_in
    assign wr_check = (state == 2'b10) && (data_in[63] == 0);    // Wr is asserted when we update the remainder block, data_in is the difference of remainder and divisor, when data_in[64] = 0, the difference is positive
    assign wr = wr_check ? 1 : 0;                                // Set wr based on wr_check
    
    assign initial_wr_check = (state == 2'b01);                  // Check conditions for initial_wr, we initially write in the load state
    assign initial_wr = initial_wr_check ? 1 : 0;                // Set initial_wr based on initial_wr_check
    
    assign sh_left_check = (state == 2'b10);                     // Check conditions for sh_left, we always shift left at op state
    assign sh_left = sh_left_check ? 1 : 0;                      // Set sh_left based on sh_left_check
    
    assign ready_check = (state == 2'b00);                       // Check conditions for ready, indicates when the divider is ready
    assign ready = ready_check ? 1 : 0;                          // Set ready based on ready_check
endmodule
