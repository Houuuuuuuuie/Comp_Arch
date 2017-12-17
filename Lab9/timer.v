module timer(TimerInterrupt, TimerAddress, cycle,
             address, data, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt, TimerAddress;
    output [31:0] cycle;
    input  [31:0] address, data;
    input         MemRead, MemWrite, clock, reset;
	wire   [31:0] cycle_q, cycle_d, inter_q;
	wire [31:0] t0 = 32'hffff001c;
	wire [31:0] t1 = 32'hffff006c;
    wire timeWrite, timeRead, acknowledge;


    // complete the timer circuit here
    register cycle_counter(cycle_q, cycle_d, clock, 1'd1, reset);
    alu32 alu1(cycle_d, , , `ALU_ADD, cycle_q, 32'd1);
    register #(, 32'hffffffff) interrupt_cycle(inter_q, data, clock, timeWrite, reset);
    register #(1, ) interupt_line(TimerInterrupt, 1, clock, (cycle_q == inter_q), reset | acknowledge);
    tristate trid(cycle, cycle_q, timeRead);
	
    assign timeWrite = (t0 == address) & MemWrite;
    assign timeRead = (t0 == address) & MemRead;
    assign acknowledge = (t1 == address) & MemWrite;
    assign TimerAddress = (t0 == address) | (t1 == address);
    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
