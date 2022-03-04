`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 9/15/2020 14:25:38 AM
// Design Name: 
// Module Name: decrypt_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//              ROLLO-III decryption top module
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// n: degree of GF(2m)[z] polynomial  m: degree of GF(2m)  
// d: number of GF(2m) elements in each memory cell
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"
`include "clog2.v"


module decrypt_top #(parameter n = `N, m = `M, d = 6)(  
    input wire              clk,
    input wire              rst_b,
    input wire              start,
    output wire             finish,

    //output signal for synthesis
    output wire [1-1:0]    data
    );

parameter WIDTH = m*d, DEPTH = (n/d) + ((n%d) != 0), DELAY_mul = 8; // DELAY --- delay of gf2m mul 
parameter r = `Wr;

//signal declaration
//memory
wire [WIDTH-1:0] sr_di, sr_do;
wire [`CLOG2(DEPTH)-1:0] sr_addr;
wire sr_we;

wire [WIDTH-1:0] se_di, se_do;
wire [`CLOG2(DEPTH)-1:0] se_addr;
wire se_we;

wire [WIDTH-1:0] y_dia, y_doa, y_dib, y_dob;
wire [`CLOG2(DEPTH)-1:0] y_addra, y_addrb;
wire y_wea, y_web;

wire [WIDTH-1:0] S_di, S_do;
wire [`CLOG2(DEPTH)-1:0] S_addr;
wire S_we;

wire [2*m-1:0] S1S2_do;
reg [2*m-1:0] S1S2_di;
reg [`CLOG2(2*n)-1:0] S1S2_addr;
reg S1S2_we;

wire [m-1:0] f_do;
wire f_addr;
wire f_we;

//ctrl_top
wire [2:0] status; // 1 --- gf2mz multiplication for s = c*x   2 --- S1S2 generation for [S1,S2] from [f1,f2] and S   3 --- RSR generation for error vector space E  4 --- Hash  5 --- gf2mz addition for s = se + s

//gf2mz
wire gf2mz_start, gf2mz_done;
wire [WIDTH-1:0] gf2mz_S_di;
wire [`CLOG2(DEPTH)-1:0] gf2mz_S_addr;
wire gf2mz_S_we;

//gf2mz_add
wire gf2mz_add_start, gf2mz_add_done;
wire [WIDTH-1:0] gf2mz_add_S_di;
wire [`CLOG2(DEPTH)-1:0] gf2mz_add_S_addr;
wire gf2mz_add_S_we;

//S1S2gen
wire S1S2gen_start, S1S2gen_done;
wire [`CLOG2(DEPTH)-1:0] S1S2gen_S_addr;
wire S1S2gen_S_we;
wire [`CLOG2(2*n)-1:0] S1S2gen_S1S2_addr;
wire [2*m-1:0] S1S2gen_S1S2_di;
wire S1S2gen_S1S2_we;

reg [`CLOG2(DEPTH)-1:0] S1S2gen_S_addr_reg;
reg S1S2gen_S_we_reg;

//RSR
wire RSR_start, RSR_done;
wire [`CLOG2(2*n)-1:0] RSR_S1S2_addr;
wire [2*m-1:0] RSR_S1S2_di;
wire RSR_S1S2_we;

//hash
wire sha3_start, sha3_done;
wire [`CLOG2(r)-1:0] sha3_mem_addr;
wire sha3_mem_we;
wire [512-1:0] sha3_do;


ctrl_top ctrl_top(
    .clk                            (clk),
    .rst_b                          (rst_b),
    .start                          (start),

    //interacts other components
    .gf2mz_start                    (gf2mz_start),
    .gf2mz_done                     (gf2mz_done),
    .gf2mz_add_start                (gf2mz_add_start),
    .gf2mz_add_done                 (gf2mz_add_done),
    .S1S2gen_start                  (S1S2gen_start),
    .S1S2gen_done                   (S1S2gen_done),
    .RSR_start                      (RSR_start),
    .RSR_done                       (RSR_done),
    .sha3_start                     (sha3_start),
    .sha3_done                      (sha3_done),

    .status                         (status)
    );

gf2mz_top gf2mz(
    .clk                            (clk),
    .rst_b                          (rst_b),
    .start                          (gf2mz_start),

    .A_di                           (sr_do), 
    .A_do                           (sr_di),
    .A_addr                         (sr_addr),
    .A_we                           (sr_we),

    .B_dia                          (y_doa), 
    .B_dib                          (y_dob), 
    .B_doa                          (y_dia), 
    .B_dob                          (y_dib),
    .B_addra                        (y_addra), 
    .B_addrb                        (y_addrb),
    .B_wea                          (y_wea), 
    .B_web                          (y_web),

    .C_di                           (S_do), 
    .C_do                           (gf2mz_S_di),
    .C_addr                         (gf2mz_S_addr),
    .C_we                           (gf2mz_S_we),

    .done                           (gf2mz_done),
    .dout                           ()
    );
defparam gf2mz.n = n;
defparam gf2mz.m = m;
defparam gf2mz.d = d; //number of GF(2^m) elements in one memory row

gf2mz_add gf2mz_add(  //A and C share the same addr control
     .clk                           (clk),
     .rst_b                         (rst_b),
     .start                         (gf2mz_add_start),

     .A_di                          (S_do),

     .B_di                          (se_do),
     .B_addr                        (se_addr),
     .B_we                          (se_we),

     .C_do                          (gf2mz_add_S_di),
     .C_addr                        (gf2mz_add_S_addr),
     .C_we                          (gf2mz_add_S_we),

     .done                          (gf2mz_add_done)
    );
defparam gf2mz_add.n = n;
defparam gf2mz_add.m = m;
defparam gf2mz_add.d = d; //number of GF(2^m) elements in one memory row

S1S2_gen S1S2gen(  // DELAY --- delay of gf2m mul or memory read
    .clk                            (clk),
    .rst_b                          (rst_b),
    .start                          (S1S2gen_start),
    .finish                         (S1S2gen_done),

    //memory interaction
    .S_din                          (S_do),
    .S_addr                         (S1S2gen_S_addr),
    .S_rw                           (S1S2gen_S_we),
    .f_din                          (f_do),
    .f_addr                         (f_addr),
    .f_rw                           (f_we),    

    .S1S2_dout                      (S1S2gen_S1S2_di),
    .S1S2_addr                      (S1S2gen_S1S2_addr),
    .S1S2_rw                        (S1S2gen_S1S2_we)
    );

defparam S1S2gen.n = n;
defparam S1S2gen.m = m;
defparam S1S2gen.d = d; //number of GF(2^m) elements in one memory row
defparam S1S2gen.DELAY_mul = DELAY_mul;
defparam S1S2gen.DELAY_rd = 2;

gs_elim_top RSR(
    .clk                            (clk),
    .rst_b                          (rst_b),
    .start                          (RSR_start),
    .finish                         (RSR_done),
    //interact with memory
    .mem_din                        (S1S2_do),
    .mem_dout                       (RSR_S1S2_di),
    .mem_addr                       (RSR_S1S2_addr),
    .mem_rw                         (RSR_S1S2_we)
    );
defparam RSR.DAT_W = 2*m;
defparam RSR.DAT_D = 2*n;
defparam RSR.d = r;


keccak SHA3(
  //input
  .clk        (clk), 
  .rst_b      (rst_b), 
  .in_ready   (sha3_start), 
  .mem_din    (S1S2_do[m-1:0]),
  //output
  .mem_rw     (sha3_mem_we),
  .mem_addr   (sha3_mem_addr),
  .out_usr    (sha3_do), 
  .out_ready  (sha3_done)
  );
defparam SHA3.DELAY_rd = 2;

//block RAM for sr (ciphertext)
  mem_sp mem_sr(
    //input
    .clk (clk),
    .di (),
    .addr (sr_addr),
    .en (1'b1),
    .we (sr_we),
    //output
    .do (sr_do)
  );
defparam mem_sr.WIDTH = WIDTH;
defparam mem_sr.DEPTH = DEPTH;
defparam mem_sr.FILE = "../../../../verilog/mem_sr.txt"; //for simulation
//defparam mem_sr.FILE = "../../verilog/mem_sr.txt"; //for synthesis

//block RAM for se (ciphertext)
  mem_sp mem_se(
    //input
    .clk (clk),
    .di (),
    .addr (se_addr),
    .en (1'b1),
    .we (se_we),
    //output
    .do (se_do)
  );
defparam mem_se.WIDTH = WIDTH;
defparam mem_se.DEPTH = DEPTH;
defparam mem_se.FILE = "../../../../verilog/mem_se.txt"; //for simulation
//defparam mem_se.FILE = "../../verilog/mem_se.txt"; //for synthesis

//block RAM for y (secret key)
  mem_dp mem_y(
    //input
    .clka (clk),
    .dia (y_dia),
    .addra (y_addra),
    .ena (1'b1),
    .wea (y_wea),
    //output
    .doa (y_doa),

    //input
    .clkb (clk),
    .dib (y_dib),
    .addrb (y_addrb),
    .enb (1'b1),
    .web (y_web),
    //output
    .dob (y_dob)
  );
defparam mem_y.WIDTH = WIDTH;
defparam mem_y.DEPTH = DEPTH;
defparam mem_y.FILE = "../../../../verilog/mem_y.txt"; //for simulation
//defparam mem_y.FILE = "../../verilog/mem_y.txt"; //for synthesis

//block RAM for space S (syndrome space)
  mem_sp mem_S(
    //input
    .clk (clk),
    .di (S_di),
    .addr (S_addr),
    .en (1'b1),
    .we (S_we),
    //output
    .do (S_do)
  );
defparam mem_S.WIDTH = WIDTH;
defparam mem_S.DEPTH = DEPTH;
defparam mem_S.FILE = "";

//block RAM for f1 and f2
  mem_sp mem_finv(
    //input
    .clk (clk),
    .di (),
    .addr (f_addr),
    .en (1'b1),
    .we (f_we),
    //output
    .do (f_do)
  );
defparam mem_finv.WIDTH = m;
defparam mem_finv.DEPTH = 2;
defparam mem_finv.FILE = "../../../../verilog/mem_finv.txt"; //for simulation
//defparam mem_finv.FILE = "../../verilog/mem_finv.txt"; //for synthesis

//block RAM for space S1S2
  mem_sp mem_S1S2(
    //input
    .clk (clk),
    .di (S1S2_di),
    .addr (S1S2_addr),
    .en (1'b1),
    .we (S1S2_we),
    //output
    .do (S1S2_do)
  );
defparam mem_S1S2.WIDTH = 2*m;
defparam mem_S1S2.DEPTH = 2*n;
defparam mem_S1S2.FILE = "";

//S Delay_rd = 1 
assign S_addr = status == 1 ? gf2mz_S_addr : status == 5 ? gf2mz_add_S_addr : S1S2gen_S_addr_reg;
assign S_we = status == 1 ? gf2mz_S_we : status == 5 ? gf2mz_add_S_we : S1S2gen_S_we_reg;
assign S_di = status == 1 ? gf2mz_S_di : status == 5 ? gf2mz_add_S_di : 0 ;

always @(posedge clk) begin
    S1S2gen_S_addr_reg <= S1S2gen_S_addr;
    S1S2gen_S_we_reg <= S1S2gen_S_we;
end

always @(posedge clk) begin //S1S2 Delay_rd = 2
    S1S2_addr <= status == 2 ? S1S2gen_S1S2_addr : status == 3 ? RSR_S1S2_addr : status == 4 ? sha3_mem_addr : 0;
    S1S2_we <= status == 2 ? S1S2gen_S1S2_we : status == 3 ? RSR_S1S2_we : status == 4 ? sha3_mem_we : 0;
    S1S2_di <= status == 2 ? S1S2gen_S1S2_di : status == 3 ? RSR_S1S2_di : 0;
end

assign data = ^sha3_do;
assign finish = sha3_done;

endmodule