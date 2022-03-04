`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2019 09:50:38 AM
// Design Name: 
// Module Name: gf2mz_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
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

module gf2mz_add #(parameter n = 47, m = 101, d = 6, WIDTH = m*d, DEPTH = (n/d) + ((n%d) != 0), DELAY_rd = 1)(  //A and C share the same addr control
     input wire                         clk,                          
     input wire                         rst_b,                       
     input wire                         start,                       

     input wire [WIDTH-1:0]             A_di,                   

     input wire [WIDTH-1:0]             B_di,                       
     output reg [`CLOG2(DEPTH)-1:0]     B_addr,                     
     output reg                         B_we,                      

     output reg [WIDTH-1:0]             C_do,                       
     output reg [`CLOG2(DEPTH)-1:0]     C_addr,                   
     output reg                         C_we,                         

     output reg                         done                       
    );

reg [`CLOG2(DELAY_rd+1):0] cnt;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------          
parameter      INIT = 3'd0, //do nothing, then get prepared
               READ = 3'd1, //read A and B
               ADD = 3'd2, //add C = A + B, merged to READ
               WRITE = 3'd3;//write back C

reg            READ_done, WRITE_done;

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
                next_state = READ;
            else
                next_state = INIT;  

        READ:
            if (READ_done)
                next_state = WRITE;
            else   
                next_state = READ;  

        WRITE: 
            if (done)
                next_state = INIT;
            else if (WRITE_done)
                next_state = READ;                         
   
        default:
            next_state = INIT;        
    endcase
end

//----------------------------------------------------------
//3rd sequential block, the sequential FSM output
//----------------------------------------------------------         
always @(posedge clk) begin
     case (state)
          INIT: begin 
               cnt <= 0;
               READ_done <= 0;
               WRITE_done <= 0;
               done <= 0;

               B_we <= 0;
               B_addr <= 0;

               C_we <= 0;
               C_addr <= 0;
               C_do <= 0;
          end

          READ: begin
               if (cnt < DELAY_rd)
                    cnt <= cnt + 1;
               else 
                    cnt <= 0;

               if (cnt == DELAY_rd-1)
                    READ_done <= 1;
               else 
                    READ_done <= 0;   

               if (cnt == DELAY_rd && C_addr == DEPTH-1)
                    done <= 1;
               else 
                    done <= 0;

               if (cnt == DELAY_rd)
                    WRITE_done <= 1;
               else 
                    WRITE_done <= 0;            
                
               if (cnt == DELAY_rd)
                    C_do <= A_di ^ B_di;
               else 
                    C_do <= 0;

               B_addr <= B_addr;
               C_addr <= C_addr;

               if (cnt == DELAY_rd)
                    C_we <= 1;
               else 
                    C_we <= 0;   

          end  

          WRITE: begin
              B_addr <= B_addr + 1;
              C_addr <= C_addr + 1; 
              C_we <= 0;
              C_do <= 0;

              cnt <= 0;
              WRITE_done <= 0;
              done <= 0;
          end

     endcase
end

endmodule