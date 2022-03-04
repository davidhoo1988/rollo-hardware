`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2019 19:16:01
// Design Name: 
// Module Name: GF2m_mul_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: testbench for bit-level interleaved multiplication
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GF2m_mul_tb;

parameter WIDTH = 97;
parameter k = 6;

reg clk, rst_b, start;
reg [WIDTH-1:0] op_a, op_b;
wire done;
wire [WIDTH-1:0] op_c;

GF2m_mul DUT(
	.clk(clk),
    .rst_b(rst_b), 
    .start(start),
    .done(done),
    .op_a(op_a),
    .op_b(op_b),
    .op_c(op_c)
  );
defparam DUT.WIDTH = WIDTH;
defparam DUT.k = k;

initial
    begin
      rst_b = 1'b0;
      start = 1'b0;
      # 50;
      rst_b <= 1'b1;
      # 100;
      start <= 1'b1;
      //start_time <= $time;
      op_a <= {'b1100001101001100000001001001000011110000011001100101110011001101101111111111011111111100001111001};
      op_b <= {'b1111011101110010110110110010011110001010010011101011101110010111110011001011001010011111100110011};
      # 10;
      start <= 1'b0;

      //@(posedge done);
      //$display("\nruntime: %0d cycles\n", ($time - start_time)/10);

      # 1000;
      start <= 1'b1;
      op_a <= {'b1110010100111000110110110001110110110001010110100110101001110100110111010011111011000000000001010};
      op_b <= {'b1010101101101101110100101111000011010101101101010001001110011000101111110111000011010100101011111};
      # 10;
      start <= 1'b0;

      # 1000;
      start <= 1'b1;
      op_a <= {'b1001010011101001110000010110000010001010001001101100011100110111111011000111000110011001000001101};
      op_b <= {'b1100100001001001011100000000011110001110001001110111000011000001000101110100001001101110110010100};
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
