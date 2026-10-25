# Julia set on FPGA

A Julia-set renderer for the PYNQ-Z2, built in Verilog for a digital-design course.

The renderer maps screen coordinates to the complex plane, computes iterations in Q15.16 fixed point, and buffers pixels in dual-port BRAM. Buttons control zoom and fractal parameters; iteration counts determine grayscale intensity.

https://github.com/user-attachments/assets/0f636574-7286-41fd-9a38-38ded74be2ca

## Build

Requires Vivado 2020.2 and a PYNQ-Z2 (`xc7z020clg400-1`).

```sh
cd julia-set
vivado -mode batch -source create_project.tcl
```

This creates the project in `julia-set/build/`. See [HDL and simulation notes](julia-set) for the source layout and arithmetic tests. Synthesis and board operation have not been rerun on this checkout.
