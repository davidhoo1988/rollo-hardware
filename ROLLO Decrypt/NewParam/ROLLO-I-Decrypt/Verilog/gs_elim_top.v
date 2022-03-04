`include "clog2.v" 
`include "define.v"

module gs_elim_top #(parameter DAT_W = `l, DAT_D = `k, d = `d)( // d rows of systolic array, e.g. 16
    input wire clk,
    input wire rst_b,
    input wire start,
    input wire mat_sel, // select the size of matrix 0 -> '2n*l' or 1 --> '(n+rd)*l'
    input wire is_last, // perform systemization if last round
    output wire finish,
    //interact with memory
    input wire [DAT_W-1:0] mem_dina,
    output wire [DAT_W-1:0] mem_douta, mem_doutb,
    //output wire mem_doa, mem_dob, /* for synthesis purposes */
    output wire [`CLOG2(DAT_D)-1:0] mem_addra, mem_addrb,
    output wire mem_rwa, mem_rwb
    );

 
    /* for synthesis purposes */   
    // wire [DAT_W-1:0] mem_douta, mem_doutb;
    // assign mem_doa = ^mem_douta;
    // assign mem_dob = ^mem_doutb;


//inter-connections
wire SA_mode, SA_start, SA_swap;
wire [DAT_W-1:0] SA_din, SA_dout;
wire [DAT_W-1:0] ctrl_mem_doutb;
wire ctrl_wr_en;

gs_elim_ctrl CTRL(
    .clk        (clk),
    .rst_b      (rst_b), 
    .start      (start),
    .mat_sel    (mat_sel), // switch the matrix size  0 -> k  1 -> k1
    .is_last    (is_last), // if 1, perform systemization and write mem, otherwise write mem with intersection result
    .done       (finish),
    //interact with SA   
    .SA_mode    (SA_mode),
    .SA_start   (SA_start),
    .SA_swap    (SA_swap),
    //interact with memory
    .mem_addra   (mem_addra),
    .mem_rwa     (mem_rwa),
    .SA_din      (SA_dout), //read SA for vector space intersection to locate the addr of error E, finally write to port-a of memory
    .mem_dina    (mem_dina),
    .mem_doutb   (ctrl_mem_doutb),
    .mem_addrb   (mem_addrb),
    .mem_rwb     (mem_rwb),
    .mem_wr_en   (ctrl_wr_en) // enable the port-b write of memory for moving to the first few rows
);

defparam CTRL.k = DAT_D;
defparam CTRL.k1 = `N + `R*`D;
defparam CTRL.l = DAT_W;
defparam CTRL.d = d; // rows of systolic array, e.g. 16
defparam CTRL.READ_DELAY = 2;

assign SA_din = mem_dina;
assign mem_douta = SA_dout;
assign mem_doutb = ctrl_wr_en ? ctrl_mem_doutb : SA_dout;

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