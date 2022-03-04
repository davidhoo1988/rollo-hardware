//`include "clog2.v" 
//`include "define.v"

module ROLLO_II_Encrypt #(parameter n = `N, m = `M, r = `R, d = `D, digit = `DIGIT)(
    input              clk, 
    input  			       rst_b,
    input              start,

    output     [32-1:0]  data,
    output            ready);



//RNG signal declaration
wire [95:0]           rng_data;
wire                  rng_finish;
wire                  rng_start, c_rng_start;
wire [95:0]           rng_seed;
wire                  rng_in_mod;

//E signal declaration
wire [m-1:0]          E_data_in;
wire                  E_rw, c_E_rw;
wire [r:0]          E_ctrl_w, c_E_ctrl_w;
wire [`CLOG2(r)-1:0]  E_addr, c_E_addr;
wire [m-1:0]          E_data_out;

//GS signal declaration
wire                  GS_finish;
wire                  GS_full_rank;
wire [m-1:0]          GS_data_out;
wire                  GS_mode;
wire                  GS_start;
wire [m-1:0]          GS_data_in;

//E_rref signal delcaration
wire [m-1:0]          E_rref_data_in;
wire                  E_rref_rw;
wire [`CLOG2(r)-1:0]  E_rref_addr;
wire [m-1:0]          E_rref_data_out;

//c_Gen_ctrl signal delcaration
wire c_gen_start;
wire [m*digit-1:0]                                e1_data_in;
wire                                              e1_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   e1_addr;
wire [m*digit-1:0]                                e1_data_out;

wire [m*digit-1:0]                                e2_data_in;
wire                                              e2_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   e2_addr;
wire [m*digit-1:0]                                e2_data_out;
wire                                              mul_e2_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   mul_e2_addr;
wire [m*digit-1:0]                                mul_e2_data_out;

wire gf2mz_start, gf2mz_done;


//pk h and ciphertext ct signal declaration
wire [m*digit-1:0]                                h_dia;
wire                                              h_wea;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   h_addra;
wire [m*digit-1:0]                                h_doa;
wire [m*digit-1:0]                                h_dib;
wire                                              h_web;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   h_addrb;
wire [m*digit-1:0]                                h_dob;


wire [m*digit-1:0]                                ct_data_in;
wire                                              ct_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   ct_addr;
wire [m*digit-1:0]                                ct_data_out;
wire                                              mul_ct_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   mul_ct_addr;
wire [m*digit-1:0]                                mul_ct_data_out;

//Sha3 signal declaration
wire                  sha3_finish;
wire                  sha3_start;
wire                  sha3_mem_rw;
wire [`CLOG2(r)-1:0]  sha3_mem_addr;
wire [m-1:0]          sha3_mem_dout;
wire [511:0]          sha3_data_out;
reg [512:0]           cipher;

K_Gen_Ctrl K_Gen_Ctrl(
  .clk             (clk),
  .rst_b           (rst_b),
	.start           (start),
	.done            (),

  //RNG interface
  .rng_data         (rng_data),
  .rng_finish       (rng_finish),

  .rng_start        (rng_start),
  .rng_seed         (rng_seed),
  .rng_in_mod       (rng_in_mod),

	//E interface
  .E_data_in        (E_data_in),
  .E_rw             (E_rw),
  .E_ctrl_w         (E_ctrl_w),
  .E_addr           (E_addr),
  .E_data_out       (E_data_out),

	//GS interface
  .GS_finish        (GS_finish),
  .GS_full_rank     (GS_full_rank),
  .GS_data_in       (GS_data_in),

  .GS_mode          (GS_mode),
  .GS_start         (GS_start),
  .GS_data_out      (GS_data_out),

	//E_rref interface
  .E_rref_addr      (E_rref_addr),
  .E_rref_data_in   (E_rref_data_in),
  .E_rref_rw        (E_rref_rw),
  .E_rref_data_out  (E_rref_data_out),

	//SHA3 interface
  .sha3_finish      (sha3_finish),
  .sha3_mem_dout     (sha3_mem_dout),
  .sha3_mem_rw      (sha3_mem_rw),
  .sha3_mem_addr    (sha3_mem_addr),
  .sha3_start       (sha3_start),

  //c_Gen_Ctrl interface
  .c_gen_start      (c_gen_start)
	);


RegFiles E(
	.clk        (clk),
  .rst_b      (rst_b),

  .rw         (E_rw | c_E_rw),
  .ctrl_w     (E_ctrl_w | c_E_ctrl_w), //control word
  .addr       (E_addr | c_E_addr),
  .data_in    (E_data_out),

  .data_out   (E_data_in)
	);




comb_SA GS(
  //input
  .clk        (clk),
  .rst_b      (rst_b),
  .mode       (GS_mode),
  .start      (GS_start),
  .data       (GS_data_out),
  //output
  .finish     (GS_finish),
  .full_rank  (GS_full_rank),
  .result     (GS_data_in)
);


prng RNG (
  .clk        (clk), 
  .rst_b      (rst_b), 
  .in_ready   (rng_start|c_rng_start), 
  .in_seed    (rng_seed), 
  .in_mod     (rng_in_mod), 
  .out_rng    (rng_data), 
  .out_ready  (rng_finish)
  );



keccak SHA3 (
  //input
  .clk        (clk), 
  .rst_b      (rst_b), 
  .in_ready   (sha3_start), 
  .mem_din    (sha3_mem_dout),
  //output
  .mem_rw     (sha3_mem_rw),
  .mem_addr   (sha3_mem_addr),
  .out_usr    (sha3_data_out), 
  .out_ready  (sha3_finish)
  );



c_Gen_Ctrl c_Gen_Ctrl(
  .clk        (clk),
  .start      (c_gen_start),
  .rst_b      (rst_b),

  //direct inputs from RNG, 
  .rng_finish (rng_finish),
  .rng_data   (rng_data),
  .rng_start  (c_rng_start),
  //direct inputs from E, 
  .E_din      (E_data_in),
  .E_rw       (c_E_rw),
  .E_addr     (c_E_addr),
  .E_ctrlw    (c_E_ctrl_w),

  //write e1/e2
  .e1_din        (e1_data_in),
  .e1_addr       (e1_addr),
  .e1_dout       (e1_data_out),
  .e1_rw         (e1_rw),
  .e2_din        (0),
  .e2_addr       (e2_addr),
  .e2_dout       (e2_data_out),
  .e2_rw         (e2_rw),

  //write c
  .c_din         (ct_data_in),
  .c_addr        (ct_addr),
  .c_dout        (ct_data_out),
  .c_rw          (ct_rw),

  //start gf2m[z] mul
  .gf2mz_done     (gf2mz_done),
  .gf2mz_start    (gf2mz_start),

  .done       (ready)
  );

 gf2mz_top gf2mz(
  .clk          (clk),
  .rst_b        (rst_b),
  .start        (gf2mz_start),

  //memory interface
  .A_di         (e2_data_in),
  .A_addr       (mul_e2_addr),
  .A_we         (mul_e2_rw),
  .A_do         (mul_e2_data_out),

  .B_dia        (h_dia), 
  .B_dib        (h_dib),
  .B_addra      (h_addra), 
  .B_addrb      (h_addrb),
  .B_wea        (h_wea), 
  .B_web        (h_web),
  .B_doa        (h_doa), 
  .B_dob        (h_dob),

  .C_di         (ct_data_in),
  .C_addr       (mul_ct_addr),
  .C_we         (mul_ct_rw),
  .C_do         (mul_ct_data_out),

  .done         (gf2mz_done),
  .dout         ()
    );



mem_sp E_rref(
  //input
  .clk (clk),
  .di (E_rref_data_out),
  .addr (E_rref_addr),
  .en (1'b1),
  .we (E_rref_rw),
  //output
  .do (E_rref_data_in)
);

defparam E_rref.WIDTH = m;
defparam E_rref.DEPTH = r;


(* DONT_TOUCH = "yes" *) mem_sp e1(
  //input
  .clk (clk),
  .di (e1_data_out),
  .addr (e1_addr),
  .en (1'b1),
  .we (e1_rw),
  //output
  .do (e1_data_in)
);

defparam e1.WIDTH = digit*m;
defparam e1.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/d)

(* DONT_TOUCH = "yes" *) mem_sp e2(
  //input
  .clk (clk),
  .di (e2_data_out | mul_e2_data_out),
  .addr (e2_addr | mul_e2_addr),
  .en (1'b1),
  .we (1'b0 | mul_e2_rw), //e2_rw | mul_e2_rw
  //output
  .do (e2_data_in)
);

defparam e2.WIDTH = digit*m;
defparam e2.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/digit)
defparam e2.FILE = "../../../../Verilog/mem_e2.txt";

(* DONT_TOUCH = "yes" *) mem_dp h(
  //input
  .clka (clk),
  .wea (h_wea),
  .ena (1'b1),
  .dia (h_doa),
  .addra (h_addra),
  //output
  .doa (h_dia), 

  //input
  .clkb (clk),
  .web (h_web),
  .enb (1'b1),
  .dib (h_dob),
  .addrb (h_addrb),
  //output
  .dob (h_dib) 
);

defparam h.WIDTH = digit*m;
defparam h.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/digit)
defparam h.FILE = "../../../../Verilog/mem_h.txt"; //for simulation
//defparam h.FILE = "./mem_h.txt"; //for synthesis

//ciphertext
(* DONT_TOUCH = "yes" *) mem_sp ct(
 //input
 .clk (clk),
 .di (mul_ct_data_out | ct_data_out),
 .addr (mul_ct_addr | ct_addr),
 .en (1'b1),
 .we (mul_ct_rw | ct_rw),
  //output
 .do (ct_data_in)
);

defparam ct.WIDTH = digit*m;
defparam ct.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/digit)

assign data = ct_data_in[31:0] ^ cipher[31:0];

always @(posedge clk) begin
  if (rst_b) begin
    // reset
    cipher <= 0;  
  end
  else begin
    cipher <= sha3_data_out;   
  end
end



endmodule