library verilog;
use verilog.vl_types.all;
entity c_Gen_Ctrl is
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
        rng_finish      : in     vl_logic;
        rng_data        : in     vl_logic_vector(95 downto 0);
        rng_start       : out    vl_logic;
        E_din           : in     vl_logic_vector;
        E_rw            : out    vl_logic;
        E_addr          : out    vl_logic_vector;
        E_ctrlw         : out    vl_logic_vector;
        e1_din          : in     vl_logic_vector;
        e1_addr         : out    vl_logic_vector;
        e1_dout         : out    vl_logic_vector;
        e1_rw           : out    vl_logic;
        e2_din          : in     vl_logic_vector;
        e2_addr         : out    vl_logic_vector;
        e2_dout         : out    vl_logic_vector;
        e2_rw           : out    vl_logic;
        c_din           : in     vl_logic_vector;
        c_addr          : out    vl_logic_vector;
        c_dout          : out    vl_logic_vector;
        c_rw            : out    vl_logic;
        gf2mz_done      : in     vl_logic;
        gf2mz_start     : out    vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of r : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end c_Gen_Ctrl;
