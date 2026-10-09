
# 32-bit Single-Cycle RISC-V Processor

## Overview

This project implements a 32-bit single-cycle RISC-V processor using Verilog HDL. It includes instruction decoding, arithmetic and logical operations, branching, jumps, and byte-addressable data memory.

The design is simulated using Icarus Verilog, with testbenches used to verify the processor and its components.

## Features

- 32-bit program counter and datapath
- 32 general-purpose registers (`x0`–`x31`)
- Instruction memory with 256 32-bit instruction words
- Data memory with 1024 bytes
- Arithmetic and logical operations
- Immediate arithmetic and shift operations
- Conditional branches
- Unconditional jumps
- Load and store operations
- Little-endian data memory
- Verilog testbenches for verification

## Supported Instructions

### R-type
ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND

### I-type arithmetic
ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI

### Loads
LB, LH, LW, LBU, LHU

### Stores
SB, SH, SW

### Branches
BEQ, BNE, BLT, BGE, BLTU, BGEU

### U-type
LUI, AUIPC

### Jumps
JAL, JALR

## Project Structure

- `riscv_cpu.v` — main processor implementation
- `riscv_cpu_tb.v` — combined processor testbench
- `tests/` — individual instruction testbenches
- `alu.v`, `alu_tb.v` — ALU and its testbench
- `register_file.v`, `register_file_tb.v` — register file and its testbench
- `pc.v`, `pc_tb.v` — program counter and its testbench
- `immediate_gen.v`, `immediate_gen_tb.v` — immediate generator and its testbench
- `mux.v`, `mux32.v`, `mux_tb.v` — multiplexer modules
- `and_gate.v`, `and_gate_tb.v` — AND gate and its testbench
- `.gitignore` — excludes generated simulation outputs

## Requirements

- Icarus Verilog
- A terminal or command prompt
- Git (optional, for version control)

## Run the Combined Testbench

Compile the design:

```powershell
iverilog -g2012 -o combined_test riscv_cpu.v riscv_cpu_tb.v
```

Run the simulation:

```powershell
vvp combined_test
```

The testbench reports PASS or FAIL for each instruction group and prints a final summary.

## Current Verification

The combined testbench currently passes seven test groups:

1. R-type instructions
2. I-type arithmetic and shifts
3. U-type instructions
4. Conditional branches
5. JAL and JALR
6. SB, SH, and SW
7. Byte and halfword loads

Further testing is needed to establish complete correctness for every instruction and edge case.

## Limitations

- The design is a simplified educational processor.
- It does not implement interrupts, exceptions, or a complete privileged architecture.
- Invalid instruction encodings are not handled as architectural traps.
- The current verification suite does not exhaustively test every instruction and boundary condition.

## Author

Millend Manhas
