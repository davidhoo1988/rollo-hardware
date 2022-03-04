`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2019 10:14:37 AM
// Design Name: 
// Module Name: gf2mz_top_tb
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


module gf2mz_top_tb(
    );

  //inputs
  reg clk = 1'b0;
  reg start = 1'b0;
  reg rst_b = 1'b0;
 
  //outputs
  wire done;
  wire [`M-1:0] dout;

  gf2mz_top #(.n(`N), .m(`M), .d(5), .FILE_A("../../../../Verilog/mem_A.txt"), .FILE_B("../../../../Verilog/mem_B.txt")) DUT(
    .clk(clk),
    .rst_b(rst_b),
    .start(start),

    .done(done),
    .dout(dout)
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
        $writememb("../../../../Improve-I.srcs/sources_1/new/mem_C.txt", DUT.mem_C.mem);
	    end

   always 
    #5 clk =  ! clk; 

endmodule
