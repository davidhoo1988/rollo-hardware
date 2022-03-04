`include "clog2.v" 
`include "define.v"
//------------------------------------------------------------------
// one d*l systolic array used in gs_elim for processing k*l matrix
//------------------------------------------------------------------
module gs_elim_top #(parameter DAT_W = `l, DAT_D = `k, d = `d, READ_DELAY = 2)(
    input wire clk,
    input wire rst_b,
    input wire start,
    output wire finish,
    //interact with memory
    input wire [DAT_W-1:0] mem_din,
    output wire [DAT_W-1:0] mem_dout,
    output wire [`CLOG2(DAT_D)-1:0] mem_addr,
    output wire mem_rw
    );

//assign mem_dout2 = mem_dout[0];
//inter-connections
//wire [DAT_W-1:0] mem_dout;
wire SA_mode, SA_start, SA_swap;
wire [DAT_W-1:0] SA_din, SA_dout;

gs_elim_ctrl CTRL(
    .clk        (clk),
    .rst_b      (rst_b), 
    .start      (start),
    .done       (finish),
    //interact with SA   
    .SA_mode    (SA_mode),
    .SA_start   (SA_start),
    .SA_swap    (SA_swap),
    //interact with memory
    .mem_addr   (mem_addr),
    .mem_rw     (mem_rw),
    .mem_din    (mem_dout) //for vector space intersection determining the location of error space E
);

defparam CTRL.k = DAT_D;
defparam CTRL.l = DAT_W;
defparam CTRL.d = d;
defparam CTRL.READ_DELAY = READ_DELAY;

assign SA_din = mem_din;
assign mem_dout = SA_dout;

comb_SA SA(
  .clk          (clk),
  .rst_b        (rst_b),
  .mode         (SA_mode),
  .start        (SA_start),
  .swap         (SA_swap),
  .data         (SA_din),
  .finish       (),
  .full_rank    (),
  .result       (SA_dout)
);

defparam SA.DAT_W = DAT_W;

endmodule