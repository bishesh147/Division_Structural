// Define a module named "subtractor"
module subtractor(diff, a, b);
    // Define inputs a and b as 64-bit vectors
    input [63:0] a;
    input [63:0] b;
    // Define output diff as a 64-bit vector
    output [63:0] diff;
    // Perform subtraction operation and assign the result to diff
    assign diff = a - b;
endmodule
