`timescale 1ns / 100ps
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

module prng_tb(
    );

//inputs
reg clk = 1'b0;
reg start = 1'b0;
reg rst_b = 1'b0;
reg [95:0] in_seed = 96'b0;
reg in_mod = 1'b0;

//outputs
wire done;
wire [95:0] dout;

//simulation root is located at ......rollo-sha3-512.sim/sim_1/behav/modelsim
prng #( .n(`N), .m(`M), .r(`R), .d(`D), .digit(`DIGIT)) DUT(
.clk(clk), 
.rst_b(rst_b),
.in_seed(in_seed),
.in_mod(in_mod),
.in_ready(start),

.out_rng(dout),
.out_ready(done)
);

integer i;

integer start_time;
integer end_time;

integer scan_file;

initial begin
    	rst_b = 0;
    	# 10;
    	rst_b = 1;
    # 10;
       
    // run DUT
    @(negedge clk);
    $display("starting computation\n"); 
    
    start = 1'b1;
    in_seed = 32'hffffffff;
    in_mod = 1'b1; //update seed
    start_time = $time;
    # 10;
    start = 1'b0;
    in_mod = 1'b0;
end

always @(negedge done) begin
    if (rst_b) begin
        end_time = $time;
        $display("runtime: %0d cycles\n", (end_time - start_time)/10);

        start  = 1'b1;
        in_mod = 1'b0;
        start_time = $time;
        # 10;
        start = 1'b0;
    end
end


always 
#5 clk =  ! clk; 

endmodule
