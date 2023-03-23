`include "src/riscv.v"
`include "src/inst_mem.v"
`include "src/mem.v"

module RISCVTop (
    input clk, rst, debug
);
    
    wire ram_write;
    wire [2:0] write_type;
    wire [31:0] instr, mem_read_data;
    wire [31:0] instr_addr, mem_addr, mem_write_data;

    RISCVSingleSycle riscv(
        .clk(clk), .rst(rst),
        .instr(instr), .mem_read_data(mem_read_data),
        .ram_write(ram_write),
        .write_type(write_type),
        .instr_addr(instr_addr), .mem_addr(mem_addr), .mem_write_data(mem_write_data)
    );

    INSTMEM instr_mem(
        .clk(clk),
        .addr(instr_addr),
        .data_out(instr)
    );

    MEM mem(
        .clk(clk), .debug(debug),
        .write_enable(ram_write),
        .write_type(write_type),
        .addr(mem_addr),
        .data_in(mem_write_data),
        .data_out(mem_read_data)
    );

endmodule