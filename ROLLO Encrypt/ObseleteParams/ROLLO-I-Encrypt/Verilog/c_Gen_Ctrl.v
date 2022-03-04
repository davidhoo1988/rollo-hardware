`include "clog2.v" 
`include "define.v"

module c_Gen_Ctrl #(parameter n = `N, m = `M, r = `R, d = `D, digit = `DIGIT)(
    input           clk,
    input           start,
    input           rst_b,

    input           rng_finish,
    input [95:0]    rng_data,
    output reg      rng_start,

    input [m-1:0]               E_din,
    output reg                  E_rw,
    output reg [`CLOG2(r)-1:0]  E_addr,
    output reg [r:0]            E_ctrlw,

    //write e1/e2
    input [m*digit-1:0]                                     e1_din,
    output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0] e1_addr,
    output reg [m*digit-1:0]                              e1_dout,
    output reg                                            e1_rw,
  input [m*digit-1:0]                                     e2_din,
  output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   e2_addr,
  output reg [m*digit-1:0]                                e2_dout,
  output reg                                              e2_rw,

  //read/write c
    input [m*digit-1:0]                                     c_din,
    output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   c_addr,
    output reg [m*digit-1:0]                                c_dout,
    output reg                                              c_rw,

  input           gf2mz_done,
  output reg      gf2mz_start,

    output reg          done
    );

reg base_done_tmp, base_done;
reg others_done;

reg [5:0] cnt; //6-bit counter
reg [1:0] e_status; //01 -- e1   10 -- e2
reg [1:0] rnd_pool_valid;

//inner component
parameter rnd_num = 96/digit; //floor(96/digit)
reg [rnd_num*digit-1:0] rnd_pool;
reg [`FLOG2((n/digit) + ((n%digit) != 0)) - 1 : 0] occupy_lut;

reg [95:0] rng_data_cache;


//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------  
parameter         INIT = 3'd0, //idle, then start rng
                  BASE = 3'd1,
                  OTHERS = 3'd2, //generate the error space E with dim(E)=r
                  MUL = 3'd3, //c'= h*e2 
                  ADD = 3'd4; //c = e1+c'


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
                next_state = BASE;
            else
                next_state = INIT;  

        BASE:
            if (base_done)
                next_state = OTHERS;
            else 
                next_state = BASE;    

        OTHERS:
            if (others_done && e_status == 2)
                next_state = MUL;
            else if (others_done && e_status == 1)
                  next_state = BASE;    
            else   
                next_state = OTHERS;   

        MUL:
            if (gf2mz_done)
              next_state = ADD;
            else 
              next_state = MUL;    

        ADD:
            if (done)
                next_state = INIT;
            else    
                next_state = ADD;    
   
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
          if (start) begin 
            //start rng 
            rng_start <= 1;
            e_status <= 1;
          end
          else begin
            rng_start <= 0;
            e_status <= 0;
          end
          E_rw <= 0;
          E_addr <= 0;
          E_ctrlw <= 0;

          e1_addr <= 0;
          e1_dout <= 0;
          e1_rw <= 0;
          e2_addr <= 0;
          e2_dout <= 0;
          e2_rw <= 0;
          c_addr <= 0;
          c_dout <= 0;
          c_rw <= 0;

          cnt <= 0;

          rnd_pool_valid <= 0;
          rnd_pool <= 0;
          occupy_lut <= 0;
          rng_data_cache <= 0;

          base_done <= 0;
          base_done_tmp <= 0;
          others_done <= 0;
          gf2mz_start <= 0;
          done <= 0;
        end

        BASE: begin
            rng_start <= 0;
            if (base_done) begin
                E_rw <= 0;
                E_addr <= 0; //get floor( log2( ceil(n/digit) ) )
                E_ctrlw <= 0;
            end 
            else begin //traverse all elements in E register file
                E_rw <= 0;
            if (E_addr != r-1) begin
                  E_addr <= E_addr + 1'b1;
            end
            else begin
              E_addr <= E_addr;  
            end
                E_ctrlw <= 0;
            end

          if (base_done)
            cnt <= 0;
          else   
            cnt <= cnt + 1'b1;   
            
          if (e_status == 1) begin
            if (cnt >= 1 && cnt <= 1+r-1)
              e1_dout <= {e1_dout[m*(digit-1)-1:0],E_din};
            else 
              e1_dout <= e1_dout;   
            e1_rw <= 0;
            if (base_done_tmp) begin
              e1_rw <= 1;
              e1_addr <= occupy_lut;
            end
            else begin
              e1_rw <= 0;
              e1_addr <= 0;
            end
          end
          else if (e_status == 2) begin
            if (cnt >= 1 && cnt <= 1+r-1)
              e2_dout <= {e2_dout[m*(digit-1)-1:0],E_din};
            else 
              e2_dout <= e2_dout;   
            e1_rw <= 0;
            if (base_done_tmp) begin
              e2_rw <= 1;
              e2_addr <= occupy_lut;
            end
            else begin
              e2_rw <= 0;
              e2_addr <= 0;
            end
          end

            if (rng_finish)
                    rnd_pool <= rng_data[95:95-rnd_num*digit+1];
                else if (base_done_tmp)
                    rnd_pool <= {rnd_pool[(rnd_num-1)*digit-1:0], {digit{1'b0}}};
                else
                    rnd_pool <= rnd_pool;

          rnd_pool_valid <= 0;

                if (rng_finish)
                    occupy_lut <= rng_data[96-1:96-`FLOG2((n/digit) + ((n%digit) != 0))];
                else 
                    occupy_lut <= occupy_lut;   
                
                if (rng_finish)
                    base_done_tmp <= 1;
                else    
                    base_done_tmp <= 0; 

          if (rng_finish)
            rng_start <= 1;
          else 
            rng_start <= 0;  
          base_done <= base_done_tmp;
          others_done <= 0;
          done <= 0;            
        end

        OTHERS: begin
          if (rng_finish) begin
            rng_start <= 1;
            rng_data_cache <= rng_data;
          end
          else begin
            rng_start <= 0;
            rng_data_cache <= rng_data_cache;
          end

          if (rnd_pool == 0) //update entropy pool if rnd_pool is empty
            rnd_pool <= rng_data_cache[95:95-rnd_num*digit+1]; 
          else 
            rnd_pool <= {rnd_pool[(rnd_num-1)*digit-1:0], {digit{1'b0}}};

          if (rnd_pool != 0)
            rnd_pool_valid[0] <= 1;
          else 
            rnd_pool_valid[0] <= 0;
          rnd_pool_valid[1] <= rnd_pool_valid[0];  
          
          if (others_done)
            cnt <= 0;
          else if (rnd_pool_valid[1])//cnt = digit(r) indicates e_dout is ready
            cnt <= cnt == digit-1 ? 0 : cnt + 1;
          else 
            cnt <= cnt;  

          if (others_done)
            E_ctrlw <= 0;
          else  
            E_ctrlw <= {1'b1,rnd_pool[rnd_num*digit-1:rnd_num*digit-digit]};

          if (rnd_pool_valid[1] && cnt == digit-1 && ((e1_addr == (n/digit) + ((n%digit) != 0) - 1) || (e2_addr == (n/digit) + ((n%digit) != 0) - 1)))
            others_done <= 1;
          else 
            others_done <= 0;

          if (others_done && e_status == 1)
            e_status <= 2;
          else 
            e_status <= e_status;   

          if (others_done && e_status == 2)
            gf2mz_start <= 1;
          else 
            gf2mz_start <= 0;    

          if (e_status == 1) begin
            if (rnd_pool_valid[1])
              e1_dout <= {e1_dout[m*(digit-1)-1:0], E_din};
            else 
              e1_dout <= e1_dout;

            if (rnd_pool_valid[1] && cnt == digit-1) 
              e1_rw <= 1;
            else 
              e1_rw <= 0;

            if (rnd_pool_valid[1] && cnt == digit-1)//check if e1_addr has excluded lut_occupy
              e1_addr <= e1_addr != occupy_lut ? e1_addr :
                                    e1_addr == (n/digit) + ((n%digit) != 0) - 1 ? 0 : e1_addr + 1;
            else if (e1_rw)                      
              e1_addr <= e1_addr + 1'b1;
            else 
              e1_addr <= e1_addr;                
          end
          else if (e_status == 2) begin
            if (others_done) begin
              e2_dout <= 0;
              e2_rw <= 0;
              e2_addr <= 0;
            end
            else begin
              if (rnd_pool_valid[1])
                e2_dout <= {e2_dout[m*(digit-1)-1:0], E_din};
              else 
                e2_dout <= e2_dout;

              if (rnd_pool_valid[1] && cnt == digit-1) 
                e2_rw <= 1;
              else 
                e2_rw <= 0;

              if (rnd_pool_valid[1] && cnt == digit-1)//check if e2_addr has excluded lut_occupy
                e2_addr <= e2_addr != occupy_lut ? e2_addr :
                                      e2_addr == (n/digit) + ((n%digit) != 0) - 1 ? 0 : e2_addr + 1;
              else if (e2_rw)                      
                e2_addr <= e2_addr + 1'b1;
              else 
                e2_addr <= e2_addr; 
            end               
          end
        end

        MUL: begin
          gf2mz_start <= 0;
          e_status <= 0;
          e1_rw <= 0;
          e1_addr <= 0;
          e1_dout <= 0;
          e2_rw <= 0;
          e2_addr <= 0;
          e2_dout <= 0;
        end

        ADD: begin
           cnt <= cnt == 2 ? 0 : cnt + 1'b1;

           if (cnt == 1) begin
               c_rw <= 1'b1;
               c_dout <= c_din ^ e1_din;
           end
           else begin
               c_rw <= 0;
               c_dout <= 0;
           end
           if (cnt == 2) begin
               e1_addr <= e1_addr + 1'b1;
               c_addr <= c_addr + 1'b1;              
           end
           else begin
               e1_addr <= e1_addr;
               c_addr <= c_addr;
           end

           if ( c_rw && c_addr == ((n/digit) + ((n%digit) != 0) - 1) )
                done <= 1;
           else
                done <= 0;
        end

    endcase
end


endmodule