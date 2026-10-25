`timescale 1ns/1ps
module tb_arithmetic;
    reg signed [31:0] a,b;
    wire signed [31:0] val;
    reg [10:0] h;
    reg [9:0] v;
    reg [2:0] scale;
    wire signed [31:0] x,y;
    mul multiplier(a,b,val);
    viewport_transformer viewport(h,v,scale,x,y);
    task check_mul;
        input signed [31:0] lhs,rhs,expected;
        begin a=lhs;b=rhs;#1;if(val!==expected)$fatal(1,"fixed-point multiply mismatch");end
    endtask
    initial begin
        check_mul(0,65536,0);
        check_mul(65536,65536,65536);
        check_mul(-65536,65536,-65536);
        check_mul(32768,32768,16384);
        check_mul(-98304,131072,-196608);
        check_mul(65536,1,1);
        scale=1;h=0;v=0;#1;
        if(x!==-65536 || y!==36864)$fatal(1,"top-left viewport coordinate mismatch");
        h=640;v=360;#1;
        // Center should be near zero; integer step quantization is bounded.
        if(x < -640 || x > 640 || y < -360 || y > 360)$fatal(1,"viewport center outside quantization bound");
        scale=2;h=0;v=0;#1;
        if(x!==-131072 || y!==73728)$fatal(1,"zoomed viewport boundary mismatch");
        $display("PASS: 6 fixed-point multiplication cases and 3 viewport checks");
        $finish;
    end
endmodule
