# Single Cycle RISC-V CPU
A single cycle RISC-V CPU based on RV32I Instruction Set, implemented in Verilog.

## Testbench

Instructions of nearly all RV32I instructions are provided in our testbench as single instruction tests, and we also provide two multiple instruction tasks (matrix multiplication and quick sort). You can browse ./test_code to see the testing instructions and their reference output. 

To run the code, you can run the ./tb/tb_single_cycle.v

* change the definition of TEST_TYPE from 0 to 8 in testbench to run deifferent tests, TEST_TYPE 7 and 8 are multiple instruction test
* results are stored in newly built .txt files after running the tb, you can compare it with the reference output in each test case.

## RISC Core Architecture
to be completed...
