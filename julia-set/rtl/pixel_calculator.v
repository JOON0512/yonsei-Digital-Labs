`timescale 1ns / 1ps

module pixel_calculator(
    input wire clk,
    input wire rst,
    input wire [31:0] x,                // x in Q15.16 format
    input wire [31:0] y,                // y in Q15.16 format
    input wire [1:0] c,                 // c state
    input wire frame_ready,
    output reg [3:0] pixel_brightness,  // Brightness for a single pixel
    output reg calc_ready                 // Signals when the computation for a pixel is complete
);
    // Current iteration coordinates
    reg signed [31:0] zx, zy;

    // Fixed-point constants for different Julia sets
    localparam signed [31:0] C_RE1 = 32'hff_ff_99_9a; // Set 1 real component
    localparam signed [31:0] C_IM1 = 32'h00_00_99_99; // Set 1 imaginary component
    localparam signed [31:0] C_RE2 = 32'hff_ff_33_34; // Set 2 real component
    localparam signed [31:0] C_IM2 = 32'h00_00_27_ef; // Set 2 imaginary component
    localparam signed [31:0] C_RE3 = 32'hff_ff_45_ca; // Set 3 real component
    localparam signed [31:0] C_IM3 = 32'h00_00_30_5b; // Set 3 imaginary component
    localparam signed [31:0] FOUR = 32'h00_04_00_00;  // Escape radius threshold
    localparam [7:0] MAX_ITERATION = 8'd255;

    // Select Julia set parameters based on input selection
    reg signed [31:0] c_re, c_im;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_re <= 0;
            c_im <= 0;
        end else begin
            // Choose between three predefined Julia sets
            c_re <= (c == 2'b10) ? C_RE2 : 
                   (c == 2'b11) ? C_RE3 : C_RE1;
            c_im <= (c == 2'b10) ? C_IM2 : 
                   (c == 2'b11) ? C_IM3 : C_IM1;
        end
    end

    // Intermediate calculation signals
    reg cold_start;
    reg [7:0] iteration;
    wire signed [31:0] zx2, zy2, zxzy2;
    wire signed [31:0] magnitude;

    // Complex number arithmetic components
    mul mul_zx2 (.a(zx), .b(zx), .val(zx2));     // Real part squared
    mul mul_zy2 (.a(zy), .b(zy), .val(zy2));     // Imaginary part squared
    mul mul_zxzy (.a(zx), .b(zy), .val(zxzy2));  // Cross product
    assign magnitude = zx2 + zy2;                    // Complex magnitude squared

    // Parallel computation configuration
    parameter NUM_UNITS = 2;
    
    // Storage for parallel computation units
    reg signed [31:0] zx_array [NUM_UNITS-1:0];
    reg signed [31:0] zy_array [NUM_UNITS-1:0];
    reg [7:0] iteration_array [NUM_UNITS-1:0];
    
    // Generate parallel computation units
    genvar i;
    generate
        for (i = 0; i < NUM_UNITS; i = i + 1) begin : compute_units
            wire signed [31:0] zx2_local, zy2_local, zxzy2_local;
            wire signed [31:0] magnitude_local;
            
            // Complex arithmetic for each unit
            mul mul_zx2_local (.a(zx_array[i]), .b(zx_array[i]), .val(zx2_local));
            mul mul_zy2_local (.a(zy_array[i]), .b(zy_array[i]), .val(zy2_local));
            mul mul_zxzy_local (.a(zx_array[i]), .b(zy_array[i]), .val(zxzy2_local));
        end
    endgenerate

    // Main iteration control and pixel value calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            iteration <= 0;
            pixel_brightness <= 0;
            calc_ready <= 0;
            cold_start <= 1;
        end else begin
            if (!frame_ready) begin
                if (calc_ready || cold_start) begin
                    // Initialize new pixel calculation
                    zx <= x;
                    zy <= y;
                    iteration <= 0;
                    pixel_brightness <= 0;
                    calc_ready <= 0;
                    cold_start <= 0;
                end else if (iteration == 255 || magnitude > FOUR) begin
                    // Set pixel value based on escape time
                    pixel_brightness <= iteration / 16;
                    calc_ready <= 1;
                end else begin
                    // Perform Julia set iteration
                    zx <= zx2 - zy2 + c_re;
                    zy <= (zxzy2 << 1) + c_im;
                    iteration <= iteration + 1;
                end
            end
        end
    end
endmodule
