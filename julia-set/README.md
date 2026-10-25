# Julia set HDL

Restored from the author's submitted Vivado project. The `rtl` directory contains the source modules, `constraints` the board pins, and `ip` the Xilinx Block Memory Generator configuration. Generated IP implementation files, bitstreams and machine-specific project state are regenerated locally.

With Vivado 2020.2 and the PYNQ-Z2 board (xc7z020clg400-1):

```sh
vivado -mode batch -source create_project.tcl
```

This creates a project in `build/`; it does not automatically program a board. The original top module is `HDMI_TOP`.

With Icarus Verilog 12 and vvp, run `sh tests/run.sh`. On 2026-10-25, six fixed-point multiplier cases and three viewport-coordinate cases passed; `pixel_calculator` also elaborated. These checks cover arithmetic units only. Full-frame timing, BRAM behavior, display output, button operation and FPGA synthesis have not been revalidated.
