`include "clog2.v" 
`include "define.v"

module gs_elim_ctrl #(parameter k = 4, l = 4, d = 2, READ_DELAY = 2)(
    input wire clk,
    input wire rst_b,  
    input wire start,  
    output wire done,

    output reg SA_mode,
    output reg SA_start,
    output reg SA_swap,

    input wire [l-1:0] mem_din,
    output reg [`CLOG2(k)-1:0] mem_addr,
    output reg mem_rw
);

parameter ls2 = l/2;

// FSM internal control signals
reg tri_read_done, tri_swap_done, tri_write1_done, tri_write2_done;
reg sys_read_done, sys_swap_done, sys_write_done;

reg [`CLOG2(READ_DELAY+k)-1:0] cnt;
reg [`CLOG2($ceil(k/d)+1)-1:0] round;

reg first_half_lock, second_half_lock;
reg first_half_except, second_half_except; // 1: exception detected   0: no exception
reg first_half_reg, second_half_reg;
wire first_half, second_half;
reg [`CLOG2(k)-1:0] min_addr, max_addr;

assign done = sys_write_done;

assign first_half = mem_din[l-1:l-ls2] == {(ls2){1'b0}} ? 1'b1 : 1'b0; //all zero --- 1'b1   non zero --- 1'b0
assign second_half = mem_din[l-ls2-1:0] == {(ls2){1'b0}} ? 1'b1 : 1'b0;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------  
parameter         INIT = 4'd0, //idle, then start rng
                  TRI_READ = 4'd1, //read k-(i-1)d rows from memory (i=1,2,...,k/d)
                  TRI_SWAP = 4'd2, //start load-off signal
                  TRI_WRITE1 = 4'd3, //write unsorted rows to memory 
                  TRI_WRITE2 = 4'd4, //write sorted rows to memory
                  TRANSITION = 4'd8,
                  SYS_READ = 4'd5, //read d rows from memory
                  SYS_SWAP = 4'd6, //start systemization
                  SYS_WRITE = 4'd7; //write final rrefs to memory


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
                next_state = TRI_READ;
            else
                next_state = INIT;  

        TRI_READ:
            if (tri_read_done)
                next_state = TRI_SWAP;
            else 
                next_state = TRI_READ;
        
        TRI_SWAP:
            if (tri_swap_done)
                next_state = TRI_WRITE1;
            else 
                next_state = TRI_SWAP;

        TRI_WRITE1:
            if (tri_write1_done)
                next_state = TRI_WRITE2;  
            else   
                next_state = TRI_WRITE1;

        TRI_WRITE2: 
            if (tri_write2_done && round == $ceil(k/d))
                next_state = TRANSITION;
            else if (tri_write2_done)
                next_state = TRI_READ;
            else 
                next_state = TRI_WRITE2;

        TRANSITION: begin
            next_state = SYS_READ;
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
            tri_read_done <= 0;
            tri_swap_done <= 0; 
            tri_write1_done <= 0; 
            tri_write2_done <= 0;
            sys_read_done <= 0; 
            sys_swap_done <= 0;
            sys_write_done <= 0;  

            SA_swap <= 0;
            SA_mode <= 0;
            SA_start <= 0; 

            mem_addr <= 0;
            mem_rw <= 0;

            cnt <= 0;   
            round <= 1;      

            first_half_lock <= 0;
            second_half_lock <= 0;  
            first_half_except <= 1; //initially, except set to '1'
            second_half_except <= 1;
            first_half_reg <= 0; //initially, first half should be non-zero
            second_half_reg <= 0;
            min_addr <= 0;
            max_addr <= 0;
        end

        TRI_READ: begin
            if (cnt == READ_DELAY+k-(round-1)*d-2) //jump to TRI_SWAP when cnt = READ_DELAY+k-(round-1)*d-1
                tri_read_done <= 1;
            else 
                tri_read_done <= 0;

            if (cnt < READ_DELAY+k-(round-1)*d-1) //cnt = 0, 1, 2, READ_DELAY+k-(round-1)*d-1
                cnt <= cnt + 1'b1;
            else  
                cnt <= 0;
          
            if (cnt < k-(round-1)*d-1)
                mem_addr <= mem_addr + 1'b1;
            else 
                mem_addr <= mem_addr;    
            mem_rw <= 0;

            if (cnt == READ_DELAY-1)
                SA_start <= 1;
            else 
                SA_start <= 0;

            if (tri_read_done)
                SA_swap <= 1;
            else 
                SA_swap <= 0;  
            //reset except signal to '1' for each round
            first_half_except <= 1;
            second_half_except <= 1;  
        end

        TRI_SWAP: begin
            if (cnt == d-2) //jump to TRI_WRITE1 when cnt = d-1
                tri_swap_done <= 1;
            else 
                tri_swap_done <= 0;

            if (cnt < d-1) //cnt = 0, 1, ..., d-1
                cnt <= cnt + 1'b1;
            else 
                cnt <= 0;  

            if (tri_swap_done)
                SA_swap <= 0;
            else     
                SA_swap <= 1;  
        end

        TRI_WRITE1: begin //write k-id entries to memory
            SA_swap <= 0;

            if (round != $ceil(k/d)) begin //if not last round
                if (cnt == l-3)
                    tri_write1_done <= 1;
                else 
                    tri_write1_done <= 0;   

                if (cnt < l-2) //cnt = 0,1,...,l-k+i*d-1,...,l-2
                    cnt <= cnt + 1'b1;
                else 
                    cnt <= 0;     

                if (cnt == l-k+round*d-1-1) begin //start from addr=round*d
                    mem_addr <= round*d;
                    mem_rw <= 1;
                end
                else if (cnt > l-k+round*d-1-1 && cnt < l-2) begin //k-id-1 cycles
                    mem_addr <= mem_addr + 1'b1;
                    mem_rw <= 1;
                end
                else if (cnt == l-2) begin
                    mem_addr <= round*d-1;
                    mem_rw <= 1;
                end
                else begin
                    mem_addr <= 0;
                    mem_rw <= 0;            
                end 
            end 

            else begin // if last round
                if (cnt == l-k+round*d-3)
                    tri_write1_done <= 1;
                else 
                    tri_write1_done <= 0;

                if (cnt < l-k+round*d-2) //cnt = 0,1,...,l-k+i*d-2
                    cnt <= cnt + 1'b1;
                else 
                    cnt <= 0;   

                if (cnt == l-k+round*d-2) begin
                    mem_addr <= round*d-1;
                    mem_rw <= 1;  
                end 
                else begin
                    mem_addr <= 0;
                    mem_rw <= 0;
                end                   
            end                
        end

        TRI_WRITE2: begin //reversely write d entries to memory
            //write logic
            if (cnt == d-2)
                tri_write2_done <= 1;
            else 
                tri_write2_done <= 0; 

            if (cnt < d-1) //cnt = 0,1,...,d-1
                cnt <= cnt + 1'b1;
            else 
                cnt <= 0;

            if (tri_write2_done)
                round <= round + 1'b1;
            else 
                round <= round;

            if (cnt < d-1) begin
                mem_addr <= mem_addr - 1'b1;
                mem_rw <= 1;
            end
            else begin //last cycle, prepare addr=(i-1)*d for the next round of Gauss Elimination
                mem_addr <= (round-1+1)*d;
                mem_rw <= 0;
            end  

            //locate logic
            first_half_except <= first_half_except & first_half;
            first_half_reg <= first_half;
            if (~first_half_lock & ~first_half & first_half_reg & ~second_half_reg) begin
                min_addr <= mem_addr + 1;
                first_half_lock <= 1;
            end
            else if (tri_write2_done & (first_half_except & first_half) & (~first_half_lock)) begin 
                min_addr <= mem_addr;
                first_half_lock <= 1;
            end 
            else begin
                min_addr <= min_addr;
                first_half_lock <= first_half_lock;
            end

            second_half_except <= second_half_except & second_half;
            second_half_reg <= second_half;
            if (~second_half_lock & ~second_half & first_half & second_half_reg & first_half_reg) begin //if last time {first_half,second_half} = {0,0} and this time {0,1}
                max_addr <= mem_addr;
                second_half_lock <= 1;
            end
            else if (tri_write2_done & (second_half_except & second_half) & (first_half_except & first_half) & (~second_half_lock)) begin //if find d consecutive {0,0} sequences in the last cycle, exception occurs
                max_addr <= mem_addr - 1;
                second_half_lock <= 1;
            end
            else begin
                max_addr <= max_addr;
                second_half_lock <= second_half_lock;
            end

        end

        TRANSITION: begin
            SA_mode <= 1;
            mem_addr <= min_addr;
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

            if (cnt < d && mem_addr < max_addr)
                mem_addr <= mem_addr + 1'b1;
            else 
                mem_addr <= mem_addr;    
            mem_rw <= 0;

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
                mem_rw <= 1;
                mem_addr <= mem_addr-1;
            end
            else begin
                mem_rw <= 0;
                mem_addr <= d;
            end
        end

    endcase
end

endmodule
