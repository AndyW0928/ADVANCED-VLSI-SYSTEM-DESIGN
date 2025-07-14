# ADVANCED-VLSI-SYSTEM-DESIGN 
Graduate-Level Course @ NCKU EE (2024)

This repository contains lab projects and the final design for the graduate course **Advanced VLSI System Design**, focusing on RISC-V processor design, AXI-based SoC integration, memory subsystem, and real-world hardware acceleration applications.

---

## Lab1- 5 stage RISV-V CPU
Designed a 5-stage pipeline RISC-V processor (RV32IMF), supporting **49 instructions** (R/I/S/B/U/J/F/CSR types), including:
- Integer and floating-point operations  
- Control and status register (CSR) handling  
- Hazard detection, forwarding, and pipeline flush mechanisms

## Lab2- CPU + AXI design
Integrated the CPU with a simplified **AXI (Advanced eXtensible Interface)** interconnect.  
- Dual-master and dual-slave AXI bus system  
- Modules include: CPU, Instruction Memory (IM), Data Memory (DM)  
- Successfully synthesized the entire SoC system

## Lab3- CPU + AXI + DRAM + WDT + ROM + DMA design
Extended the system with additional AXI-connected IPs:
- **DRAM Wrapper**  
- **ROM Wrapper**  
- **Watchdog Timer (WDT)** – implemented with dual clock domains  
- **Direct Memory Access (DMA)** controller

Emphasized **Clock Domain Crossing (CDC)** debugging using **Synopsys Spyglass**.

## Lab4- A multi-clock domain system with L1 cache
Enhanced the design by:
- Integrating **L1 Instruction and Data Cache**  
- Handling AXI clock domain crossing for memory-mapped IPs  
- Performing full **automatic place-and-route (APR)** using standard ASIC tools


## FINAL- GNSS Anti-interference System Design based on RISC-V Architecture
Designed a real-time anti-jamming system for GPS L1 signal processing on a custom RISC-V SoC platform.  
Main contributions:
- **Real-time MVDR (Minimum Variance Distortionless Response) Beamforming**  
- Accelerated matrix operations using hardware optimization  
- Achieved **84% reduction in matrix computation time**  
- Successfully processed **8096 data points within 0.6ms**

This project combines **GNSS signal processing**, **real-time DSP acceleration**, and **hardware/software co-design** on a RISC-V platform, demonstrating the practical application of advanced VLSI techniques.

---

## Tools & Environment  
- Verilog / SystemVerilog  
- Synopsys Design Compiler / PrimeTime / IC Compiler II  
- Spyglass Lint & CDC  
- ModelSim / VCS  

---


