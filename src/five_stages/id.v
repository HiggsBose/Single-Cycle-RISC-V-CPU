`include "src/dp_components/regfile.v"
`include "src/dp_components/imm_gen.v"
`include "src/cp_components/control_unit.v"
`include "src/cp_components/alu_control.v"

module ID (
    input[31:0] instr,
    input clk,
    input[31:0] reg_write_data,

    output reg branch,
    output reg jal,
    output reg jalr,
    output reg mem_read,
    output reg mem_write,
    
    output wire alu_src1, alu_src2,
    output reg[3:0] alu_type,
    output reg[31:0] imm, rs1_data, rs2_data,

    output reg[1:0] reg_src,

    output reg[2:0] branch_type,
    output reg[2:0] store_type,
    output reg[2:0] load_type,

    output reg reg_write_enable

);
    wire[4:0] read_addr1, read_addr2, write_addr;
    wire[31:0] immediate, rs1_data_w, rs2_data_w;
    wire branch_w, jal_w, jalr_w, mem_read_w, mem_write_w;
    wire[3:0] alu_type_w;
    wire[1:0] reg_src_w;

    wire[2:0] branch_type_w;
    wire[2:0] store_type_w;
    wire[2:0] load_type_w;

    wire reg_write_enable_w;

    ImmGen imm_gen(
        .instr(instr),
        .imm(immediate)
    );

    ControlUnit control_unit(
        .instr(instr),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .branch(branch_w),
        .jal(jal_w),
        .jalr(jalr_w),
        .mem_read(mem_read_w),
        .mem_write(mem_write_w),
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .alu_type(alu_type_w),
        .reg_src(reg_src_w),
        .branch_type(branch_type_w),
        .store_type(store_type_w),
        .load_type(load_type_w),
        .reg_write_enable(reg_write_enable_w)
    );

    RegFile register_file(
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(reg_write_data),
        .clk(clk),
        .write_enable(reg_write_enable),
        .read_data1(rs1_data_w),
        .read_data2(rs2_data_w)
    );

    always @(*) begin
        imm = immediate;
        branch = branch_w;
        jal = jal_w;
        jalr = jalr_w;
        mem_read = mem_read_w;
        mem_write = mem_write_w;
        alu_type = alu_type_w;
        reg_src = reg_src_w;
        branch_type = branch_type_w;
        load_type = load_type_w;
        store_type = store_type_w;
        reg_write_enable = reg_write_enable_w;
        rs1_data = rs1_data_w;
        rs2_data = rs2_data_w;
    end

endmodule