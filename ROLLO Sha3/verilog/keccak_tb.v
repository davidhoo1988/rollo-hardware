`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2020 03:10:58 PM
// Design Name: 
// Module Name: keccak_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module keccak_tb(
    );

//inputs
reg clk = 1'b0;
reg start = 1'b0;
reg rst_b = 1'b0;

//outputs
wire done;
wire [`M-1:0] dout;

//simulation root is located at ......rollo-sha3-512.sim/sim_1/behav/modelsim
keccak #( .n(`N), .m(`M), .r(`R), .d(`D), .digit(`DIGIT), .FILE_E("../../../../../verilog/mem_E.txt") ) DUT(
.clk(clk), 
.rst_b(rst_b),
.in_ready(start),

.out_usr(),
.out_ready(done)
);

integer i;

integer start_time;
integer end_time;

integer scan_file;

initial
    begin
    	rst_b = 0;
    	# 10;
    	rst_b = 1;
    # 10;
       
    // run DUT
    @(negedge clk);
    $display("starting computation\n"); 
    
    start = 1'b1;
    start_time = $time;
    # 10;
    start = 1'b0;

    @(negedge done);
    end_time = $time;
    $display("runtime: %0d cycles\n", (end_time - start_time)/10);
    $writememb("../../../../../verilog/mem_E.txt", DUT.mem_E.mem);
    end

always 
#5 clk =  ! clk; 

endmodule
