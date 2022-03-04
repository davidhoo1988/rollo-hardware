library verilog;
use verilog.vl_types.all;
entity K_Gen_Ctrl is
    generic(
        n               : integer := 149;
        m               : integer := 83;
        r               : integer := 5;
        d               : integer := 8;
        digit           : integer := 5
    );
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        rst_b           : in     vl_logic;
        done            : out    vl_logic;
        rng_data        : in     vl_logic_vector(95 downto 0);
        rng_finish      : in     vl_logic;
        rng_start       : out    vl_logic;
        rng_seed        : out    vl_logic_vector(95 downto 0);
        rng_in_mod      : out    vl_logic;
        E_data_in       : in     vl_logic_vector;
        E_rw            : out    vl_logic;
        E_ctrl_w        : out    vl_logic_vector;
        E_addr          : out    vl_logic_vector;
        E_data_out      : out    vl_logic_vector;
        GS_finish       : in     vl_logic;
        GS_full_rank    : in     vl_logic;
        GS_data_in      : in     vl_logic_vector;
        GS_mode         : out    vl_logic;
        GS_start        : out    vl_logic;
        GS_data_out     : out    vl_logic_vector;
        E_rref_data_in  : in     vl_logic_vector;
        E_rref_rw       : out    vl_logic;
        E_rref_addr     : out    vl_logic_vector;
        E_rref_data_out : out    vl_logic_vector;
        sha3_finish     : in     vl_logic;
        sha3_mem_addr   : in     vl_logic_vector;
        sha3_mem_rw     : in     vl_logic;
        sha3_mem_dout   : out    vl_logic_vector;
        sha3_start      : out    vl_logic;
        c_gen_start     : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of r : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end K_Gen_Ctrl;
