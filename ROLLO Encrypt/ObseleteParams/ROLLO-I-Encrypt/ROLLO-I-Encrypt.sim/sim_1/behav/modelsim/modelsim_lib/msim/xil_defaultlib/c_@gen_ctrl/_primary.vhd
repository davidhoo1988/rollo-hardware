library verilog;
use verilog.vl_types.all;
entity c_Gen_ctrl is
    generic(
        n               : integer := 47;
        m               : integer := 79;
        r               : integer := 5;
        d               : integer := 6;
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
        \E_rw\          : out    vl_logic;
        \E_addr\        : out    vl_logic_vector;
        E_ctrlw         : out    vl_logic_vector;
        e_addr          : out    vl_logic_vector;
        e_dout          : out    vl_logic_vector;
        e_rw            : out    vl_logic;
        e_valid         : out    vl_logic_vector(1 downto 0);
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of r : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end c_Gen_ctrl;
