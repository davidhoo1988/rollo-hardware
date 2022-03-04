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
/* keccak-f[200] permutation function
/* if "ack" is 1, then current input has been used. */

module f_permutation_200(clk, rst_b, in, in_ready, ack, out, out_ready);
    input               clk, rst_b;
    input      [95:0]  in;
    input               in_ready;
    output              ack;
    output reg [199:0] out;
    output reg          out_ready;

    reg        [16:0]   i; /* select round constant */
    wire       [199:0] round_in, round_out;
    wire       [7:0]   rc; /* round constant */
    wire                update;
    wire                accept;
    reg                 calc; /* == 1: calculating rounds */


    assign accept = in_ready & (~ calc); // absorb enabled, in_ready & (i == 0)

    
    always @ (posedge clk)
      if (~rst_b) 
        i <= 0;
      else
        i <= {i[15:0], accept}; 
        
    
    always @ (posedge clk)
      if (~rst_b) calc <= 0;
      else       calc <= (calc & (~ i[16])) | accept;
    
    assign update = calc | accept;

    assign ack = i[15]; //ack is two clock delay earlier than out_ready

    always @ (posedge clk)
      if (~rst_b)
        out_ready <= 0;
      else if (accept)
        out_ready <= 0;
      else if (i[16]) // only change at the last round
        out_ready <= 1;
      else 
        out_ready <= 0;  

    assign round_in = accept ? {in ^ out[199:199-95], out[199-96:0]} : out;

    rconst_200
      rconst_ ({i,accept}, rc);

    round_200
      round_ (round_in, rc, round_out);

    always @ (posedge clk)
      if (~rst_b)
        out <= 0;
      else if (update)
        out <= round_out;

endmodule
