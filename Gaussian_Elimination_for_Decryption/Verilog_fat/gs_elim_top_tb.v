`include "define.v"
`include "clog2.v"

`timescale 1ns / 1ps
module gs_elim_top_tb;

  parameter DAT_W = `l;
  parameter DAT_D = $ceil(1.0*`k/`d)*`d;

  //inputs
  reg clk = 0;
  reg rst_b = 0;
  reg start = 0;

  //outputs  
  wire finish;

  wire [DAT_W-1:0] mem_din, mem_dout;
  reg [DAT_W-1:0] mem_dout_reg;

  wire [`CLOG2(DAT_D)-1:0] mem_addr;
  reg [`CLOG2(DAT_D)-1:0] mem_addr_reg;

  wire mem_rw;
  reg mem_rw_reg;

  wire rd_en, wr_en;

  gs_elim_top  DUT(
    .clk        (clk),
    .rst_b      (rst_b),
    .start      (start),
    .finish     (finish),
    //interact with memory
    .mem_din    (mem_din),
    .mem_dout   (mem_dout),
    .mem_addr   (mem_addr),
    .mem_rw     (mem_rw)
);

defparam DUT.DAT_W = DAT_W;
defparam DUT.DAT_D = DAT_D;
defparam DUT.d = `d;

  mem MEMORY(
    .clock      (clk),
    .data       (mem_dout_reg),
    .rdaddress  (mem_addr_reg),
    .rden       (rd_en),
    .wraddress  (mem_addr_reg),
    .wren       (wr_en),
    .q          (mem_din)
);

defparam MEMORY.WIDTH = DAT_W;
defparam MEMORY.DEPTH = DAT_D;
defparam MEMORY.FILE = "../../../../Verilog_fat/data.in";

  assign rd_en = mem_rw_reg == 0 ? 1'b1 : 1'b0;
  assign wr_en = mem_rw_reg == 1 ? 1'b1 : 1'b0;

  always @(posedge clk) begin
    if (~rst_b) begin
      // reset
        mem_addr_reg <= 0;
        mem_dout_reg <= 0;
        mem_rw_reg <= 0;
    end
    else begin
        mem_addr_reg <= mem_addr;
        mem_dout_reg <= mem_dout;
        mem_rw_reg <= mem_rw;
    end
  end

 
  integer i;

  integer start_time, end_time;

  initial
    begin
      rst_b = 1'b0;
      start = 1'b0;

      # 50;
      rst_b = 1'b1;
      # 105;
      start = 1'b1;
      start_time <= $time;

      # 10;
      start = 1'b0;
      
      @(posedge finish); //DUT finished
      end_time <= $time;
      # 1;
      //f = $fopen("../../../../verilog/data.out","w");
      for (i = 0; i<1; i=i+1) begin
          $display("\nruntime: %0d cycles\n", (end_time-start_time)/10);      
          # 10;
      end
      # 20;
      $writememb("../../../../Verilog_fat/data.out", MEMORY.mem);
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