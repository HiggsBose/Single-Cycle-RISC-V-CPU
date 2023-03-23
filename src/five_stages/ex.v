`include "src/dp_components/alu.v"
`include "src/dp_components/pc_ex.v"
`include "src/dp_components/op_sel.v"

module EX (
    input[3:0] alu_type,
    input alu_src1, alu_src2,
    input[31:0] pc, imm, rs1_data, rs2_data,

    input[2:0] branch_type,
    input branch, jal, jalr,

    output[31:0] alu_result,
    output pc_src,
    
    output[31:0] new_pc
);
    wire zero, less_than;
    wire[31:0] op1, op2;

    PCExecute pc_execute(
        .branch(branch),
        .jal(jal),
        .jalr(jalr),
        .branch_type(branch_type),
        .rs1_data(rs1_data),
        .imm(imm),
        .zero(zero),
        .less_than(less_than),
        .pc(pc),
        .pc_src(pc_src),
        .new_pc(new_pc)
    );

    OpSelector op_selector(
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .pc(pc),
        .imm(imm),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .op1(op1),
        .op2(op2)
    );

    ALU alu(
        .alu_type(alu_type),
        .op1(op1),
        .op2(op2),
        .alu_result(alu_result),
        .zero(zero),
        .less_than(less_than)
    );
endmodule
