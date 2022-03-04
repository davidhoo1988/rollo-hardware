`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 9/10/2020 6:17:37 PM
// Design Name: 
// Module Name: S1S2_gen_tb
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


module S1S2_gen_tb(
    );

parameter m = `M;
parameter n = `N;
parameter d = 5;

parameter WIDTH = m*d;
parameter DEPTH = (n/d) + ((n%d) != 0); //ceil(n/d)


  //inputs
  reg clk = 1'b0;
  reg start = 1'b0;
  reg rst_b = 1'b0;
 
  //outputs
  wire finish;

  wire [WIDTH-1:0] S_dout;
  wire [`CLOG2(DEPTH)-1:0] S_addr;
  wire S_rw;
  reg [`CLOG2(DEPTH)-1:0] S_addr_reg;
  reg S_rw_reg;

  wire [m-1:0] f_dout;
  wire f_addr;
  wire f_rw;
  reg f_addr_reg;
  reg f_rw_reg;

  wire [2*m-1:0] S1S2_din;
  wire [`CLOG2(2*n)-1:0] S1S2_addr;
  wire S1S2_rw;
  reg [2*m-1:0] S1S2_din_reg;
  reg [`CLOG2(2*n)-1:0] S1S2_addr_reg;
  reg S1S2_rw_reg;

  S1S2_gen DUT(
    .clk                (clk),
    .rst_b              (rst_b),
    .start              (start),
    .finish             (finish),

    //memory interaction
    .S_din              (S_dout),
    .S_addr             (S_addr),
    .S_rw               (S_rw),
    .f_din              (f_dout),
    .f_addr             (f_addr),
    .f_rw               (f_rw),    

    .S1S2_dout          (S1S2_din),
    .S1S2_addr          (S1S2_addr),
    .S1S2_rw            (S1S2_rw)
  );

  defparam DUT.n = n;
  defparam DUT.m = m;
  defparam DUT.d = d;
  defparam DUT.DELAY_rd = 2;
  defparam DUT.DELAY_mul = 6;

//block RAM for space S
  mem_sp mem_S(
    //input
    .clk (clk),
    .di (),
    .addr (S_addr_reg),
    .en (1'b1),
    .we (S_rw_reg),
    //output
    .do (S_dout)
  );

defparam mem_S.WIDTH = WIDTH;
defparam mem_S.DEPTH = DEPTH;
defparam mem_S.FILE = "../../../../verilog/mem_S.txt";

//block RAM for f1 and f2
  mem_sp mem_f(
    //input
    .clk (clk),
    .di (),
    .addr (f_addr_reg),
    .en (1'b1),
    .we (f_rw_reg),
    //output
    .do (f_dout)
  );

defparam mem_f.WIDTH = m;
defparam mem_f.DEPTH = 2;
defparam mem_f.FILE = "../../../../verilog/mem_finv.txt";

//block RAM for space S1S2
  mem_sp mem_S1S2(
    //input
    .clk (clk),
    .di (S1S2_din_reg),
    .addr (S1S2_addr_reg),
    .en (1'b1),
    .we (S1S2_rw_reg),
    //output
    .do ()
  );

defparam mem_S1S2.WIDTH = 2*m;
defparam mem_S1S2.DEPTH = 2*n;
defparam mem_S1S2.FILE = "";


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
  
        @(negedge finish);
        end_time = $time;
        $display("runtime: %0d cycles\n", (end_time - start_time)/10);
        # 20; //wait for the write_mem delay
        $writememb("../../../../verilog/mem_S1S2.txt", mem_S1S2.mem);
        end

   always 
    #5 clk =  ! clk; 

    always @(posedge clk) begin
        S_addr_reg <= S_addr;
        f_addr_reg <= f_addr;
        S1S2_addr_reg <= S1S2_addr;

        S_rw_reg <= S_rw;
        f_rw_reg <= f_rw;
        S1S2_rw_reg <= S1S2_rw;

        S1S2_din_reg <= S1S2_din;
    end

endmodule
