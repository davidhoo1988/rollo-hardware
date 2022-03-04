/*
 * Copyright 2013, Homer Hsing <homer.hsing@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* "is_last" == 0 means byte number is 8, no matter what value "byte_num" is. */
/* if "in_ready" == 0, then "is_last" should be 0. */
/* the user switch to next "in" only if "ack" == 1. */
//`include "clog2.v" 
//`include "define.v"

`define low_pos(w,b)      ((w)*64 + (b)*8)
`define low_pos2(w,b)     `low_pos(w,7-b)
`define high_pos(w,b)     (`low_pos(w,b) + 7)
`define high_pos2(w,b)    (`low_pos2(w,b) + 7)

module keccak #(parameter n = `N, m = `M, r = `R, d = `D, digit = 1) (clk, rst_b, in_ready, mem_din, mem_rw, mem_addr, out_usr, out_ready);

parameter WIDTH = m*digit;
parameter DEPTH = (r/digit) + ((r%digit) != 0); //ceil(r/digit)

    input                           clk, rst_b;
    input                           in_ready;
    input [WIDTH-1:0]               mem_din;
    
    output                          mem_rw;
    output [`CLOG2(DEPTH)-1:0]      mem_addr;
    output    [511:0]               out_usr;
    output                          out_ready;





//for synthesis
//parameter FILE_E = "mem_E.txt";

reg                pad_start;
reg        [1:0]   pad_start_tmp;   

wire       [575:0] padder_out, padder_out1;
wire               padder_out_ready;
wire               is_last;

wire               f_ack;
wire      [1599:0] f_out;
wire               f_out_ready;
reg        [DEPTH-1:0]  i;         /* gen "out_ready" */

wire      [511:0] out, out1;


reg [`CLOG2(DEPTH)-1:0] E_addr;
wire [WIDTH-1:0] E_do;

genvar w, b;


//top control logic

assign out1 = f_out[1599:1599-511];

always @ (*)
  if ( in_ready || (~out_ready & f_out_ready) )
    pad_start = 1;
  else
    pad_start = 0;  

//delay pad_start for two more cycles 
always @(posedge clk) begin
  if (~rst_b) begin
    // reset
    pad_start_tmp <= 0;
  end
  else begin
    pad_start_tmp[0] <= pad_start;
    pad_start_tmp[1] <= pad_start_tmp[0];
  end
end



always @ (posedge clk)
  if (~rst_b)
    i <= 0;
  else if (f_ack)
    i <= {i[DEPTH-2:0], f_ack}; //ensure DEPTH >= 2
  else if (f_out_ready && is_last)
    i <= 0;   


assign out_ready = (f_out_ready && is_last) ? 1'b1 : 1'b0;


always @(posedge clk) begin
  if (~rst_b)
    E_addr <= 0;
  else if (f_ack)
    E_addr <= E_addr + 1'd1;
  else if (is_last) 
    E_addr <= 0;
  else  
    E_addr <= E_addr;
end

assign is_last = i[DEPTH-1];


/* reorder byte ~ ~ */
generate
  for(w=0; w<9; w=w+1)
    begin : L2
      for(b=0; b<8; b=b+1)
        begin : L3
          assign padder_out[`high_pos(w,b):`low_pos(w,b)] = padder_out1[`high_pos2(w,b):`low_pos2(w,b)];
        end
    end
endgenerate

/* reorder byte ~ ~ */
generate
  for(w=0; w<8; w=w+1)
    begin : L0
      for(b=0; b<8; b=b+1)
        begin : L1
          assign out[`high_pos(w,b):`low_pos(w,b)] = out1[`high_pos2(w,b):`low_pos2(w,b)];
        end
    end
endgenerate

// padder prepares the input data into regular 576-bit data block for f_permutation
padder padder_(
    //input
    .clk (clk), 
    .rst_b (rst_b), 
    .in (E_do), 
    .in_ready (pad_start_tmp[1]), 
    .is_last (E_addr == DEPTH-1 ? 1'b1 : 1'b0), 
    //output
    .out (padder_out1), 
    .out_ready (padder_out_ready)
);

defparam padder_.n = n;
defparam padder_.m = m;
defparam padder_.digit = digit;


f_permutation f_permutation_(
  //input
    .clk (clk), 
    .rst_b (rst_b),
    .in (padder_out), 
    .in_ready (padder_out_ready), 
   //output 
    .ack (f_ack), 
    .out (f_out), 
    .out_ready (f_out_ready)
);

// //block RAM for E(z)
// mem_sp mem_E(
//   //input
//   .clk (clk),
//   .di ({WIDTH{1'b0}}),
//   .addr (E_addr),
//   .en (1'b1),
//   .we (1'b0),
//   //output
//   .do (E_do)
// );

// defparam mem_E.WIDTH = WIDTH;
// defparam mem_E.DEPTH = DEPTH;
// defparam mem_E.FILE = FILE_E;

assign out_usr = out;
assign mem_rw = 1'b0; //always read
assign mem_addr = E_addr;
assign E_do = mem_din;

endmodule

`undef low_pos
`undef low_pos2
`undef high_pos
`undef high_pos2
