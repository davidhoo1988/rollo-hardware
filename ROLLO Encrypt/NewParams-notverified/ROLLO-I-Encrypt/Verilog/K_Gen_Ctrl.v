`include "clog2.v" 
`include "define.v"

module K_Gen_Ctrl #(parameter n = `N, m = `M, r = `R, d = `D, digit = `DIGIT)(
  input       clk,
	input			  start,
	input 			rst_b,
	output 			done,

  //RNG interface
  input [95:0]        rng_data,
  input               rng_finish,

  output reg             rng_start,
  output reg [95:0]       rng_seed,
  output reg             rng_in_mod,

	//E interface
  input [m-1:0]             E_data_in,
  output reg                E_rw,
  output reg [r:0]        E_ctrl_w,
  output reg [`CLOG2(r)-1:0] E_addr,
  output reg [m-1:0]        E_data_out,

	//GS interface
  input                 GS_finish,
  input                 GS_full_rank,
  input  [m-1:0]        GS_data_in,

  output reg               GS_mode,
  output reg               GS_start,
  output reg [m-1:0]       GS_data_out,

	//E_rref interface
  input [m-1:0]             E_rref_data_in,
  output reg                E_rref_rw,
  output reg [`CLOG2(r)-1:0]      E_rref_addr,
  output reg [m-1:0]        E_rref_data_out,

	//SHA3 interface
  input                     sha3_finish,
  input [`CLOG2(r)-1:0]     sha3_mem_addr,
  input                     sha3_mem_rw,

  output reg [m-1:0]         sha3_mem_dout,
  output reg                 sha3_start,

  //c_Gen_Ctrl interface
  output reg                c_gen_start
	);


reg E_done;
reg GS_done;
reg E_rref_done;
reg SHA3_done;

reg [1:0] GS_start_tmp;
reg [`CLOG2(r)-1:0] E_addr_tmp;

//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------  
parameter         INIT = 3'd0, //idle, then start rng
                  RNG = 3'd1,
                  E = 3'd2, //generate the error space E with dim(E)=r
                  GS = 3'd3, //triangularize E
                  E_rref = 3'd4, //systemize E
                  SHA3 = 3'd5; //Hash(E)

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
                next_state = E;
            else
                next_state = INIT;  

        RNG:
            if (rng_finish)
                next_state = E;
            else 
                next_state = RNG;    

        E:
            if (E_done)
                next_state = GS;
            else   
                next_state = E;  

        GS:
            if (GS_done && GS_full_rank)
                next_state = E_rref;
            else if (GS_done && ~GS_full_rank)
                next_state = RNG;  
            else 
                next_state = GS;  

        E_rref:
            if (E_rref_done)
                next_state = SHA3;
            else 
                next_state = E_rref;  

        SHA3:
            if (SHA3_done)
              next_state = INIT;
            else 
              next_state = SHA3;                         
   
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
            //start rng with updated seed
            rng_start <= 1;
            rng_in_mod <= 1;
            rng_seed <= 32'hffffffff;
          end
          else begin
            rng_start <= 0;
            rng_in_mod <= 0;
            rng_seed <= 0;
          end
          E_addr <= 0;
          E_addr_tmp <= 0;
          E_rw <= 0;
          E_data_out <= 0;
          E_ctrl_w <= 0;
          E_done <= 0;

          GS_mode <= 0;
          GS_start <= 0;
          GS_start_tmp <= 0;
          GS_data_out <= 0;
          GS_done <= 0;

          E_rref_rw <= 0;
          E_rref_addr <= 0;
          E_rref_data_out <= 0;
          E_rref_done <= 0;

          sha3_mem_dout <= 0;
          SHA3_done <= 0;

          c_gen_start <= 0;
        end

        RNG: begin
            rng_start <= 1;
            rng_in_mod <= 0;
            rng_seed <= 0;
        end

        E: begin
          if (E_addr == r-1) begin
             //reset E signals
              E_done <= 1;
              E_rw <= 0;
              E_data_out <= 0;
              E_addr <=  0;
              E_addr_tmp <= 0;
              //reset RNG signals
              rng_start <= 0;
              rng_in_mod <= 0;
          end
          else if (rng_finish && E_addr == r-2) begin
              E_done <= 0;
              E_rw <= 1;
              E_data_out <= rng_data[96-1:96-67];
              E_addr <= E_addr_tmp;
              E_addr_tmp <= E_addr_tmp + 1;
              //reset RNG signals
              rng_start <= 0;
              rng_in_mod  <= 1'b0;
          end
          else if (rng_finish && E_addr != r-2) begin
              E_done <= 0;
              E_rw <= 1;
              E_data_out <= rng_data[96-1:96-67];
              E_addr <= E_addr_tmp;
              E_addr_tmp <= E_addr_tmp + 1;

              rng_start <= 1;
              rng_in_mod  <= 1'b0;
          end
          else begin
              E_done <= 0;
              E_rw <= 0;
              E_data_out <= 0;
              E_addr <=  E_addr;
              E_addr_tmp <=  E_addr_tmp;

              rng_start <= 0;
              rng_in_mod  <= 1'b0;
          end 
        end

        GS: begin
          E_rw <= 0;
          E_ctrl_w <= 0;
          if (c_gen_start)
            E_addr <= 0;
          else if (E_addr != r-1)
            E_addr <= E_addr + 1;
          else 
            E_addr <= E_addr; 

          if (E_addr == r-1)
            c_gen_start <= 1;
          else 
            c_gen_start <= c_gen_start;  

          if (GS_finish)
            GS_done <= 1;
          else 
            GS_done <= 0;  
          if (GS_done) begin
            GS_start <= 1'b1;
            GS_mode <= 1'b1;       
          end        
          else begin
            if (E_addr == 0 && c_gen_start == 0) begin//enable GS_start only once at the beginning of state 'GS'  (1'b1 <<`CLOG2(r)) - 1
              GS_start_tmp[0] <= 1;              
            end
            else begin
              GS_start_tmp[0] <= 0;  
            end
            GS_start_tmp[1] <= GS_start_tmp[0];
            GS_start <= GS_start_tmp[0];
            GS_mode <= 0;
            GS_data_out <= E_data_in; // could be invalid data
          end
        end

        E_rref: begin
            GS_start <= 0;
            GS_mode <= 1;
            c_gen_start <= 0;
            if (GS_finish) begin
              E_rref_rw <= 1;
              E_rref_addr <= r-1;
              E_rref_data_out <= GS_data_in;
            end
            else if (E_rref_addr == 0) begin
              E_rref_rw <= 0;
              E_rref_addr <= 0;
              E_rref_data_out <= 0;
            end
            else begin
              E_rref_rw <= E_rref_rw;  
              E_rref_addr <= E_rref_addr - 1'b1; 
              E_rref_data_out <= GS_data_in;
            end 
            if (E_rref_rw && E_rref_addr == 0)
              E_rref_done <= 1;
            else 
              E_rref_done <= 0;  
            if (E_rref_done)
              sha3_start <= 1;
            else 
              sha3_start <= 0;  
        end

        SHA3: begin
            sha3_start <= 0;
            if (sha3_finish)
              SHA3_done <= 1;
            else 
              SHA3_done <= 0;
            E_rref_rw <= sha3_mem_rw;
            E_rref_addr <= sha3_mem_addr;
            sha3_mem_dout <= E_rref_data_in;  
        end

        default: begin

        end
    endcase
end


endmodule