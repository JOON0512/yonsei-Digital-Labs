`timescale 1ns / 1ps

module mul (
    // Inputs are 32-bit signed fixed-point numbers (Q15.16 format)
    // 1 sign bit, 15 integer bits, 16 fractional bits
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    // Output is also 32-bit signed fixed-point (Q15.16 format)
    output wire signed [31:0] val
    );
    
    // Temporary 64-bit product to hold full multiplication result
    // When multiplying two Q15.16 numbers, we get Q30.32 format
    wire signed [63:0] product;
    
    // Multiply inputs
    assign product = a * b;
    
    // Extract middle 32 bits to maintain Q15.16 format
    // Discards 16 LSBs (fractional bits) and 16 MSBs (overflow bits)
    // Result is in Q15.16 format: 1 sign bit, 15 integer bits, 16 fractional bits
    assign val  = product[47:16];
endmodule
