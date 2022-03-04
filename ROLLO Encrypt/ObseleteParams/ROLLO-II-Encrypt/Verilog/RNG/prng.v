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

`define high_pos2(x)      8*(x+1) - 1
`define low_pos2(x)      `high_pos2(x) - 7
`define high_pos(x)      95 - 8*x
`define low_pos(x)       `high_pos(x) - 7

module prng #(parameter n = `N, m = `M, r = `R, d = `D, digit = `DIGIT) (clk, rst_b, in_ready, in_seed, in_mod, out_rng, out_ready);
    input              clk, rst_b;
    input              in_ready;
    input      [95:0]  in_seed;
    input              in_mod;

    output     [95:0]  out_rng;
    output             out_ready;



wire       [95:0]  rng_seed, rng_seed1;
reg                rng_start;
reg                f_perm_busy;


wire               f_ack;
wire      [199:0] f_out;
wire               f_out_ready;
reg        [18-1:0]  i;         /* gen "out_ready" */

genvar b;

//top control logic

always @ (*)
  if ( in_ready && ~f_perm_busy )
    rng_start = 1;
  else
    rng_start = 0;  

assign rng_seed1 = in_mod == 1'b1 ? in_seed : 96'b0;


assign accept = in_ready & (~ f_perm_busy); // absorb enabled, in_ready & (i == 0)  

always @ (posedge clk)
  if (~rst_b) 
    i <= 0;
  else
    i <= {i[17:0], accept}; 

always @ (posedge clk)
  if (~rst_b) f_perm_busy <= 0;
  else       f_perm_busy <= (f_perm_busy & (~ i[17])) | accept;



/* reorder byte ~ ~ */
generate
  for(b=0; b<12; b=b+1)
    begin : L3
      assign rng_seed[`high_pos(b):`low_pos(b)] = rng_seed1[`high_pos2(b):`low_pos2(b)];
    end
endgenerate


f_permutation_200 f_permutation_(
  //input
    .clk (clk), 
    .rst_b (rst_b),
    .in (rng_seed), 
    .in_ready (rng_start), 
   //output 
    .ack (f_ack), 
    .out (f_out), 
    .out_ready (f_out_ready)
);


assign out_rng = f_out[199:199-95];
assign out_ready = f_out_ready;

endmodule

`undef low_pos
`undef low_pos2
`undef high_pos
`undef high_pos2
