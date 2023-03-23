`include "src/defines.v"

module MEM_MODULE (
    input mem_read,
    input[2:0] load_type,
    input[31:0] mem_read_data,

    output reg[31:0] mem2reg_data

);
    always @(*) begin
        if(mem_read) begin
            case (load_type)
                `LW     :   mem2reg_data = mem_read_data;
                `LB     :   mem2reg_data = {{24{mem_read_data[7]}}, mem_read_data[7:0]};
                `LBU    :   mem2reg_data = {24'b0, mem_read_data[7:0]};
                `LH     :   mem2reg_data = {{16{mem_read_data[15]}}, mem_read_data[15:0]};
                `LHU    :   mem2reg_data = {16'b0, mem_read_data[15:0]};
                default :   mem2reg_data = 32'b0;    
            endcase
        end
    end

    
endmodule