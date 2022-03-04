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
  reg mat_sel = 0;
  reg is_last = 0;

  //outputs  
  wire finish;

  wire [DAT_W-1:0] mem_dina, mem_douta, mem_doutb;
  reg [DAT_W-1:0] mem_douta_reg, mem_doutb_reg;

  wire [`CLOG2(DAT_D)-1:0] mem_addra, mem_addrb;
  reg [`CLOG2(DAT_D)-1:0] mem_addra_reg, mem_addrb_reg;

  wire mem_rwa, mem_rwb;
  reg mem_rwa_reg, mem_rwb_reg;


  gs_elim_top  DUT(
    .clk        (clk),
    .rst_b      (rst_b),
    .start      (start),
    .mat_sel    (mat_sel),
    .is_last    (is_last),
    .finish     (finish),
    //interact with memory
    .mem_dina    (mem_dina),
    .mem_douta   (mem_douta),
    .mem_addra   (mem_addra),
    .mem_rwa     (mem_rwa),
    .mem_doutb   (mem_doutb),
    .mem_addrb   (mem_addrb),
    .mem_rwb     (mem_rwb)
);

defparam DUT.DAT_W = DAT_W;
defparam DUT.DAT_D = DAT_D;
defparam DUT.d = `d;

  mem_dp MEMORY(
  .clka         (clk),
  .wea          (mem_rwa_reg),
  .ena          (1'b1),
  .dia          (mem_douta_reg),
  .addra        (mem_addra_reg),
  .doa          (mem_dina), 

  .clkb         (clk),
  .web          (mem_rwb_reg),
  .enb          (1'b1),
  .dib          (mem_doutb_reg),
  .addrb        (mem_addrb_reg),
  .dob          ()
);

defparam MEMORY.WIDTH = DAT_W;
defparam MEMORY.DEPTH = DAT_D;
defparam MEMORY.FILE = "../../../../Verilog_thin/data.in";


  always @(posedge clk) begin //assume memory read/write delay = 2
    if (~rst_b) begin
      // reset
        mem_addra_reg <= 0;
        mem_douta_reg <= 0;
        mem_rwa_reg <= 0;
        mem_addrb_reg <= 0;
        mem_doutb_reg <= 0;
        mem_rwb_reg <= 0;
    end
    else begin
        mem_addra_reg <= mem_addra;
        mem_douta_reg <= mem_douta;
        mem_rwa_reg <= mem_rwa;
        mem_addrb_reg <= mem_addrb;
        mem_doutb_reg <= mem_doutb;
        mem_rwb_reg <= mem_rwb;
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
      mat_sel = 1'b1;
      is_last = 1'b0;
      start_time <= $time;

      # 10;
      start = 1'b0;
      mat_sel = 1'b0;  
          
      @(posedge finish); //DUT finished
      end_time <= $time;
      # 1;
      //f = $fopen("../../../../verilog/data.out","w");
      for (i = 0; i<1; i=i+1) begin
          $display("\nruntime: %0d cycles\n", (end_time-start_time)/10);      
          # 10;
      end
      # 20;
      $writememb("../../../../Verilog_thin/data.out", MEMORY.mem);
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