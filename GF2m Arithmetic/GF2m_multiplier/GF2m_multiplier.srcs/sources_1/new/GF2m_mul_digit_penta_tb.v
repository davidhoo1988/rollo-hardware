`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2019 06:30:20 PM
// Design Name: 
// Module Name: GF2m_mul_digit_penta_tb
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


module GF2m_mul_digit_penta_tb;

parameter WIDTH = 67;
parameter k3 = 5, k2 = 2, k1 = 1;
parameter d = 16;

reg clk, rst_b, start;
reg [WIDTH-1:0] op_a, op_b;
wire done;
wire [WIDTH-1:0] op_c;

GF2m_mul_digit_penta DUT(
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
defparam DUT.d = d;

initial
    begin
      rst_b = 1'b0;
      start = 1'b0;
      # 50;
      rst_b <= 1'b1;
      # 100;
      start <= 1'b1;
      //start_time <= $time;
      op_a <= {67'b0001101011001101010011111011000101010100111111101100010010100000110}; //be careful, op_a, op_b, op_c use lsb-first notation
      op_b <= {67'b0110111001100011011110010111010110011110011101110010010001100001101};
      # 10;
      start <= 1'b0;

      //@(posedge done);
      //$display("\nruntime: %0d cycles\n", ($time - start_time)/10);

      # 1000;
      start <= 1'b1;
      op_a <= {67'b0010001100010110010101110100100001010011101101101010010101000001001};
      op_b <= {67'b0000010010000011010101011000001000100011010011101011111011001111011};
      # 10;
      start <= 1'b0;

      # 1000;
      start <= 1'b1;
      op_a <= {67'b1111110001010010000101101111110111101100001011011110011010010010111};
      op_b <= {67'b1001001001100010110100000001100101011001111011100001010110110000101};
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
