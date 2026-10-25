module viewport_transformer(
    input wire [10:0] h,
    input wire [9:0] v,
    input wire [2:0] scale,
    output wire signed [31:0] x,
    output wire signed [31:0] y
);

    // Calculate viewport boundaries and scaling coefficients
    wire signed [31:0] viewport_x_min   = ~((scale) << 16) + 1;
    wire signed [31:0] viewport_y_max   =  (9 * (scale) << 12);
    wire signed [31:0] viewport_x_scale =  (scale << 17) / 1280;
    wire signed [31:0] viewport_y_scale =  (9 * (scale << 13) / 720);

    // Convert screen coordinates to fixed-point format
    wire signed [31:0] viewport_h_fixed = h << 16;
    wire signed [31:0] viewport_v_fixed = v << 16;

    // Calculate scaled coordinate offsets
    wire signed [31:0] viewport_x_shift, viewport_y_shift;

    // Perform scaling multiplication
    mul mul_viewport_x (.a(viewport_h_fixed), .b(viewport_x_scale), .val(viewport_x_shift));
    mul mul_viewport_y (.a(viewport_v_fixed), .b(viewport_y_scale), .val(viewport_y_shift));

    // Transform to final coordinate space
    assign x = viewport_x_min + viewport_x_shift;
    assign y = viewport_y_max - viewport_y_shift;

endmodule
