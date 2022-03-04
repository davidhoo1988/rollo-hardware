`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2019 06:50:19 PM
// Design Name: 
// Module Name: GF2m_mul_penta_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//        testbench for bit-level interleaved multiplication (specific to pentanomial)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GF2m_mul_penta_tb;

parameter WIDTH = 83;
parameter k3 = 7;
parameter k2 = 4;
parameter k1 = 2;

reg clk, rst_b, start;
reg [WIDTH-1:0] op_a, op_b;
wire done;
wire [WIDTH-1:0] op_c;

GF2m_mul_penta DUT(
	.clk(clk),
    .rst_b(rst_b), 
    .start(start),
    .done(done),
    .op_a(op_a),
    .op_b(op_b),
    .op_c(op_c)
  );
defparam DUT.WIDTH = WIDTH;
defparam DUT.k3 = k3;
defparam DUT.k2 = k2;
defparam DUT.k1 = k1;

initial
    begin
      rst_b = 1'b0;
      start = 1'b0;
      # 50;
      rst_b <= 1'b1;
      # 100;
      start <= 1'b1;
      //start_time <= $time;
      op_a <= {'b10000001001001000011110000011001100101110011001101101111111111011111111100001111001};
      op_b <= {'b10111100010100100111010111011100101111100110010110010100111111001100111110000110100};
      # 10;
      start <= 1'b0;

      //@(posedge done);
      //$display("\nruntime: %0d cycles\n", ($time - start_time)/10);

      # 1000;
      start <= 1'b1;
      op_a <= {'b11011010011010100111010011011101001111101100000000000101011111011101110010110110110};
      op_b <= {'b11110011000101111110111000011010100101011111111100101001110001101101100011101101100};
      # 10;
      start <= 1'b0;

      # 1000;
      start <= 1'b1;
      op_a <= {'b10110001110001100110010000011011100101011011011011101001011110000110101011011010100};
      op_b <= {'b10111011001010001000010100111010011100000101100000100010100010011011000111001101111};
      # 10;
      start <= 1'b0;

      # 1000;

      $finish;
    end

always
	begin
	  clk = 1'b1;
	  #5;
	  clk = 1'b0;
	  #5;
	end

endmodule
