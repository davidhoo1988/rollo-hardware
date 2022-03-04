`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 9/9/2020 09:50:38 AM
// Design Name: 
// Module Name: S1S2_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//              Generate S1=f1^-1*S and S2=f2^-1*S from the syndrome space S
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


module S1S2_gen #(parameter n = 47, m = 79, d = 5, WIDTH = m*d, DEPTH = (n/d) + ((n%d) != 0), DELAY_mul = 6,  DELAY_rd = 1)(  // DELAY --- delay of gf2m mul or memory read
    input wire              clk,
    input wire              rst_b,
    input wire              start,
    output  wire            finish,

    //memory interaction
    input wire  [WIDTH-1:0]             S_din,
    output reg [`CLOG2(DEPTH)-1:0]      S_addr,
    output reg                          S_rw,
    input wire  [m-1:0]                 f_din,
    output reg                          f_addr,
    output reg                          f_rw,    

    output reg [2*m-1:0]                S1S2_dout,
    output reg [`CLOG2(2*n)-1:0]        S1S2_addr,
    output reg                          S1S2_rw
    );


reg mul_start;
wire mul_done;
wire [m-1:0] mul_op_a, mul_op_b, mul_op_c;

reg [`CLOG2(DELAY_mul):0] cnt;
reg [`CLOG2(d):0] idx;
reg mode;
reg [WIDTH-1:0] shift_reg;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------        
parameter       INIT = 3'd0, //do nothing, then get prepared
                PRE = 3'd1, //switch between f1 and f2
                MUL = 3'd2, //scalar multiplication fi*S
                POST = 3'd3;//handle memory S and S1S2 read/write

reg             PRE_done, MUL_done, POST_done, done;

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
                next_state = PRE;
            else
                next_state = INIT;  

        PRE:
            if (PRE_done)
                next_state = MUL;
            else   
                next_state = PRE;  

        MUL:
                next_state = POST;   

        POST: 
            if (done)
                next_state = INIT;
            else if ( POST_done &&  idx == n%d && S_addr == DEPTH-1  ) //S1 switch to S2
                next_state = PRE;
            else if (POST_done) //load/rotate the data for MUL
                next_state = MUL;    
            else 
                next_state = POST;                               
   
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
            PRE_done <= 0;
            MUL_done <= 0;
            POST_done <= 0;
            done <= 0;

            mode <= 0;
            mul_start <= 0;
            cnt <= 0;
            idx <= 0;
            shift_reg <= 0;

            S_addr <= 0;
            S_rw <= 0;
            f_addr <= 0;
            f_rw <= 0;
            S1S2_dout <= 0;
            S1S2_addr <= -1;
            S1S2_rw <= 0;
        end

        PRE: begin
            if (cnt < 1+DELAY_rd)
                cnt <= cnt + 1;
            else 
                cnt <= 0;

            if (cnt == DELAY_rd)
                PRE_done <= 1;
            else 
                PRE_done <= 0;
                    
            if (mode == 0) begin //handle the case S1
                S_addr <= 0;
                f_addr <= 0;
                S1S2_addr <= -1;
            end
            else begin //handle the case S2
                S_addr <= 0;
                f_addr <= 1;
                S1S2_addr <= n-1;
            end
            idx <= 0;
            S_rw <= 0;
            f_rw <= 0;
            S1S2_rw <= 0;
        end

        MUL: begin
            mul_start <= 1;
            idx <= idx + 1; //idx = 0,1,2,..,d-1
            if (idx == 0)
                shift_reg <= S_din;    
            else 
                shift_reg <= { shift_reg[WIDTH-m-1:0], {m{1'b0}} };    
            S1S2_dout <= 0;
            S1S2_addr <= S1S2_addr;
            S1S2_rw <= 0;     
        end

        POST: begin
            mul_start <= 0;

            if (mul_done)
                cnt <= 0;
            else    
                cnt <= cnt + 1;

            if (cnt == DELAY_mul-1) begin
                POST_done <= 1;
                if (S1S2_addr == 2*n-1-1)
                    done <= 1;
                else 
                    done <= 0;    
            end
            else begin
                POST_done <= 0;   
                done <= 0; 
            end 

            if (cnt == 0) begin
                if (idx == d && S_addr != DEPTH-1) begin //idx = 1,2,...,d if S_addr is not n/d
                    S_addr <= S_addr + 1;   
                    idx <= 0; 
                end 
                else if (idx == n%d && S_addr == DEPTH-1) begin //if it is the last entry of mem S
                    S_addr <= S_addr; //keep S_addr as DEPTH-1
                    idx <= idx;
                end
                else begin
                    S_addr <= S_addr;
                    idx <= idx;
                end
            end

            if (mul_done) begin //cnt == DELAY_mul
                S1S2_dout <= mode == 0 ? { mul_op_c, mul_op_c } : { mul_op_c, {m{1'b0}} } ;
                S1S2_addr <= S1S2_addr + 1'b1; //write at S1S2_addr = 0,1,...,n-1; n,n+1,...,2n-1
                S1S2_rw <= 1;
                if (idx == n%d && S_addr == DEPTH-1)
                    mode <= 1;
            end
            else begin
                S1S2_dout <= 0;
                S1S2_addr <= S1S2_addr;
                S1S2_rw <= 0;                
            end

        end

    endcase
end

assign finish = done;


//GF(2m) multiplier instance
gf2m_mul mul (
    .clk (clk),
    .rst_b (rst_b),
    .start (mul_start),
    .op_a (mul_op_a),
    .op_b (mul_op_b),

    .done (mul_done),
    .op_c (mul_op_c)
    );

assign mul_op_a = shift_reg[WIDTH-1:WIDTH-m]; 
assign mul_op_b = f_din;

endmodule