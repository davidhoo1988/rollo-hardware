//`include "clog2.v" 
//`include "define.v"

module c_Gen_Ctrl #(parameter n = `N, m = `M, wr = `Wr, w = `W, digit = `DIGIT)(
    input           clk,
    input           start,
    input           rst_b,

    input           rng_finish,
    input [95:0]    rng_data,
    output reg      rng_start,

    input [m-1:0]               E_din,
    output reg                  E_rw,
    output reg [`CLOG2(wr)-1:0]  E_addr,
    output reg [wr:0]            E_ctrlw,

    //write r1/r2/er
    input [m*digit-1:0]                                     r1_din,
    output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0] r1_addr,
    output reg [m*digit-1:0]                              r1_dout,
    output reg                                            r1_rw,
  input [m*digit-1:0]                                     r2_din,
  output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   r2_addr,
  output reg [m*digit-1:0]                                r2_dout,
  output reg                                              r2_rw,
  input [m*digit-1:0]                                     er_din,
  output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   er_addr,
  output reg [m*digit-1:0]                                er_dout,
  output reg                                              er_rw,

  //read/write c=[sr,se]
    input [m*digit-1:0]                                     sr_din,
    output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   sr_addr,
    output reg [m*digit-1:0]                                sr_dout,
    output reg                                              sr_rw,
    input [m*digit-1:0]                                     se_din,
    output reg [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   se_addr,
    output reg [m*digit-1:0]                                se_dout,
    output reg                                              se_rw,

  input           gf2mz_done,
  output reg      gf2mz_start,

    output reg          done
    );

reg base_done_tmp, base_done;
reg others_done;

reg [5:0] cnt; //6-bit counter
reg [1:0] e_status; //01 -- r1   10 -- r2   11 -- er
reg [1:0] rnd_pool_valid;

//inner component
parameter rnd_num = 96/digit; //floor(96/digit)
reg [rnd_num*digit-1:0] rnd_pool;
reg [`FLOG2((n/digit) + ((n%digit) != 0)) - 1 : 0] occupy_lut;

reg [95:0] rng_data_cache;
reg [4:0] rnd_pool_cnt;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------  
parameter         INIT = 3'd0, //idle, then start rng
                  BASE = 3'd1,
                  OTHERS = 3'd2, //generate the error space E with dim(E)=wr
                  MUL = 3'd3, //sr'= h*r2   se'= s*r2
                  ADD = 3'd4; //sr = r1+sr'  se = er+se'


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
            if (others_done && e_status == 3)
                next_state = MUL;
            else if (others_done && e_status == 1)
                next_state = BASE;    
            else if (others_done && e_status == 2)
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

          r1_addr <= 0;
          r1_dout <= 0;
          r1_rw <= 0;
          r2_addr <= 0;
          r2_dout <= 0;
          r2_rw <= 0;
          er_addr <= 0;
          er_dout <= 0;
          er_rw <= 0;

          se_addr <= 0;
          se_dout <= 0;
          se_rw <= 0;
          sr_addr <= 0;
          sr_dout <= 0;
          sr_rw <= 0;

          cnt <= 0;

          rnd_pool_valid <= 0;
          rnd_pool <= 0;
          occupy_lut <= 0;
          rng_data_cache <= 0;
          rnd_pool_cnt <= 0;

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
            if (E_addr != wr-1) begin
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
            if (cnt >= 1 && cnt <= 1+wr-1)
              r1_dout <= {r1_dout[m*(digit-1)-1:0],E_din};
            else 
              r1_dout <= r1_dout;   
            r1_rw <= 0;
            if (base_done_tmp) begin
              r1_rw <= 1;
              r1_addr <= occupy_lut;
            end
            else begin
              r1_rw <= 0;
              r1_addr <= 0;
            end
          end
          else if (e_status == 2) begin
            if (cnt >= 1 && cnt <= 1+wr-1)
              r2_dout <= {r2_dout[m*(digit-1)-1:0],E_din};
            else 
              r2_dout <= r2_dout;   
            r1_rw <= 0;
            if (base_done_tmp) begin
              r2_rw <= 1;
              r2_addr <= occupy_lut;
            end
            else begin
              r2_rw <= 0;
              r2_addr <= 0;
            end
          end
          else if (e_status == 3) begin
            if (cnt >= 1 && cnt <= 1+wr-1)
              er_dout <= {er_dout[m*(digit-1)-1:0],E_din};
            else 
              er_dout <= er_dout;   
            er_rw <= 0;
            if (base_done_tmp) begin
              er_rw <= 1;
              er_addr <= occupy_lut;
            end
            else begin
              er_rw <= 0;
              er_addr <= 0;
            end
          end

          if (rng_finish)
                  rnd_pool <= rng_data[95:95-rnd_num*digit+1];
              else if (base_done_tmp)
                  rnd_pool <= {rnd_pool[(rnd_num-1)*digit-1:0], {digit{1'b0}}};
              else
                  rnd_pool <= rnd_pool;

          if (rng_finish)
              rnd_pool_cnt <= 0;
          else if (base_done_tmp)
              rnd_pool_cnt <= rnd_pool_cnt + 1;
          else 
              rnd_pool_cnt <= rnd_pool_cnt;    

          rnd_pool_valid <= 0;

          if (rng_finish)
              occupy_lut <= rng_data[96-1:96-`FLOG2((n/digit) + ((n%digit) != 0))];
          else 
              occupy_lut <= occupy_lut;   
          
          if (cnt == 18)
              base_done_tmp <= 1;  
          else    
              base_done_tmp <= 0; 

          if (cnt == 18) begin
            rng_start <= 1;
            rng_data_cache <= rng_data;
          end
          else begin
            rng_start <= 0;
            rng_data_cache <= rng_data_cache;
          end

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

          if (rnd_pool_cnt == rnd_num && rng_finish) //update entropy pool if rnd_pool is empty
            rnd_pool <= rng_data[95:95-rnd_num*digit+1]; 
          else 
            rnd_pool <= {rnd_pool[(rnd_num-1)*digit-1:0], {digit{1'b0}}};

          if (rnd_pool_cnt == rnd_num && rng_finish)
            rnd_pool_cnt <= 0;
          else if (rnd_pool_cnt == rnd_num)
            rnd_pool_cnt <= rnd_pool_cnt;  
          else 
            rnd_pool_cnt <= rnd_pool_cnt + 1;  

          if (rnd_pool != 0)
            rnd_pool_valid[0] <= 1;
          else 
            rnd_pool_valid[0] <= 0;
          rnd_pool_valid[1] <= rnd_pool_valid[0];  
          
          if (others_done)
            cnt <= 0;
          else if (rnd_pool_valid[1])//cnt = digit(wr) indicates e_dout is ready
            cnt <= cnt == digit-1 ? 0 : cnt + 1;
          else 
            cnt <= cnt;  

          if (others_done)
            E_ctrlw <= 0;
          else  
            E_ctrlw <= {1'b1,rnd_pool[rnd_num*digit-1:rnd_num*digit-digit]};

          if (rnd_pool_valid[1] && (r1_rw || r2_rw || er_rw) && ( (r1_addr == (n/digit) + ((n%digit) != 0) - 1) || (r2_addr == (n/digit) + ((n%digit) != 0) - 1) || (er_addr == (n/digit) + ((n%digit) != 0) - 1) ))
            others_done <= 1;
          else 
            others_done <= 0;

          if (others_done && e_status == 1)
            e_status <= 2;
          else if (others_done && e_status == 2)
            e_status <= 3;  
          else 
            e_status <= e_status; 


          if (others_done && e_status == 3)
            gf2mz_start <= 1;
          else 
            gf2mz_start <= 0;    

          if (e_status == 1) begin
            if (rnd_pool_valid[1])
              r1_dout <= {r1_dout[m*(digit-1)-1:0], E_din};
            else 
              r1_dout <= r1_dout;

            if (rnd_pool_valid[1] && cnt == digit-1) 
              r1_rw <= 1;
            else 
              r1_rw <= 0;

            if (rnd_pool_valid[1] && cnt == digit-1)//check if r1_addr has excluded lut_occupy
              r1_addr <= r1_addr != occupy_lut ? r1_addr :
                                    r1_addr == (n/digit) + ((n%digit) != 0) - 1 ? 0 : r1_addr + 1;
            else if (r1_rw)                      
              r1_addr <= r1_addr + 1'b1;
            else 
              r1_addr <= r1_addr;                
          end
          else if (e_status == 2) begin
            if (others_done) begin
              r2_dout <= 0;
              r2_rw <= 0;
              r2_addr <= 0;
            end
            else begin
              if (rnd_pool_valid[1])
                r2_dout <= {r2_dout[m*(digit-1)-1:0], E_din};
              else 
                r2_dout <= r2_dout;

              if (rnd_pool_valid[1] && cnt == digit-1) 
                r2_rw <= 1;
              else 
                r2_rw <= 0;

              if (rnd_pool_valid[1] && cnt == digit-1)//check if r2_addr has excluded lut_occupy
                r2_addr <= r2_addr != occupy_lut ? r2_addr :
                                      r2_addr == (n/digit) + ((n%digit) != 0) - 1 ? 0 : r2_addr + 1;
              else if (r2_rw)                      
                r2_addr <= r2_addr + 1'b1;
              else 
                r2_addr <= r2_addr; 
            end               
          end
          else if (e_status == 3) begin
            if (others_done) begin
              er_dout <= 0;
              er_rw <= 0;
              er_addr <= 0;
            end
            else begin
              if (rnd_pool_valid[1])
                er_dout <= {er_dout[m*(digit-1)-1:0], E_din};
              else 
                er_dout <= er_dout;

              if (rnd_pool_valid[1] && cnt == digit-1) 
                er_rw <= 1;
              else 
                er_rw <= 0;

              if (rnd_pool_valid[1] && cnt == digit-1)//check if er_addr has excluded lut_occupy
                er_addr <= er_addr != occupy_lut ? er_addr :
                                      er_addr == (n/digit) + ((n%digit) != 0) - 1 ? 0 : er_addr + 1;
              else if (er_rw)                      
                er_addr <= er_addr + 1'b1;
              else 
                er_addr <= er_addr; 
            end               
          end
        end

        MUL: begin
          gf2mz_start <= 0;
          e_status <= 0;
          r1_rw <= 0;
          r1_addr <= 0;
          r1_dout <= 0;
          r2_rw <= 0;
          r2_addr <= 0;
          r2_dout <= 0;
        end

        ADD: begin
           cnt <= cnt == 2 ? 0 : cnt + 1'b1;

           if (cnt == 1) begin
               sr_rw <= 1'b1;
               sr_dout <= sr_din ^ r1_din;
               se_rw <= 1'b1;
               se_dout <= se_din ^ er_din;
           end
           else begin
               sr_rw <= 0;
               sr_dout <= 0;
               se_rw <= 0;
               se_dout <= 0;
           end
           if (cnt == 2) begin
               r1_addr <= r1_addr + 1'b1;
               sr_addr <= sr_addr + 1'b1;  
               er_addr <= er_addr + 1'b1;
               se_addr <= se_addr + 1'b1;            
           end
           else begin
               r1_addr <= r1_addr;
               sr_addr <= sr_addr;
               er_addr <= er_addr;
               se_addr <= se_addr;
           end

           if ( sr_rw && sr_addr == ((n/digit) + ((n%digit) != 0) - 1) && se_rw && se_addr == ((n/digit) + ((n%digit) != 0) - 1) )
                done <= 1;
           else
                done <= 0;
        end

    endcase
end


endmodule