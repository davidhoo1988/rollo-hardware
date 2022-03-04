`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: 
// 
// Create Date: 10/14/2019 12:06:16 PM
// Design Name: 
// Module Name: mul_ctrl
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
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"
`include "clog2.v"

module mul_ctrl #(parameter WIDTH = 8, DEPTH = 64, m = 79, d = 3, DELAY = 6)(
	input wire 			clk,
	input wire 			rst_b,
	input wire 			start,
	output reg 			done,

	//A interface
	input wire [WIDTH-1:0]			A_di, //input from A_do of mem_A
	output reg 						A_we,
	output reg [`CLOG2(DEPTH)-1:0]	A_addr,
	output reg [WIDTH-1:0]			A_do, //output to A_di of mem_A

	//B interface
	input wire [WIDTH-1:0]			B_dia,
	output reg 						B_wea,
	output reg [`CLOG2(DEPTH)-1:0]	B_addra,
	output reg [WIDTH-1:0]			B_doa,
	input wire [WIDTH-1:0]			B_dib,
	output reg 						B_web,
	output reg [`CLOG2(DEPTH)-1:0]	B_addrb,
	output reg [WIDTH-1:0]			B_dob,

	//C interface
	input wire [WIDTH-1:0]			C_di,
	output reg 						C_we,
	output reg [`CLOG2(DEPTH)-1:0]	C_addr,
	output reg [WIDTH-1:0]			C_do,

	//GF2m multiplier interface
	output reg 					    mul_start,
    input wire                      mul_done,

	output wire [m-1:0] 			mul00_op_a,
	output wire [m-1:0] 			mul00_op_b,
    input wire [m-1:0]              mul00_op_c,
	output wire [m-1:0] 			mul01_op_a,
	output wire [m-1:0] 			mul01_op_b,
    input wire [m-1:0]              mul01_op_c,
	output wire [m-1:0] 			mul02_op_a,
	output wire [m-1:0] 			mul02_op_b,
    input wire [m-1:0]              mul02_op_c,
	output wire [m-1:0] 			mul03_op_a,
	output wire [m-1:0] 			mul03_op_b,
    input wire [m-1:0]              mul03_op_c,
	output wire [m-1:0] 			mul04_op_a,
	output wire [m-1:0] 			mul04_op_b,
    input wire [m-1:0]              mul04_op_c,
	output wire [m-1:0] 			mul10_op_a,
	output wire [m-1:0] 			mul10_op_b,
    input wire [m-1:0]              mul10_op_c,
	output wire [m-1:0] 			mul11_op_a,
	output wire [m-1:0] 			mul11_op_b,
    input wire [m-1:0]              mul11_op_c,
	output wire [m-1:0] 			mul12_op_a,
	output wire [m-1:0] 			mul12_op_b,
    input wire [m-1:0]              mul12_op_c,
	output wire [m-1:0] 			mul13_op_a,
	output wire [m-1:0] 			mul13_op_b,
    input wire [m-1:0]              mul13_op_c,
	output wire [m-1:0] 			mul14_op_a,
	output wire [m-1:0] 			mul14_op_b,
    input wire [m-1:0]              mul14_op_c,
	output wire [m-1:0] 			mul20_op_a,
	output wire [m-1:0] 			mul20_op_b,
    input wire [m-1:0]              mul20_op_c,
	output wire [m-1:0] 			mul21_op_a,
	output wire [m-1:0] 			mul21_op_b,
    input wire [m-1:0]              mul21_op_c,
	output wire [m-1:0] 			mul22_op_a,
	output wire [m-1:0] 			mul22_op_b,
    input wire [m-1:0]              mul22_op_c,
	output wire [m-1:0] 			mul23_op_a,
	output wire [m-1:0] 			mul23_op_b,
    input wire [m-1:0]              mul23_op_c,
	output wire [m-1:0] 			mul24_op_a,
	output wire [m-1:0] 			mul24_op_b,
    input wire [m-1:0]              mul24_op_c,
	output wire [m-1:0] 			mul30_op_a,
	output wire [m-1:0] 			mul30_op_b,
    input wire [m-1:0]              mul30_op_c,
	output wire [m-1:0] 			mul31_op_a,
	output wire [m-1:0] 			mul31_op_b,
    input wire [m-1:0]              mul31_op_c,
	output wire [m-1:0] 			mul32_op_a,
	output wire [m-1:0] 			mul32_op_b,
    input wire [m-1:0]              mul32_op_c,
	output wire [m-1:0] 			mul33_op_a,
	output wire [m-1:0] 			mul33_op_b,
    input wire [m-1:0]              mul33_op_c,
	output wire [m-1:0] 			mul34_op_a,
	output wire [m-1:0] 			mul34_op_b,
    input wire [m-1:0]              mul34_op_c,
	output wire [m-1:0] 			mul40_op_a,
	output wire [m-1:0] 			mul40_op_b,
    input wire [m-1:0]              mul40_op_c,
	output wire [m-1:0] 			mul41_op_a,
	output wire [m-1:0] 			mul41_op_b,
    input wire [m-1:0]              mul41_op_c,
	output wire [m-1:0] 			mul42_op_a,
	output wire [m-1:0] 			mul42_op_b,
    input wire [m-1:0]              mul42_op_c,
	output wire [m-1:0] 			mul43_op_a,
	output wire [m-1:0] 			mul43_op_b,
    input wire [m-1:0]              mul43_op_c,
	output wire [m-1:0] 			mul44_op_a,
	output wire [m-1:0] 			mul44_op_b,
    input wire [m-1:0]              mul44_op_c
	);

reg [`CLOG2(DELAY+18)-1:0] cnt; //log2(DELAY+18)-bit timer
reg flag; //used to handle the exception transition from MUL to POST

wire [WIDTH-1:0] cache; //used for updating B(z) to B(z)z^d in mem_B
reg [m-1:0] cache0, cache1, cache2, cache3, cache4;

wire [WIDTH-1:0] mul_r;
wire [m-1:0] mul_r0, mul_r1, mul_r2, mul_r3, mul_r4;
//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 		INIT = 3'd0, //do nothing, then get prepared
				PRE = 3'd1, //generate one entry of the dense polynomial g
				MUL = 3'd2, //scalar multiplication phase ai*[b_{j}b_{j+1}b_{j+2}]
                POST = 3'd3;//handle the tailing computation of state MUL

reg 			PRE_done, MUL_done, POST_done;

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
        	if (MUL_done)
        		next_state = POST;	
        	else 
        		next_state = MUL;  

        POST: 
            if (done)
                next_state = INIT;
            else if (POST_done)
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

            mul_start <= 0;
            cnt <= 0;
            flag <= 0;

			cache0 <= 0;
			cache1 <= 0;
			cache2 <= 0;
			cache3 <= 0;
			cache4 <= 0;

            A_we <= 0;
            A_addr <= 0;
            A_do <= 0;

            B_wea <= 0;
            B_addra <= 0;
            B_doa <= 0;
            B_web <= 0;
            B_addrb <= 0;
            B_dob <= 0;

            C_we <= 0;
            C_addr <= 0;
            C_do <= 0;
        end

        PRE: begin      //takes 3 cycles
        	if (cnt == 2) 
        		cnt <= 0;
        	else 
        		cnt <= cnt + 1'b1;
            flag <= 0;

            if (cnt == 1)
                PRE_done <= 1;
            else 
                PRE_done <= 0;    
            MUL_done <= 0;
            POST_done <= 0;
            done <= 0;
            if (PRE_done)
                mul_start <= 1;
            else 
                mul_start <= 0;

            if (PRE_done) begin
				cache0 <= B_dia[WIDTH-0*m-1:WIDTH-1*m];
				cache1 <= B_dia[WIDTH-1*m-1:WIDTH-2*m];
				cache2 <= B_dia[WIDTH-2*m-1:WIDTH-3*m];
				cache3 <= B_dia[WIDTH-3*m-1:WIDTH-4*m];
				cache4 <= B_dia[WIDTH-4*m-1:WIDTH-5*m];
            end
            else begin
				cache0 <= 0;
				cache1 <= 0;
				cache2 <= 0;
				cache3 <= 0;
				cache4 <= 0;
			end
            

        	B_wea <= 0;
        	B_doa <= 0;
        	if (cnt == 0)
        		B_addra <= DEPTH-2;
        	else if (cnt == 1)
        		B_addra <= DEPTH-1;
            else 
                B_addra <= B_addra;    

        	B_web <= 0;
        	B_dob <= 0;
        	if (cnt == 0)
        		B_addrb <= DEPTH-1;
        	else if (cnt == 1)
        		B_addrb <= 0;	
            else 
                B_addrb <= B_addrb;    

        	A_we <= 0;
        	A_addr <= 0;
        	A_do <= 0;

            C_we <= 0;
            C_addr <= 0;
            C_do <= 0;
        end

        MUL: begin
            if (cnt == DELAY) //[0,1,...,DELAY,0,1,...,DELAY,...]
                cnt <= 0;
            else 
                cnt <= cnt + 1'b1;
            if (flag == 0 && cnt == DELAY && B_addra == DEPTH-2 && B_addrb == DEPTH-1) 
                flag <= 1;
            else if (flag == 1 && cnt == DELAY && B_addra == DEPTH-1 && B_addrb == 0) 
                flag <= 0;   
            else
                flag <= flag;    
            if (flag && cnt == DELAY && B_addra == DEPTH-1 && B_addrb == 0)
                MUL_done <= 1;
            else 
                MUL_done <= 0;    
            PRE_done <= 0;
            POST_done <= 0;
            done <= 0; 
            if (cnt == DELAY)          
                mul_start <= 1;
            else 
                mul_start <= 0;      

            if (MUL_done && B_addra == DEPTH-1) begin //exceptional process to update cache for B[0]
				cache0 <= cache2;
				cache1 <= cache3;
				cache2 <= cache4;
				cache3 <= B_dia[WIDTH-0*m-1:WIDTH-1*m];
				cache4 <= B_dia[WIDTH-1*m-1:WIDTH-2*m];
			end
            else if (cnt == 0 && B_addra != DEPTH-1 && B_addrb != 0) begin //iteratively update cache for {B[1],B[2],...,B[DEPTH-1]}
				cache0 <= B_dia[WIDTH-0*m-1:WIDTH-1*m];
				cache1 <= B_dia[WIDTH-1*m-1:WIDTH-2*m];
				cache2 <= B_dia[WIDTH-2*m-1:WIDTH-3*m];
				cache3 <= B_dia[WIDTH-3*m-1:WIDTH-4*m];
				cache4 <= B_dia[WIDTH-4*m-1:WIDTH-5*m];
			end
            else begin
				cache0 <= cache0;
				cache1 <= cache1;
				cache2 <= cache2;
				cache3 <= cache3;
				cache4 <= cache4;
            end   

            A_we <= 0;
            A_addr <= A_addr;
            A_do <= 0;

            if (cnt == DELAY - 1) begin //read/write new data from RAM B at cnt == DELAY, it implicitly suggests DELAY >= 2   
                if (flag && B_addrb == DEPTH-1) begin
                    B_wea <= 1;
                    B_doa <= {cache[WIDTH-1:WIDTH-2*m], {m{1'b0}}, {m{1'b0}}, {m{1'b0}}};
                end     
                else if (B_addra != DEPTH-1 && B_addra != DEPTH-2) begin
                    B_wea <= 1;
                    B_doa <= cache;
                end
                else begin
                    B_wea <= 0;  
                    B_doa <= 0;   
                end       
                B_addra <= B_addra != DEPTH-1 ? B_addra + 1'b1 : 0;             
                B_web <= 0;
                B_addrb <= B_addrb != DEPTH-1 ? B_addrb + 1'b1 : 0;
                B_dob <= 0; 
            end
            else begin
                B_wea <= 0;
                B_addra <= B_addra;
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= B_addrb;
                B_dob <= 0;
            end


            if (mul_done) begin // mul_done when cnt == DELAY, write mem_C
                C_we <= 1;
                C_do <= C_di ^ mul_r;
            end 
            else begin
                C_we <= 0;    
                C_do <= 0;
            end 
            if (cnt == 0 && B_addra != DEPTH-1 && B_addrb != 0)
                C_addr <= C_addr + 1'b1;
            else 
                C_addr <= C_addr;               
        end

        POST: begin //in total DELAY+2 cycles (starting from cnt=1 to cnt=DELAY+2); load [b_45,b_46] to compute a1*b45 and [a2*b45,a2*b46]
            if (cnt == DELAY + 2) 
                cnt <= 0;
            else 
                cnt <= cnt + 1'b1;
            flag <= 0;
            if (cnt == DELAY + 1)
                POST_done <= 1;
            else 
                POST_done <= 0;  
            PRE_done <= 0;  
            MUL_done <= 0;
            if (cnt == DELAY + 1 && A_addr == DEPTH - 1)
                done <= 1;
            else 
                done <= 0;    

            if (cnt == DELAY+2) begin
				cache0 <= B_dia[WIDTH-0*m-1:WIDTH-1*m];
				cache1 <= B_dia[WIDTH-1*m-1:WIDTH-2*m];
				cache2 <= B_dia[WIDTH-2*m-1:WIDTH-3*m];
				cache3 <= B_dia[WIDTH-3*m-1:WIDTH-4*m];
				cache4 <= B_dia[WIDTH-4*m-1:WIDTH-5*m];
            end
            else begin
				cache0 <= cache0;
				cache1 <= cache1;
				cache2 <= cache2;
				cache3 <= cache3;
				cache4 <= cache4;

			end



           
            if (cnt == DELAY + 2)
                mul_start <= 1;
            else 
                mul_start <= 0;     

            //mem_A controller
            A_we <= 0;
            if (cnt == DELAY + 1) //ensure to get the mem_A data at the beginning cycle of state MUL
                A_addr <= A_addr != DEPTH-1 ? A_addr + 1'b1 : 0;
            else 
                A_addr <= A_addr;    

            A_do <= 0; 

            //mem_B controller
            if (cnt == 1) begin //finally update B[0], B_addrb = 0 here
                B_wea <= 0;
                B_addra <= B_addra;
                B_doa <= 0;
                B_web <= 1;
                B_addrb <= B_addrb;
                B_dob <= cache;
            end
            else if (cnt == 2) begin //read B[1],B[2]
                B_wea <= 0;
                B_addra <= 1;
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= 2;
                B_dob <= 0; 
            end
			else if (cnt == 4) begin //write B[1],B[2] as: [b2 b3 b4] <- [b2 b3 b4] + [b44 b45 b46]
                    B_wea <= 1;
                    B_addra <= 1;
				B_doa <= {cache0^B_dia[WIDTH-0*m-1:WIDTH-1*m], cache1^B_dia[WIDTH-1*m-1:WIDTH-2*m], cache2^B_dia[WIDTH-2*m-1:WIDTH-3*m], cache3^B_dia[WIDTH-3*m-1:WIDTH-4*m], cache4^B_dia[WIDTH-4*m-1:WIDTH-5*m]}; 
                    B_web <= 1;
                    B_addrb <= 2;
				B_dob <= {B_dib[WIDTH-0*m-1:WIDTH-1*m], B_dib[WIDTH-1*m-1:WIDTH-2*m], B_dib[WIDTH-2*m-1:WIDTH-3*m], B_dib[WIDTH-3*m-1:WIDTH-4*m], B_dib[WIDTH-4*m-1:WIDTH-5*m]}; 
			end
            else if (cnt == DELAY+0) begin // read B[-2] at cnt = DELAY+0
                B_wea <= 0;
                B_addra <= DEPTH-2;
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= 0;
                B_dob <= 0;
            end
            else begin // read B[-1] at cnt = DELAY+1
                B_wea <= 0;
                B_addra <= DEPTH-1;
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= 0;
                B_dob <= 0;
            end

            //mem_C controller  
            if (cnt == DELAY) begin
                C_we <= 1;
                C_do <= C_di ^ {mul10_op_c^mul20_op_c^mul30_op_c^mul40_op_c, mul21_op_c^mul31_op_c^mul41_op_c, mul32_op_c^mul42_op_c, mul43_op_c, {m{1'b0}}};
            end
            else if (cnt == DELAY + 1) begin
                C_we <= 1;
                C_do <= C_di ^ {{m{1'b0}}, {m{1'b0}}, {m{1'b0}}, {m{1'b0}}, {m{1'b0}}};
			end
            else begin
                C_we <= 0;
                C_do <= 0;
            end 
            if (cnt == DELAY-2 || cnt == DELAY)
                C_addr <= 1;
            else if (cnt == DELAY-1 || cnt == DELAY+1)
                C_addr <= 2;
            else 
                C_addr <= 0;                             
        end
        
		default: begin
        	PRE_done <= 0;
        	MUL_done <= 0;
            POST_done <= 0;
            done <= 0;
            mul_start <= 0;
            cnt <= 0;
            flag <= 0;
			cache0 <= 0;
			cache1 <= 0;
			cache2 <= 0;
			cache3 <= 0;
			cache4 <= 0;

            A_we <= 0;
            A_addr <= 0;
            A_do <= 0;

            B_wea <= 0;
            B_addra <= 0;
            B_doa <= 0;
            B_web <= 0;
            B_addrb <= 0;
            B_dob <= 0;

            C_we <= 0;
            C_addr <= 0;
            C_do <= 0;
        end
    endcase
end

assign mul00_op_a = A_di[WIDTH-0*m-1:WIDTH-1*m];
assign mul01_op_a = A_di[WIDTH-0*m-1:WIDTH-1*m];
assign mul02_op_a = A_di[WIDTH-0*m-1:WIDTH-1*m];
assign mul03_op_a = A_di[WIDTH-0*m-1:WIDTH-1*m];
assign mul04_op_a = A_di[WIDTH-0*m-1:WIDTH-1*m];

assign mul10_op_a = A_di[WIDTH-1*m-1:WIDTH-2*m];
assign mul11_op_a = A_di[WIDTH-1*m-1:WIDTH-2*m];
assign mul12_op_a = A_di[WIDTH-1*m-1:WIDTH-2*m];
assign mul13_op_a = A_di[WIDTH-1*m-1:WIDTH-2*m];
assign mul14_op_a = A_di[WIDTH-1*m-1:WIDTH-2*m];

assign mul20_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-2*m-1:WIDTH-3*m];
assign mul21_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-2*m-1:WIDTH-3*m];
assign mul22_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-2*m-1:WIDTH-3*m];
assign mul23_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-2*m-1:WIDTH-3*m];
assign mul24_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-2*m-1:WIDTH-3*m];

assign mul30_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-3*m-1:WIDTH-4*m];
assign mul31_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-3*m-1:WIDTH-4*m];
assign mul32_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-3*m-1:WIDTH-4*m];
assign mul33_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-3*m-1:WIDTH-4*m];
assign mul34_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-3*m-1:WIDTH-4*m];

assign mul40_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-4*m-1:WIDTH-5*m];
assign mul41_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-4*m-1:WIDTH-5*m];
assign mul42_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-4*m-1:WIDTH-5*m];
assign mul43_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-4*m-1:WIDTH-5*m];
assign mul44_op_a = A_addr == DEPTH-1 ? 0 : A_di[WIDTH-4*m-1:WIDTH-5*m];


assign mul00_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dib[WIDTH-0*m-1:WIDTH-1*m] :
                  B_dib[WIDTH-0*m-1:WIDTH-1*m];
assign mul01_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dib[WIDTH-1*m-1:WIDTH-2*m] :
                  B_dib[WIDTH-1*m-1:WIDTH-2*m];
assign mul02_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-2*m-1:WIDTH-3*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-2*m-1:WIDTH-3*m];
assign mul03_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-3*m-1:WIDTH-4*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-3*m-1:WIDTH-4*m];
assign mul04_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-4*m-1:WIDTH-5*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-4*m-1:WIDTH-5*m];

assign mul10_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-4*m-1:WIDTH-5*m] :
                  B_dia[WIDTH-4*m-1:WIDTH-5*m];
assign mul11_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dib[WIDTH-0*m-1:WIDTH-1*m] :
                  B_dib[WIDTH-0*m-1:WIDTH-1*m];
assign mul12_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-1*m-1:WIDTH-2*m];
assign mul13_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-2*m-1:WIDTH-3*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-2*m-1:WIDTH-3*m];
assign mul14_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-3*m-1:WIDTH-4*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-3*m-1:WIDTH-4*m];

assign mul20_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-3*m-1:WIDTH-4*m] :
                  B_dia[WIDTH-3*m-1:WIDTH-4*m];
assign mul21_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-4*m-1:WIDTH-5*m] :
                  B_dia[WIDTH-4*m-1:WIDTH-5*m];
assign mul22_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-0*m-1:WIDTH-1*m];
assign mul23_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-1*m-1:WIDTH-2*m];
assign mul24_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-2*m-1:WIDTH-3*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-2*m-1:WIDTH-3*m];

assign mul30_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? cache[WIDTH-4*m-1:WIDTH-5*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-2*m-1:WIDTH-3*m] :
                  B_dia[WIDTH-2*m-1:WIDTH-3*m];
assign mul31_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-3*m-1:WIDTH-4*m] :
                  B_dia[WIDTH-3*m-1:WIDTH-4*m];
assign mul32_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dia[WIDTH-4*m-1:WIDTH-5*m];
assign mul33_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-0*m-1:WIDTH-1*m];
assign mul34_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-1*m-1:WIDTH-2*m];

assign mul40_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? cache[WIDTH-3*m-1:WIDTH-4*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-1*m-1:WIDTH-2*m] :
                  B_dia[WIDTH-1*m-1:WIDTH-2*m];
assign mul41_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? cache[WIDTH-4*m-1:WIDTH-5*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-2*m-1:WIDTH-3*m] :
                  B_dia[WIDTH-2*m-1:WIDTH-3*m];
assign mul42_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dia[WIDTH-3*m-1:WIDTH-4*m];
assign mul43_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-1*m-1:WIDTH-2*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dia[WIDTH-4*m-1:WIDTH-5*m];
assign mul44_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-0*m-1:WIDTH-1*m] :
                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :
                  B_dib[WIDTH-0*m-1:WIDTH-1*m];


assign mul_r0 = mul00_op_c ^ mul10_op_c ^ mul20_op_c ^ mul30_op_c ^ mul40_op_c;
assign mul_r1 = mul01_op_c ^ mul11_op_c ^ mul21_op_c ^ mul31_op_c ^ mul41_op_c;
assign mul_r2 = mul02_op_c ^ mul12_op_c ^ mul22_op_c ^ mul32_op_c ^ mul42_op_c;
assign mul_r3 = mul03_op_c ^ mul13_op_c ^ mul23_op_c ^ mul33_op_c ^ mul43_op_c;
assign mul_r4 = mul04_op_c ^ mul14_op_c ^ mul24_op_c ^ mul34_op_c ^ mul44_op_c;
assign mul_r = {mul_r0, mul_r1, mul_r2, mul_r3, mul_r4};

assign cache = {cache0, cache1, cache2, cache3, cache4};

endmodule
