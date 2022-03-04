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

/* if "ack" is 1, then current input has been used. */

module f_permutation(clk, rst_b, in, in_ready, ack, out, out_ready);
    input               clk, rst_b;
    input      [575:0]  in;
    input               in_ready;
    output              ack;
    output reg [1599:0] out;
    output reg          out_ready;

    reg        [22:0]   i; /* select round constant */
    wire       [1599:0] round_in, round_out;
    wire       [63:0]   rc; /* round constant */
    wire                update;
    wire                accept;
    reg                 calc; /* == 1: calculating rounds */


    assign accept = in_ready & (~ calc); // absorb enabled, in_ready & (i == 0)

    
    always @ (posedge clk)
      if (~rst_b) 
        i <= 0;
      else
        i <= {i[21:0], accept}; 
        
    
    always @ (posedge clk)
      if (~rst_b) calc <= 0;
      else       calc <= (calc & (~ i[22])) | accept;
    
    assign update = calc | accept;

    assign ack = i[21]; //ack is two clock delay earlier than out_ready

    always @ (posedge clk)
      if (~rst_b)
        out_ready <= 0;
      else if (accept)
        out_ready <= 0;
      else if (i[22]) // only change at the last round
        out_ready <= 1;
      else 
        out_ready <= 0;  

    assign round_in = accept ? {in ^ out[1599:1599-575], out[1599-576:0]} : out;

    rconst
      rconst_ ({i,accept}, rc);

    round
      round_ (round_in, rc, round_out);

    always @ (posedge clk)
      if (~rst_b)
        out <= 0;
      else if (update)
        out <= round_out;

endmodule
