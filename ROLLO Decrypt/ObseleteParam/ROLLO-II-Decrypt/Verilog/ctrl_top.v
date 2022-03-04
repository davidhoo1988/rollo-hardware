`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 9/15/2020 14:25:38 AM
// Design Name: 
// Module Name: ctrl_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//              ROLLO-I decryption control logic
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"
`include "clog2.v"

module ctrl_top(
    input wire          clk,   
    input wire          rst_b,
    input wire          start,

    //interacts other components
    output reg          gf2mz_start,
    input wire          gf2mz_done,
    output reg          S1S2gen_start,
    input wire          S1S2gen_done,
    output reg          RSR_start,
    input wire          RSR_done,
    output reg          sha3_start,
    input wire          sha3_done,

    output wire  [2:0]  status
    );

reg S1S2gen_done_reg;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------        
parameter       INIT = 3'd0, //do nothing, then get prepared
                GF2MZ = 3'd1, //mul for s = c*x
                S1S2GEN = 3'd2, //generate S1 S2 from s
                RSR = 3'd3,//recover error E
                SHA3 =  3'd4; //hash the error E

reg             done;

//----------------------------------------------------------
//1st always block, sequential state transition
//----------------------------------------------------------
reg    [2:0]   state, next_state;

always @ (posedge clk)
      if (!rst_b)            
            state <= INIT;        
      else                  
            state <= next_state; 

//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------
always @(*) begin
    case (state)
        INIT: 
            if (start)
                next_state = GF2MZ;
            else
                next_state = INIT;  

        GF2MZ:
            if (gf2mz_done)
                next_state = S1S2GEN;
            else   
                next_state = GF2MZ;  

        S1S2GEN:
            if (S1S2gen_done_reg)
                next_state = RSR;  
            else 
                next_state = S1S2GEN;   

        RSR:
            if (RSR_done)
                next_state = SHA3;
            else     
                next_state = RSR;   

        SHA3:
            if (sha3_done)
                next_state = INIT;
            else 
                next_state = SHA3;    

        default:
            next_state = INIT;        
    endcase
end


always @(posedge clk or negedge rst_b) begin
    if (~rst_b) begin
        // reset
        gf2mz_start <= 0;
        S1S2gen_start <= 0; 
        RSR_start <= 0;
        sha3_start <= 0;
    end
    else begin
        gf2mz_start <= start;
        S1S2gen_start <= gf2mz_done;
        RSR_start <= S1S2gen_done_reg;
        sha3_start <= RSR_done;
    end
end

always @(posedge clk or negedge rst_b) begin
    if (~rst_b) begin
        // reset
        S1S2gen_done_reg <= 0;
    end
    else begin
        S1S2gen_done_reg <= S1S2gen_done;
    end
end

assign status = state;

endmodule