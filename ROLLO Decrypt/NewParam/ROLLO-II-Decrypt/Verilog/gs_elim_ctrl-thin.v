`include "clog2.v" 
`include "define.v"
//gs_elim_ctrl can process either k*l or k1*l matrix (k>k1) using d*l systolic array

module gs_elim_ctrl #(parameter k = 6, k1 = 5, l = 4, d = 2, READ_DELAY = 2)(
    input wire clk,
    input wire rst_b,  
    input wire start,  
    input wire mat_sel, //switch the matrix size  0 -> k  1 -> k1
    input wire is_last, // if 1, perform systemization and write mem, otherwise write mem with intersection result
    output wire done,

    output reg SA_mode,
    output reg SA_start,
    output reg SA_swap,

    input wire [l-1:0] SA_din,
    input wire [l-1:0] mem_dina, //read port-a for error space E
    output reg [l-1:0] mem_doutb, //write port-b for data move
    output reg [`CLOG2(k)-1:0] mem_addra, mem_addrb,
    output reg mem_rwa, mem_rwb,
    output reg mem_wr_en // enable the port-b write of memory for moving to the first few rows
);

parameter ls2 = l/2;
parameter rd = `R*`D;

// FSM internal control signals
reg tri_done;
reg sys_read_done, sys_swap_done, sys_write_done;
reg mem_write_done;

reg [`CLOG2(l+k+2*d-2+READ_DELAY+1)-1:0] cnt; //be careful! either cnt <= l+k+2d-2+DELAY
reg [`CLOG2($ceil(1.0*k/d)+1)-1:0] round;
reg [`CLOG2($ceil(1.0*k/d)*d+1)-1:0] round_d;
reg [`CLOG2(k)-1:0] reg_k;

reg first_half_lock, second_half_lock;
reg first_half_except, second_half_except; // 1: exception detected   0: no exception
reg first_half_reg, second_half_reg;
wire first_half, second_half;
reg [`CLOG2(k)-1:0] min_addr, max_addr, intersect_num;

assign done = sys_write_done | mem_write_done;

assign first_half = SA_din[l-1:l-ls2] == {(ls2){1'b0}} ? 1'b1 : 1'b0; //all zero --- 1'b1   non zero --- 1'b0
assign second_half = SA_din[l-ls2-1:0] == {(ls2){1'b0}} ? 1'b1 : 1'b0;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------  
parameter         INIT = 4'd0, //idle, then start rng
                  TRI = 4'd1, //read k-(i-1)d rows from memory (i=1,2,...,k/d)
                  TRANSITION = 4'd4,
                  SYS_READ = 4'd5, //read d rows from memory
                  SYS_SWAP = 4'd6, //start systemization
                  SYS_WRITE = 4'd7, //write final rrefs to memory
                  MEM_WRITE = 4'd8; //write the RSR intersection result to the first r*d rows of memory


//----------------------------------------------------------
//1st always block, sequential state transition
//----------------------------------------------------------
reg    [3:0]   state, next_state;
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
                next_state = TRI;
            else
                next_state = INIT;  

        TRI: 
            if (tri_done && round == (reg_k+d-1)>>`CLOG2(d)) //(k+d-1)>>`CLOG2(d) == ceil(1.0*k/d) if d is a power of two
                next_state = TRANSITION;
            else 
                next_state = TRI;

        TRANSITION: begin
            if (is_last)
                next_state = SYS_READ;
            else 
                next_state = MEM_WRITE;    
        end

        SYS_READ:
            if (sys_read_done)
                next_state = SYS_SWAP;
            else 
                next_state = SYS_READ;

        SYS_SWAP:
            if (sys_swap_done)
                next_state = SYS_WRITE;
            else 
                next_state = SYS_SWAP;    

        SYS_WRITE: 
            if (sys_write_done)
                next_state = INIT;
            else 
                next_state = SYS_WRITE;   

        MEM_WRITE:
            if (mem_write_done)
                next_state = INIT;
            else 
                next_state = MEM_WRITE;                        

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
            tri_done <= 0;
            sys_read_done <= 0; 
            sys_swap_done <= 0;
            sys_write_done <= 0;  

            SA_swap <= 0;
            SA_mode <= 0;
            SA_start <= 0; 

            mem_addra <= 0;
            mem_rwa <= 0;
            mem_addrb <= 0;
            mem_rwb <= 0;
            mem_wr_en <= 0;

            cnt <= 0;   
            round <= 1;   
            round_d <= d;   
            reg_k <= mat_sel ? $ceil(1.0*k1/d)*d : $ceil(1.0*k/d)*d;

            first_half_lock <= 0;
            second_half_lock <= 0;  
            first_half_except <= 1; //initially, except set to '1'
            second_half_except <= 1;
            first_half_reg <= 0; //initially, first half should be non-zero
            second_half_reg <= 0;
            min_addr <= 0;
            max_addr <= 0;
            intersect_num <= 0;
        end

        TRI: begin
            //read/write logic
            if (cnt == l+reg_k+3*d-round_d-3+READ_DELAY)
                tri_done <= 1;
            else 
                tri_done <= 0;

            if (cnt < l+reg_k+3*d-round_d-2+READ_DELAY) //cnt = 0,1,...,l+k+(3-i)d-2+delay, including TRI_READ and TRI_SWAP
                cnt <= cnt + 1;
            else 
                cnt <= 0;   

            if (tri_done) begin
                round <= round + 1;
                round_d <= round_d + d;
            end 

            if (cnt == READ_DELAY-1)
                SA_start <= 1;
            else 
                SA_start <= 0;

            if (cnt >= reg_k-(round_d-d)+READ_DELAY-1 && cnt <= reg_k-(round_d-2*d)-1+READ_DELAY-1)  // keep 'swap' for d cycles
                SA_swap <= 1;
            else    
                SA_swap <= 0;    

            if ( (cnt >= 0) && (cnt <= reg_k-(round_d-d)-1-1)  )
                mem_addra <= mem_addra + 1; //read mem used in TRI_READ 
            else if (cnt == l+reg_k-(round_d-3*d)-2+READ_DELAY)    
                mem_addra <= round_d; //set overall init addr for TRI       
            else 
                mem_addra <= 0;  

            mem_rwa <= 0;  

            if (round != (reg_k+d-1)>>`CLOG2(d) && cnt == l+2*d-1+READ_DELAY-1)
                mem_addrb <= round_d; //set init addr for TRI_WRITE1
            else if (cnt == l+reg_k-(round_d-2*d)-1+READ_DELAY-1)
                mem_addrb <= round_d-1; //set init addr for TRI_WRITE2
            else if ( (cnt >= l+2*d-1+READ_DELAY) && (cnt <= l+reg_k-(round_d-2*d)-2+READ_DELAY-1) )
                mem_addrb <= mem_addrb + 1; // write mem used in TRI_WRITE1
            else if (cnt >= l+reg_k-(round_d-2*d)-1+READ_DELAY && cnt <= l+reg_k-(round_d-3*d)-2+READ_DELAY-1)
                mem_addrb <= mem_addrb - 1; //write mem used in TRI_WRITE2       
            else 
                mem_addrb <= 0;    

            if (cnt >= l+2*d-1+READ_DELAY-1 && cnt <= l+reg_k-(round_d-3*d)-2+READ_DELAY-1)
                mem_rwb <= 1; //write mem for consecutive k-(i-1)d cycles
            else 
                mem_rwb <= 0;   


            //locate logic enabled in the last d cycles of state 'TRI', prerequisite: the matrix must have prefix and suffix
            if (cnt >= l+reg_k+(2*d-round_d)-1+READ_DELAY && cnt <= l+reg_k-(round_d-3*d)-2+READ_DELAY) begin
                if (tri_done)
                    first_half_except <= 1;
                else 
                    first_half_except <= first_half_except & first_half;
                first_half_reg <= first_half;
                if (~first_half_lock & ~first_half & first_half_reg & ~second_half_reg) begin //normal case, locate the min_addr if 1-0 transition found in first_half
                    min_addr <= mem_addrb + 1;
                    first_half_lock <= 1;
                end
                else if (tri_done & (first_half_except & first_half) & (~first_half_lock)) begin  //abnomral case, note first_half_except is refreshed to '1' in each round
                    min_addr <= mem_addrb;
                    first_half_lock <= 1;
                end 
                else begin
                    min_addr <= min_addr;
                    first_half_lock <= first_half_lock;
                end

                if (tri_done)
                    second_half_except <= 1;
                else     
                    second_half_except <= second_half_except & second_half;
                second_half_reg <= second_half;
                if (~second_half_lock & ~second_half & first_half & second_half_reg & first_half_reg) begin //if last time {first_half,second_half} = {0,0} and this time {0,1}, implying max_addr found (normal case)
                    max_addr <= mem_addrb;
                    second_half_lock <= 1;
                end
                else if (tri_done & (second_half_except & second_half) & (first_half_except & first_half) & (~second_half_lock)) begin //if find d consecutive {0,0} sequences in the last cycle, exception occurs
                    max_addr <= mem_addrb - 1;
                    second_half_lock <= 1;
                end
                else begin
                    max_addr <= max_addr;
                    second_half_lock <= second_half_lock;
                end 
            end
        end

        TRANSITION: begin
            SA_mode <= is_last? 1 : 0;
            mem_addra <= min_addr;
            intersect_num <= max_addr-min_addr;
        end

        SYS_READ: begin
            if (cnt == READ_DELAY+d-2) //jump to SYS_SWAP when cnt = delay+d-1
                sys_read_done <= 1;
            else 
                sys_read_done <= 0;    

            if (cnt < READ_DELAY+d-1) //cnt = 0,1,...,delay+d-1
                cnt <= cnt + 1;
            else 
                cnt <= 0;

            if (cnt < d && mem_addra < max_addr)
                mem_addra <= mem_addra + 1'b1;
            else 
                mem_addra <= mem_addra;    
            mem_rwa <= 0;

            if (cnt == READ_DELAY-1)
                SA_start <= 1;
            else 
                SA_start <= 0; 
        end

        SYS_SWAP: begin
            if (cnt == d+l-3)
                sys_swap_done <= 1;
            else 
                sys_swap_done <= 0;    

            if (cnt < d+l-2) //cnt = 0,1,...,d+l-2
                cnt <= cnt + 1'b1;
            else 
                cnt <= 0; 

            if (cnt == d+l-3)
                SA_swap <= 1;
            else 
                SA_swap <= 0;      
        end

        SYS_WRITE: begin
            SA_swap <= 0;

            if (cnt == l+d-3)
                sys_write_done <= 1;
            else 
                sys_write_done <= 0; 

            if (cnt < l+d-2) //cnt = 0,1,2,...,l+d-2
                cnt <= cnt + 1'b1;
            else 
                cnt <= 0;

            if (cnt >= l-2 && cnt <= l+d-3) begin //cnt = l-1,...,l+d-2, write d entries reversely
                mem_rwa <= 1;
                mem_addra <= mem_addra-1;
            end
            else begin
                mem_rwa <= 0;
                mem_addra <= d;
            end
        end

        MEM_WRITE: begin
            if (cnt == READ_DELAY+rd-1)
                mem_write_done <= 1;
            else    
                mem_write_done <= 0;

            if (cnt < READ_DELAY+rd) //cnt = 0,1,...,2+r*d
                cnt <= cnt + 1;
            else 
                cnt <= 0;  

            mem_wr_en <= 1;
            //port-a read    
            if (mem_addra < max_addr)
                mem_addra <= mem_addra + 1'b1;
            else 
                mem_addra <= mem_addra;    
            mem_rwa <= 0;

            //port-b write
            if (cnt == READ_DELAY) begin //start writing the first row
                mem_addrb <= 0;
                mem_doutb <= {mem_dina[ls2-1:0], mem_dina[ls2-1:0]};
                mem_rwb <= 1; 
            end
            else if (cnt > READ_DELAY && cnt <= READ_DELAY+intersect_num) begin // writing the informative rows
                mem_addrb <= mem_addrb + 1'b1;
                mem_doutb <= {mem_dina[ls2-1:0], mem_dina[ls2-1:0]};
                mem_rwb <= 1;
            end
            else if (cnt <= READ_DELAY+rd-1) begin // padding the remaining with zero's
                mem_addrb <= mem_addrb + 1'b1;  
                mem_doutb <= 0;
                mem_rwb <= 1;
            end 
            else begin
                mem_addrb <= 0;
                mem_doutb <= 0;
                mem_rwb <= 0;
            end    
        end

    endcase
end

endmodule
