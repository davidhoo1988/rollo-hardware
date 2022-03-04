library verilog;
use verilog.vl_types.all;
entity gs_elim_top is
    generic(
        DAT_W           : integer := 166;
        DAT_D           : integer := 378;
        d               : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        mat_sel         : in     vl_logic;
        is_last         : in     vl_logic;
        finish          : out    vl_logic;
        mem_dina        : in     vl_logic_vector;
        mem_douta       : out    vl_logic_vector;
        mem_doutb       : out    vl_logic_vector;
        mem_addra       : out    vl_logic_vector;
        mem_addrb       : out    vl_logic_vector;
        mem_rwa         : out    vl_logic;
        mem_rwb         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DAT_W : constant is 1;
    attribute mti_svvh_generic_type of DAT_D : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
end gs_elim_top;
