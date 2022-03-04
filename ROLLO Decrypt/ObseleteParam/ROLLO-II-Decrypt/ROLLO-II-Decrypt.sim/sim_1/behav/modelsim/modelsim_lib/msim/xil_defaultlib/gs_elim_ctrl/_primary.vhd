library verilog;
use verilog.vl_types.all;
entity gs_elim_ctrl is
    generic(
        k               : integer := 6;
        l               : integer := 4;
        d               : integer := 2;
        READ_DELAY      : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        SA_mode         : out    vl_logic;
        SA_start        : out    vl_logic;
        SA_swap         : out    vl_logic;
        mem_dina        : in     vl_logic_vector;
        mem_addra       : out    vl_logic_vector;
        mem_addrb       : out    vl_logic_vector;
        mem_rwa         : out    vl_logic;
        mem_rwb         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of k : constant is 1;
    attribute mti_svvh_generic_type of l : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of READ_DELAY : constant is 1;
end gs_elim_ctrl;
