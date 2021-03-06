// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;
    wire [31:0] inst;  
    wire [31:0] PC;  
    wire [31:0] pcp4off;
    wire [31:0] pcp4;
    wire [31:0] nextPC;  
    wire [31:0] rsData;  
    wire [31:0] rtData;  
    wire [31:0] rdData;
    wire [31:0] out;  
    wire [31:0] imm32 = {{16{inst[15]}}, inst[15:0]};   
    wire [31:0] branch_offset = {{14{inst[15]}}, inst[15:0], 2'b0};  
    wire [31:0] B; 
    wire [31:0] slt_out; 
    wire [31:0] lui_out; 
    wire [31:0] mem_out; 
    wire [31:0] byte_out; 
    wire [31:0] data_out;
    wire [31:0] zero32 = 32'b0; 
    wire [31:0] lui1 = {inst[15:0], zero32[15:0]}; 
    wire [31:0] slt_right = {zero32[31:1], (negative & ~overflow) | (~negative & overflow)}; 
    wire [31:0] read_data_select;
    wire [31:0] addm_o2;
    wire [31:0] m_rs_p_rt;
    wire [7:0] byte4out;
    wire [4:0] rdNum; 
    wire [2:0] alu_op; 
    wire [1:0] ctrl_type; 
    wire writeenable;
    wire alu_src2, rd_src, negative, zero, slt, lui, addm, byte_we, word_we, mem_read, overflow, byte_load;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData,
                inst[25:21], inst[20:16], rdNum, rdData, 
                writeenable, clock, reset);

    /* add other modules */

    mux2v low_ALU(B, rtData, imm32, alu_src2); // low input of main ALU
    
    mux2v #(5) m2(rdNum, inst[15:11], inst[20:16], rd_src);
    
    mux2v sltm(slt_out, out, slt_right, slt);
    
    mux2v luim(lui_out, mem_out, lui1, lui);
    
    mux2v memm(mem_out, slt_out, byte_out, mem_read);
    
    mux2v btm(byte_out, data_out, {zero32[23:0], byte4out}, byte_load);
    
    mux2v select_read_out_or_rsdata(read_data_select, out, rsData, addm);
    mux2v addm2(rdData, lui_out, m_rs_p_rt, addm);

    mux4v control_jump(nextPC, pcp4, pcp4off, {PC[31:28], inst[25:0], 2'b0}, rsData, ctrl_type);
    mux4v #(8) bytem4(byte4out, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);

    alu32 p4_alu(pcp4, , , , PC, 32'h04, `ALU_ADD);
    alu32 main_alu(out, overflow, zero, negative, rsData, B, alu_op);
    alu32 poff_alu(pcp4off, , , , pcp4, branch_offset, `ALU_ADD);
    alu32 addmmmm_alu(m_rs_p_rt, , , , byte_out, rtData, `ALU_ADD);

    data_mem data(data_out, read_data_select, rtData, word_we, byte_we, clock, reset);
    mips_decode mmm1(alu_op, writeenable, rd_src, alu_src2, except, ctrl_type, mem_read, word_we, byte_we, byte_load, lui, slt, addm, inst[31:26], inst[5:0], zero);
   

endmodule // full_machine
