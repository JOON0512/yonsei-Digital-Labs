`timescale 1ns / 1ps

module frame_generator (
    input wire clk,
    input wire rst,
    input wire [2:0] scale,
    input wire [1:0] c,
    input wire [10:0] i_x,
    input wire [9:0] i_y,
    input wire start_frame,
    output reg frame_ready,
    output wire [3:0] oled
);

    // Instantiate coordinate calculation components
    reg [10:0] i;          // Horizontal pixel counter
    reg [9:0] j;           // Vertical pixel counter
    wire signed [31:0] x;  // Transformed x coordinate
    wire signed [31:0] y;  // Transformed y coordinate
    wire [3:0] pixel_brightness;
    wire calc_ready;

    // Transform screen coordinates to mathematical space
    viewport_transformer viewport_transformer(.h(i), .v(j), .scale(scale), .x(x), .y(y));
    
    // Calculate Julia set values for current coordinate
    pixel_calculator pixel_calculator(.clk(clk), .rst(rst), .x(x), .y(y), .c(c), 
                                    .frame_ready(frame_ready), .pixel_brightness(pixel_brightness), 
                                    .calc_ready(calc_ready));

    // Frame buffer control signals
    wire mem_write = ~frame_ready;  // Enable writing during calculation
    wire mem_read = frame_ready;    // Enable reading during display
    wire [19:0] write_addr = i + j * 1280;        // Calculate buffer write position
    wire [19:0] read_addr = i_x + i_y * 1280;  // Calculate buffer read position
    wire [3:0] dout;

    // Coordinate update and frame completion logic
    always @(posedge clk or posedge rst) begin
        if (rst || start_frame) begin
            // Reset coordinates and status
            i <= 0;
            j <= 0;
            frame_ready <= 0;
        end else if (!frame_ready && calc_ready) begin
            // Update pixel position or complete frame
            if (i == 1279 && j == 719) begin
                frame_ready <= 1;  // Frame calculation complete
            end else if (i == 1279) begin
                j <= j + 1;        // Move to next row
                i <= 0;
            end else begin
                i <= i + 1;        // Move to next column
            end
        end
    end

    // Dual-port frame buffer for concurrent read/write operations
    blk_mem_gen_0 inst_0(
        // Write port configuration
        .clka(clk),
        .ena(1'b1),
        .wea(mem_write),
        .addra(write_addr),
        .dina(pixel_brightness),
        .douta(dout),

        // Read port configuration
        .clkb(clk),
        .enb(mem_read),
        .web(1'b0),
        .addrb(read_addr),
        .dinb(4'd0),
        .doutb(oled)
        );

endmodule