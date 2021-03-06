// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
	wire [31:0] nextPC;
	wire [31:0] rsData;
	wire [31:0] rtData;
	wire [31:0] rdData;
	wire [31:0] imm32 = {{16{inst[15]}},inst[15:0]};
	wire [31:0] B;
	wire [4:0] rdNum;
	wire [2:0] alu_op;
	wire RDWE;
	wire alu_src2, rd_src;
	
	
	
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC,nextPC,clock,1,reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst,PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData,rtData,inst[25:21],inst[20:16],rdNum,rdData,RDWE,clock,reset);

    mux2v mx(B,rtData,imm32,alu_src2);
    mux2v #(5) mm(rdNum,inst[15:11],inst[20:16],rd_src);
    alu32 a1(nextPC,,,,PC,32'h04,`ALU_ADD);
    alu32 a2(rdData,,,,rsData,B,alu_op);
    mips_decode md(alu_op,RDWE,rd_src,alu_src2,except,inst[31:26],inst[5:0]);
    
    
   
endmodule // arith_machine
