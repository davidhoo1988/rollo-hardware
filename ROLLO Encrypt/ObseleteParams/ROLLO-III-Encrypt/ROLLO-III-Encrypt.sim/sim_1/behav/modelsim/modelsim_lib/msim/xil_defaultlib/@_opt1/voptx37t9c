library verilog;
use verilog.vl_types.all;
entity c_Gen_Ctrl is
    generic(
        n               : integer := 47;
        m               : integer := 101;
        wr              : integer := 6;
        w               : integer := 5;
        digit           : integer := 6
    );
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        rst_b           : in     vl_logic;
        rng_finish      : in     vl_logic;
        rng_data        : in     vl_logic_vector(95 downto 0);
        rng_start       : out    vl_logic;
        E_din           : in     vl_logic_vector;
        E_rw            : out    vl_logic;
        E_addr          : out    vl_logic_vector;
        E_ctrlw         : out    vl_logic_vector;
        r1_din          : in     vl_logic_vector;
        r1_addr         : out    vl_logic_vector;
        r1_dout         : out    vl_logic_vector;
        r1_rw           : out    vl_logic;
        r2_din          : in     vl_logic_vector;
        r2_addr         : out    vl_logic_vector;
        r2_dout         : out    vl_logic_vector;
        r2_rw           : out    vl_logic;
        er_din          : in     vl_logic_vector;
        er_addr         : out    vl_logic_vector;
        er_dout         : out    vl_logic_vector;
        er_rw           : out    vl_logic;
        sr_din          : in     vl_logic_vector;
        sr_addr         : out    vl_logic_vector;
        sr_dout         : out    vl_logic_vector;
        sr_rw           : out    vl_logic;
        se_din          : in     vl_logic_vector;
        se_addr         : out    vl_logic_vector;
        se_dout         : out    vl_logic_vector;
        se_rw           : out    vl_logic;
        gf2mz_done      : in     vl_logic;
        gf2mz_start     : out    vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of wr : constant is 1;
    attribute mti_svvh_generic_type of w : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end c_Gen_Ctrl;
