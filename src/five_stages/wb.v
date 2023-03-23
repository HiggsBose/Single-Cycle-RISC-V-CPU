`include "src/defines.v"

module WB (
    input[1:0] reg_src,
    input[31:0] pc_plus4, imm, alu_result, mem2reg_data,
    output reg [31:0] reg_write_data
);
    always @(*) begin
        case(reg_src) 
            `FROM_ALU: reg_write_data = alu_result;
            `FROM_IMM: reg_write_data = imm;
            `FROM_MEM: reg_write_data = mem2reg_data;
            `FROM_PC:  reg_write_data = pc_plus4;
            default:   reg_write_data = 32'h00000000;
        endcase
    end
    
endmodule