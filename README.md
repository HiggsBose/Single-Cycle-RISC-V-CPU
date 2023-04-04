# Single Cycle RISC-V CPU
A single cycle RISC-V CPU based on RV32I Instruction Set, implemented in Verilog.

## Testbench

Instructions of nearly all RV32I instructions are provided in our testbench as single instruction tests, and we also provide two multiple instruction tasks (matrix multiplication and quick sort). You can browse ./test_code to see the testing instructions and their reference output. 

To run the code, you can run the ./tb/tb_single_cycle.v

* change the definition of TEST_TYPE from 0 to 8 in testbench to run deifferent tests, TEST_TYPE 7 and 8 are multiple instruction test
* results are stored in newly built .txt files after running the tb, you can compare it with the reference output in each test case.

## RISC Core Architecture

The RISC Core can be divided in 5 parts: Instruction Fetch(IF), Instruction Decode(ID), Exexution(EX), Memory Access(MEM), and Write Back(WB), as is the same as 5-stage pipelined CPU.



* In IF stage, the CPU fetches one instruction from the instruction memory according to the address provided by the program counter(PC), and send it to the next stage.
* In ID stage, the CPU decodes the instruction and generates corresponding control signals to send to different stages. The control signals are ALU signals(including ALU operands source, ALU operation type, and etc.)
* In EX stage, the ALU computes the result of the instrcution, and determine whether pc_execute should generate a new PC address.
* In MEM stage, the result are stored in the Main Memory or the data is loaded from it.
* In WB stage, the data is written back to the register files.
