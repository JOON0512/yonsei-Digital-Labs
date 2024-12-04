Implemented Julia Set Visualization on PYNQ-Z2 FPGA

Objective: Developed a system to calculate and display Julia sets, a type of fractal, on an LCD using the PYNQ-Z2 FPGA.

Approach:
Designed and implemented a pipeline consisting of multiple Verilog modules, including a viewport transformer for mapping screen coordinates to the complex plane, a pixel calculator for iterative fractal computations, and BRAM-based buffering for efficient data storage and retrieval.

Utilized Q15.16 fixed-point arithmetic to maintain precision during complex number operations, handled by a custom multiplier module.

Leveraged a modular and parallel design to optimize pixel computation across high-resolution displays (1280x720).

Features:
Rendered fractals in grayscale with brightness levels determined by the number of iterations before divergence.
Enabled user control to modify fractal parameters and zoom levels via hardware buttons.
Implemented memory-efficient data handling with True Dual-Port BRAM, supporting simultaneous read and write operations for seamless updates.

Outcome: Successfully generated Julia sets with interactive zooming and parameter adjustments, demonstrating the fractal's self-similarity properties on an FPGA-based system.
