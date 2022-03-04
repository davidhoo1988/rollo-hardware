library verilog;
use verilog.vl_types.all;
entity gf2mz_add is
    generic(
        n               : integer := 47;
        m               : integer := 101;
        d               : integer := 6;
        WIDTH           : vl_notype;
        DEPTH           : vl_notype;
        DELAY_rd        : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        A_di            : in     vl_logic_vector;
        B_di            : in     vl_logic_vector;
        B_addr          : out    vl_logic_vector;
        B_we            : out    vl_logic;
        C_do            : out    vl_logic_vector;
        C_addr          : out    vl_logic_vector;
        C_we            : out    vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 3;
    attribute mti_svvh_generic_type of DEPTH : constant is 3;
    attribute mti_svvh_generic_type of DELAY_rd : constant is 1;
end gf2mz_add;
