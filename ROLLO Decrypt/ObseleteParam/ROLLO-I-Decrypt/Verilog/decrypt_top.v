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
//              ROLLO-I decryption top module
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


module decrypt_top #(parameter n = `N, m = `M, d = 5)(  
    input wire              clk,
    input wire              rst_b,
    input wire              start,
    output wire             finish,

    //output signal for synthesis
    output wire [1-1:0]    data
    );

parameter WIDTH = m*d, DEPTH = (n/d) + ((n%d) != 0), DELAY_mul = 6; // DELAY --- delay of gf2m mul 
parameter r = `R;

//signal declaration
//memory
wire [WIDTH-1:0] c_di, c_do;
wire [`CLOG2(DEPTH)-1:0] c_addr;
wire c_we;

wire [WIDTH-1:0] x_dia, x_doa, x_dib, x_dob;
wire [`CLOG2(DEPTH)-1:0] x_addra, x_addrb;
wire x_wea, x_web;

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
wire [2:0] status; // 1 --- gf2mz multiplication for s = c*x   2 --- S1S2 generation for [S1,S2] from [f1,f2] and S   3 --- RSR generation for error vector space E

//gf2mz
wire gf2mz_start, gf2mz_done;
wire [`CLOG2(DEPTH)-1:0] gf2mz_S_addr;
wire gf2mz_S_we;

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

    .A_di                           (c_do), 
    .A_do                           (c_di),
    .A_addr                         (c_addr),
    .A_we                           (c_we),

    .B_dia                          (x_doa), 
    .B_dib                          (x_dob), 
    .B_doa                          (x_dia), 
    .B_dob                          (x_dib),
    .B_addra                        (x_addra), 
    .B_addrb                        (x_addrb),
    .B_wea                          (x_wea), 
    .B_web                          (x_web),

    .C_di                           (S_do), 
    .C_do                           (S_di),
    .C_addr                         (gf2mz_S_addr),
    .C_we                           (gf2mz_S_we),


    .done                           (gf2mz_done),
    .dout                           ()
    );

defparam gf2mz.n = n;
defparam gf2mz.m = m;
defparam gf2mz.d = 5; //number of GF(2^m) elements in one memory row


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
defparam S1S2gen.d = 5; //number of GF(2^m) elements in one memory row
defparam S1S2gen.DELAY_mul = 6;
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


keccak SHA3 (
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

//block RAM for c (ciphertext)
  mem_sp mem_c(
    //input
    .clk (clk),
    .di (),
    .addr (c_addr),
    .en (1'b1),
    .we (c_we),
    //output
    .do (c_do)
  );
defparam mem_c.WIDTH = WIDTH;
defparam mem_c.DEPTH = DEPTH;
defparam mem_c.FILE = "../../../../verilog/mem_c.txt"; //for simulation
//defparam mem_c.FILE = "../../verilog/mem_c.txt"; //for synthesis

//block RAM for x (secret key)
  mem_dp mem_x(
    //input
    .clka (clk),
    .dia (x_dia),
    .addra (x_addra),
    .ena (1'b1),
    .wea (x_wea),
    //output
    .doa (x_doa),

    //input
    .clkb (clk),
    .dib (x_dib),
    .addrb (x_addrb),
    .enb (1'b1),
    .web (x_web),
    //output
    .dob (x_dob)
  );
defparam mem_x.WIDTH = WIDTH;
defparam mem_x.DEPTH = DEPTH;
defparam mem_x.FILE = "../../../../verilog/mem_x.txt"; //for simulation
//defparam mem_x.FILE = "../../verilog/mem_x.txt"; //for synthesis

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
assign S_addr = status == 1 ? gf2mz_S_addr : S1S2gen_S_addr_reg;
assign S_we = status == 1 ? gf2mz_S_we : S1S2gen_S_we_reg;

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