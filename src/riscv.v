`include "src/five_stages/if.v"
`include "src/five_stages/id.v"
`include "src/five_stages/ex.v"
`include "src/five_stages/mem.v"
`include "src/five_stages/wb.v"

module RISCVSingleSycle (
    input clk, rst,
    input [31:0] instr, mem_read_data,
    output ram_write,
    output [2:0] write_type,
    output [31:0] instr_addr, mem_addr, mem_write_data
);
    wire [31:0] pc_plus4, imm, alu_result, mem2reg_data, reg_write_data, pc, rs1_data, rs2_data, new_pc;
    wire [2:0] load_type, store_type, branch_type;
    wire [3:0] alu_type;
    wire [1:0] reg_src;

    IF instruction_fetch(
        .clk(clk),
        .rst(rst),
        .new_pc(new_pc),
        .pc_src(pc_src),

        .pc_plus4(pc_plus4),
        .pc(pc)
    );

    ID instruction_decode(
        .instr(instr),
        .clk(clk),
        .reg_write_data(reg_write_data),
        .branch(branch),
        .jal(jal),
        .jalr(jalr),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .alu_type(alu_type),
        .imm(imm),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .reg_src(reg_src),
        .branch_type(branch_type),
        .store_type(store_type),
        .load_type(load_type),
        .reg_write_enable(reg_write_enable)
    );

    EX execution(
        .alu_type(alu_type),
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .pc(pc),
        .imm(imm),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .branch_type(branch_type),
        .branch(branch),
        .jal(jal),
        .jalr(jalr),
        .alu_result(alu_result),
        .pc_src(pc_src),
        .new_pc(new_pc)
    );
    
    MEM_MODULE memory_part(
        .mem_read(mem_read),
        .load_type(load_type),
        .mem_read_data(mem_read_data),
        .mem2reg_data(mem2reg_data)
    );

    WB write_back(
        .reg_src(reg_src),
        .pc_plus4(pc_plus4),
        .imm(imm),
        .alu_result(alu_result),
        .mem2reg_data(mem2reg_data),
        .reg_write_data(reg_write_data)
    );

    assign instr_addr = pc;
    assign mem_addr = alu_result;
    assign mem_write_data = rs2_data;
    assign ram_write = mem_write;
    assign write_type = store_type;



endmodule