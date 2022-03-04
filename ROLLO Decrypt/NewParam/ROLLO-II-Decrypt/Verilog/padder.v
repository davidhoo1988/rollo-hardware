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

/* "is_last" == 0 means byte number is 4, no matter what value "byte_num" is. */
/* if "in_ready" == 0, then "is_last" should be 0. */
/* the user switch to next "in" only if "ack" == 1. */

module padder #(parameter n = 47, m = 79, digit = 3) (clk, rst_b, in, in_ready, is_last, out, out_ready);
    input                     clk, rst_b;
    input      [m*digit-1:0]  in;
    input                     in_ready, is_last;
    output reg [575:0]        out;         /* to "f_permutation" module */
    output reg                out_ready;   /* to "f_permutation" module */



    parameter PAD_W = 576 - m*digit; 
    parameter LAST_DIGIT =  n%digit != 0 ? n%digit : digit; //remainder(n/digit), digit count for the last memory cell
    parameter NUM_BYTES =  (m*LAST_DIGIT/8) + ((m*LAST_DIGIT%8) != 0); //ceil(m*LAST_DIGIT/8), byte count for valid data in the last memory cell
    
    reg        [PAD_W-1:0]  v1;     /* to be shifted into register "out" */
    reg        [m*digit-1:0] in1;
    reg        [575:0] tmp;
    
    always @ (posedge clk)
      if (~rst_b)
        out <= 0;
      else if (in_ready)
        out <= tmp;
      else 
        out <= 0;  

/*    if (f_ack)  i <= 0; */
/*    if (update) i <= {i[16:0], 1'b1}; // increase length */

    always @ (posedge clk)
      if (~rst_b)
        out_ready <= 0;
      else if (in_ready)
        out_ready <= 1;
      else 
        out_ready <= 0;  

    
    always @ (*)
      begin
        if (~is_last)
          begin
            v1 = {PAD_W{1'd0}}; // add straight '0'
            in1 = in;
            tmp = {in1, v1};
          end
        else
          begin
            v1 = {PAD_W{1'd0}}; // add 0x0600..80
            v1[7] = v1[7] | 1'b1;   
            in1 = in;
            tmp = {in1, v1};
            tmp[576-1-8*NUM_BYTES-5:576-1-8*NUM_BYTES-6] = tmp[576-1-8*NUM_BYTES-5:576-1-8*NUM_BYTES-6] | 2'b11;          
          end
      end

endmodule
