`include "src/defines.v"

module ControlUnit (
    input [31:0] instr,
    output reg[4:0] read_addr1,
    output reg[4:0] read_addr2,
    output reg[4:0] write_addr,

    output reg branch,
    output reg jal,
    output reg jalr,
    output reg mem_read,
    output reg mem_write,
    
    output reg alu_src1, alu_src2,
    output reg[3:0] alu_type,
    output reg[1:0] reg_src,

    output reg[2:0] branch_type,
    output reg[2:0] store_type,
    output reg[2:0] load_type,

    output reg reg_write_enable
);
    
    always @(*) begin
        branch_type = instr[14:12];
        store_type  = instr[14:12];
        load_type   = instr[14:12];
        read_addr1  = instr[19:15];
        read_addr2  = instr[24:20];
        write_addr  = instr[11:7];
        case (instr[6:0])
            `INST_TYPE_R:begin
                branch = 1'b0;
                jal = 0;
                jalr = 0;
                mem_read = 0;
                mem_write = 0;
                alu_src1 = `REG;   // 1 for visiting register_file
                alu_src2 = `REG;
                alu_type = {instr[30],instr[14:12]};
                reg_src = `FROM_ALU;// from alu 
                reg_write_enable = 1'b1;
            end
            `INST_TYPE_S:begin
                branch = 0;
                jal = 0;
                jalr = 0;
                mem_read = 0;
                mem_write = 1;
                alu_src1 = `REG; // from register_file
                alu_src2 = `IMM; // from imm number
                alu_type = `ADD;
                reg_src = `NO_W;    // no register write 
                reg_write_enable = 0;
            end
            `INST_TYPE_L:begin
                branch = 0;
                jal = 0;
                jalr = 0;
                mem_read = 1'b1;
                mem_write = 0;
                alu_src1 = `REG; // from register file
                alu_src2 = `IMM; // from immediate number
                alu_type = `ADD;
                reg_src = `FROM_MEM; // from memory
                reg_write_enable = 1'b1;
            end
            `INST_TYPE_B:begin
                branch = 1'b1;
                jal = 0;
                jalr = 0;
                mem_read = 0;
                mem_write = 0;
                alu_src1 = `REG;
                alu_src2 = `REG;
                case (branch_type)
                    `BEQ, `BNE      :     alu_type = `SUB;
                    `BLT, `BGE      :     alu_type = `SLT;
                    `BLTU, `BGEU    :     alu_type = `SLTU; 
                    default         :     alu_type = `ADD; 
                endcase
                reg_src = `NO_W;
                reg_write_enable = 0;
            end
            `INST_TYPE_I:begin
                branch = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_src1 = `REG;
                alu_src2 = `IMM;
                if(instr[13:12]==2'b01) alu_type = {instr[30],instr[14:12]}; // for shift, alu_type is the same as R_type
                else alu_type = {1'b0,instr[14:12]}; // for other I type, alu_type should starts with 0   
                reg_src = `FROM_ALU;
                reg_write_enable = 1'b1;
            end
            `INST_LUI:begin
                branch = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_src1 = `REG;    // not sure
                alu_src2 = `REG;    // not sure
                alu_type = `ADD;    //not sure
                reg_src = `FROM_IMM;
                reg_write_enable = 1;
            end
            `INST_AUIPC:begin
                branch = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_src1 = `PC;
                alu_src2 = `IMM;
                alu_type = `ADD;
                reg_src = `FROM_ALU;
                reg_write_enable = 1;
            end
            `INST_JAL:begin
                branch = 1'b0;
                jal = 1'b1;
                jalr = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_src1 = `PC;  
                alu_src2 = `IMM;   
                alu_type = `ADD;
                reg_src = `FROM_PC; // to store pc as the return address
                reg_write_enable = 1;
            end
            `INST_JALR:begin
                branch = 1'b0;
                jal = 1'b0;
                jalr = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_src1 = `REG;
                alu_src2 = `IMM;
                alu_type = `ADD;
                reg_src = `FROM_PC;
                reg_write_enable = 1;
            end
            default:begin
                branch = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_src1 = `REG;   // not sure
                alu_src2 = `REG;   // not sure
                alu_type = `ADD;    //not sure
                reg_src = `NO_W;
                reg_write_enable = 0;
            end
        endcase
    end
endmodule