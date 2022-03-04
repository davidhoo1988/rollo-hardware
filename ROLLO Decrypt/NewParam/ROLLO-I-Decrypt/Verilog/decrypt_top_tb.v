`include "define.v"
`include "clog2.v"

`timescale 1ns / 1ps
module decrypt_top_tb;

  //inputs
  reg clk = 0;
  reg rst_b = 0;
  reg start = 0;

  //outputs  
  wire finish;
  wire [1-1:0] data;

  decrypt_top  DUT(
    .clk    (clk), 
    .rst_b  (rst_b),
    .start  (start),

    .data   (data),
    .finish  (finish)
);

 
  integer i;

  integer start_time;

  initial
    begin
      rst_b = 1'b0;
      start = 1'b0;

      # 50;
      rst_b = 1'b1;
      # 101;
      start = 1'b1;
      start_time <= $time;

      # 10;
      start = 1'b0;
      
      @(posedge finish); //DUT finished
      # 1;
      for (i = 0; i < 1; i = i+1) begin
          $display("\nruntime: %0d cycles\n", ($time-start_time)/10);      
          # 30;
          $writememb("../../../../verilog/data/mem_S.txt", DUT.mem_S.mem);
          $writememb("../../../../verilog/data/mem_S1S2.txt", DUT.mem_S1S2.mem);
      end
      //$finish;
    end

  always
    begin
      clk = 1'b1;
      #5;
      clk = 1'b0;
      #5;
    end
   
endmodule