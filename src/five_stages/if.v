`include "src/dp_components/pc.v"
`include "src/dp_components/add.v"


module IF (
    input clk, rst,
    input [31:0] new_pc,
    input pc_src,
    output wire[31:0] pc_plus4,
    output [31:0]pc
);
    
    PC program_counter(
        .clk(clk),
        .rst(rst),
        .pc_plus4(pc_plus4),
        .new_pc(new_pc),
        .pc_src(pc_src),
        .pc(pc)
    );

    ADD adder(
        .pc(pc),
        .pc_plus4(pc_plus4)
    );

endmodule