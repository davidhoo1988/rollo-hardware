`include "define.v"
`include "clog2.v"

`timescale 1ns / 1ps
module encrypt_top_tb;

  //inputs
  reg clk = 0;
  reg rst_b = 0;
  reg start = 0;

  //outputs  
  wire ready;
  wire [31:0] data;

  ROLLO_I_Encrypt  DUT(
    .clk    (clk), 
    .rst_b  (rst_b),
    .start  (start),

    .data   (data),
    .ready  (ready)
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
      
      @(posedge ready); //DUT finished
      # 1;
      //f = $fopen("../../../../verilog/data.out","w");
      for (i = 0; i<1; i=i+1) begin
          $display("\nruntime: %0d cycles\n", $time/10);      
          # 10;
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