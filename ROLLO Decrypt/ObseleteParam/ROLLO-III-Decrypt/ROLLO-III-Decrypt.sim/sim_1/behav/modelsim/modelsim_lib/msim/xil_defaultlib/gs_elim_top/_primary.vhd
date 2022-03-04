library verilog;
use verilog.vl_types.all;
entity gs_elim_top is
    generic(
        DAT_W           : integer := 202;
        DAT_D           : integer := 94;
        d               : integer := 6;
        READ_DELAY      : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        finish          : out    vl_logic;
        mem_din         : in     vl_logic_vector;
        mem_dout        : out    vl_logic_vector;
        mem_addr        : out    vl_logic_vector;
        mem_rw          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DAT_W : constant is 1;
    attribute mti_svvh_generic_type of DAT_D : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of READ_DELAY : constant is 1;
end gs_elim_top;
