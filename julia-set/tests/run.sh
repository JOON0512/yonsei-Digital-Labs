#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
mkdir -p build
iverilog -g2012 -s tb_arithmetic -o build/arithmetic tests/tb_arithmetic.v rtl/mul.v rtl/viewport_transformer.v
vvp build/arithmetic
iverilog -g2012 -s pixel_calculator -o build/pixel-syntax rtl/mul.v rtl/pixel_calculator.v
echo 'PASS: pixel calculator elaboration (no board or vendor-IP simulation)'
