library verilog;
use verilog.vl_types.all;
entity S1S2_gen is
    generic(
        n               : integer := 47;
        m               : integer := 79;
        d               : integer := 5;
        WIDTH           : vl_notype;
        DEPTH           : vl_notype;
        DELAY_mul       : integer := 6;
        DELAY_rd        : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        finish          : out    vl_logic;
        S_din           : in     vl_logic_vector;
        S_addr          : out    vl_logic_vector;
        S_rw            : out    vl_logic;
        f_din           : in     vl_logic_vector;
        f_addr          : out    vl_logic;
        f_rw            : out    vl_logic;
        S1S2_dout       : out    vl_logic_vector;
        S1S2_addr       : out    vl_logic_vector;
        S1S2_rw         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 3;
    attribute mti_svvh_generic_type of DEPTH : constant is 3;
    attribute mti_svvh_generic_type of DELAY_mul : constant is 1;
    attribute mti_svvh_generic_type of DELAY_rd : constant is 1;
end S1S2_gen;
