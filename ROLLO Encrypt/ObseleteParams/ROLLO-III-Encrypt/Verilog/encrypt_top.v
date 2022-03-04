//`include "clog2.v" 
//`include "define.v"

module ROLLO_III_Encrypt #(parameter n = `N, m = `M, wr = `Wr, w = `W, digit = `DIGIT)(
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
wire [wr:0]          E_ctrl_w, c_E_ctrl_w;
wire [`CLOG2(wr)-1:0]  E_addr, c_E_addr;
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
wire [`CLOG2(wr)-1:0]  E_rref_addr;
wire [m-1:0]          E_rref_data_out;

//c_Gen_ctrl signal delcaration
wire c_gen_start;
wire [m*digit-1:0]                                r1_data_in;
wire                                              r1_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   r1_addr;
wire [m*digit-1:0]                                r1_data_out;

wire [m*digit-1:0]                                r2_data_in;
wire                                              r2_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   r2_addr;
wire [m*digit-1:0]                                r2_data_out;
wire                                              mul_r2_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   mul_r2_addr;
wire [m*digit-1:0]                                mul_r2_data_out;

wire [m*digit-1:0]                                er_data_in;
wire                                              er_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   er_addr;
wire [m*digit-1:0]                                er_data_out;

wire gf2mz_start, gf2mz_done;


//pk h,s and ciphertext ct signal declaration
wire [m*digit-1:0]                                h_dia;
wire                                              h_wea;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   h_addra;
wire [m*digit-1:0]                                h_doa;
wire [m*digit-1:0]                                h_dib;
wire                                              h_web;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   h_addrb;
wire [m*digit-1:0]                                h_dob;

wire [m*digit-1:0]                                s_dia;
wire                                              s_wea;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   s_addra;
wire [m*digit-1:0]                                s_doa;
wire [m*digit-1:0]                                s_dib;
wire                                              s_web;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   s_addrb;
wire [m*digit-1:0]                                s_dob;


wire [m*digit-1:0]                                sr_data_in;
wire                                              sr_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   sr_addr;
wire [m*digit-1:0]                                sr_data_out;
wire                                              mul_sr_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   mul_sr_addr;
wire [m*digit-1:0]                                mul_sr_data_out;

wire [m*digit-1:0]                                se_data_in;
wire                                              se_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   se_addr;
wire [m*digit-1:0]                                se_data_out;
wire                                              mul_se_rw;
wire [`CLOG2((n/digit) + ((n%digit) != 0))-1:0]   mul_se_addr;
wire [m*digit-1:0]                                mul_se_data_out;

//Sha3 signal declaration
wire                  sha3_finish;
wire                  sha3_start;
wire                  sha3_mem_rw;
wire [`CLOG2(wr)-1:0]  sha3_mem_addr;
wire [m-1:0]          sha3_mem_dout;
wire [511:0]          sha3_data_out;


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

  //write r1/r2/er
  .r1_din        (r1_data_in),
  .r1_addr       (r1_addr),
  .r1_dout       (r1_data_out),
  .r1_rw         (r1_rw),
  .r2_din        (r2_data_in),
  .r2_addr       (r2_addr),
  .r2_dout       (r2_data_out),
  .r2_rw         (r2_rw),
  .er_din        (er_data_in),
  .er_addr       (er_addr),
  .er_dout       (er_data_out),
  .er_rw         (er_rw),

  //write c=[sr,se]
  .sr_din         (sr_data_in),
  .sr_addr        (sr_addr),
  .sr_dout        (sr_data_out),
  .sr_rw          (sr_rw),
  .se_din         (se_data_in),
  .se_addr        (se_addr),
  .se_dout        (se_data_out),
  .se_rw          (se_rw),

  //start gf2m[z] mul
  .gf2mz_done     (gf2mz_done),
  .gf2mz_start    (gf2mz_start),

  .done       (ready)
  );


//cal r2*h
 gf2mz_top gf2mz_one(
  .clk          (clk),
  .rst_b        (rst_b),
  .start        (gf2mz_start),

  //memory interface
  .A_di         (r2_data_in),
  .A_addr       (mul_r2_addr),
  .A_we         (mul_r2_rw),
  .A_do         (mul_r2_data_out),

  .B_dia        (h_dia), 
  .B_dib        (h_dib),
  .B_addra      (h_addra), 
  .B_addrb      (h_addrb),
  .B_wea        (h_wea), 
  .B_web        (h_web),
  .B_doa        (h_doa), 
  .B_dob        (h_dob),

  .C_di         (sr_data_in),
  .C_addr       (mul_sr_addr),
  .C_we         (mul_sr_rw),
  .C_do         (mul_sr_data_out),

  .done         (gf2mz_done),
  .dout         ()
    );

//cal r2*s
 gf2mz_top gf2mz_two(
  .clk          (clk),
  .rst_b        (rst_b),
  .start        (gf2mz_start),

  //memory interface
  .A_di         (r2_data_in),
  .A_addr       (),
  .A_we         (),
  .A_do         (),

  .B_dia        (s_dia), 
  .B_dib        (s_dib),
  .B_addra      (s_addra), 
  .B_addrb      (s_addrb),
  .B_wea        (s_wea), 
  .B_web        (s_web),
  .B_doa        (s_doa), 
  .B_dob        (s_dob),

  .C_di         (se_data_in),
  .C_addr       (mul_se_addr),
  .C_we         (mul_se_rw),
  .C_do         (mul_se_data_out),

  .done         (),
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
defparam E_rref.DEPTH = wr;


(* DONT_TOUCH = "yes" *) mem_sp r1(
  //input
  .clk (clk),
  .di (r1_data_out),
  .addr (r1_addr),
  .en (1'b1),
  .we (r1_rw),
  //output
  .do (r1_data_in)
);

defparam r1.WIDTH = digit*m;
defparam r1.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/d)

(* DONT_TOUCH = "yes" *) mem_sp r2(
  //input
  .clk (clk),
  .di (r2_data_out | mul_r2_data_out),
  .addr (r2_addr | mul_r2_addr),
  .en (1'b1),
  .we (r2_rw | mul_r2_rw), //r2_rw | mul_r2_rw
  //output
  .do (r2_data_in)
);

defparam r2.WIDTH = digit*m;
defparam r2.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/digit)
//defparam e2.FILE = "../../../../Verilog/mem_r2.txt";

(* DONT_TOUCH = "yes" *) mem_sp er(
  //input
  .clk (clk),
  .di (er_data_out),
  .addr (er_addr),
  .en (1'b1),
  .we (er_rw),
  //output
  .do (er_data_in)
);

defparam er.WIDTH = digit*m;
defparam er.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/d)


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

(* DONT_TOUCH = "yes" *) mem_dp s(
  //input
  .clka (clk),
  .wea (s_wea),
  .ena (1'b1),
  .dia (s_doa),
  .addra (s_addra),
  //output
  .doa (s_dia), 

  //input
  .clkb (clk),
  .web (s_web),
  .enb (1'b1),
  .dib (s_dob),
  .addrb (s_addrb),
  //output
  .dob (s_dib) 
);

defparam s.WIDTH = digit*m;
defparam s.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/digit)
defparam s.FILE = "../../../../Verilog/mem_s.txt"; //for simulation
//defparam h.FILE = "./mem_s.txt"; //for synthesis

//ciphertext
(* DONT_TOUCH = "yes" *) mem_sp ct0(
 //input
 .clk (clk),
 .di (mul_sr_data_out | sr_data_out),
 .addr (mul_sr_addr | sr_addr),
 .en (1'b1),
 .we (mul_sr_rw | sr_rw),
  //output
 .do (sr_data_in)
);

defparam ct0.WIDTH = digit*m;
defparam ct0.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/digit)


(* DONT_TOUCH = "yes" *) mem_sp ct1(
 //input
 .clk (clk),
 .di (mul_se_data_out | se_data_out),
 .addr (mul_se_addr | se_addr),
 .en (1'b1),
 .we (mul_se_rw | se_rw),
  //output
 .do (se_data_in)
);

defparam ct1.WIDTH = digit*m;
defparam ct1.DEPTH = (n/digit) + ((n%digit) != 0); //ceil(n/digit)


assign data = sr_data_in[31:0] ^ se_data_in[31:0];




endmodule