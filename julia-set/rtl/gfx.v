`timescale 1ns / 1ps

module gfx (
    input wire clk,
    input wire rst,
    input wire signed [15:0] i_x,
    input wire signed [15:0] i_y,
    input wire i_v_sync,
    input wire [2:0] i_btn,
    output reg [7:0] o_red,
    output reg [7:0] o_green,
    output reg [7:0] o_blue
    );

    // Button debounce registers
    reg [2:0] push_reg;
    wire [2:0] push_button = i_btn & ~push_reg;

    // Button state synchronization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            push_reg <= 0;
        end
        else begin
            push_reg <= i_btn;
        end
    end

    // Display control parameters
    reg [2:0] scale;          // Controls scale level of the display
    reg [1:0] c;              // Selects different c variations
    reg start_frame;          // Triggers new frame calculation
    
    // Frame generation status signals
    wire frame_ready;         // Indicates frame calculation completion
    wire [3:0] oled;         // Pixel intensity value
    
    // Julia set frame generator instance
    frame_generator frame_generator(
        .clk(clk),
        .rst(rst),
        .scale(scale),
        .c(c),
        .i_x(i_x),
        .i_y(i_y),
        .start_frame(start_frame),
        .frame_ready(frame_ready),
        .oled(oled)
    );

    // RGB color mapping logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_red <= 0;
            o_green <= 0;
            o_blue <= 0;
        end else begin
            if (frame_ready) begin
                // Convert intensity to grayscale RGB values
                o_red <= oled * 16;
                o_green <= oled * 16;
                o_blue <= oled * 16;
            end
        end
    end

    // User input processing and parameter control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize display parameters
            scale <= 2;
            c <= 1;
            start_frame <= 1;
        end else begin
            // Clear frame start signal by default
            start_frame <= 0;
            
            // Handle user input for zoom and c selection
            if (push_button[2] && scale < 4) begin
                scale <= scale + 1;           // Zoom in
                start_frame <= 1;
            end else if (push_button[1] && scale > 1) begin
                scale <= scale - 1;           // Zoom out
                start_frame <= 1;
            end else if (push_button[0]) begin
                c <= (c == 3) ? 1 : c + 1;    // Cycle through c variations
                start_frame <= 1;
            end
        end
    end

endmodule