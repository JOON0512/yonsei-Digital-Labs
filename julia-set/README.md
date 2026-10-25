# Julia set HDL

- `rtl/` — Verilog modules; top module: `HDMI_TOP`
- `constraints/` — PYNQ-Z2 pin assignments
- `ip/` — Xilinx Block Memory Generator configuration

Create the Vivado 2020.2 project for `xc7z020clg400-1`:

```sh
vivado -mode batch -source create_project.tcl
```

The project is written to `build/`. Generate the IP outputs and bitstream in Vivado before programming the board.

Arithmetic simulations require Icarus Verilog and `vvp`:

```sh
sh tests/run.sh
```

These cover the fixed-point multiplier and viewport mapping. They do not simulate a complete frame or the display hardware.
