# ADVANCED-VLSI-SYSTEM-DESIGN 
NCKU EE graduated level (2024)

## Lab1- 5 stage RISV-V CPU
RV32IMF with CSR instruction (49 instrustion RISBUJF type)

## Lab2- CPU + AXI design
A simplified Advanced eXtensible Interface (AXI) with 2 masters and 2 slaves, combining the CPU, IM, DM and the AXI to form a mini system and synthesize them.

## Lab3- CPU + AXI + DRAM + WDT + ROM + DMA design
There are 4 new IPs that  be implemented, the DRAM Wrapper, WDT, ROM Wrapper and DMA. 
The WDT is clocked by 2 separate clock domain, 
so you need to debug CDC issues with Spyglass.

## Lab4- A multi-clock domain system with L1 cache
In this assignment, your responsibility includes completing the CPU design,
incorporating instruction and data cache elements, addressing AXI clock domain
crossing challenges with various memory or IP components, and executing automatic
place and route (APR).

