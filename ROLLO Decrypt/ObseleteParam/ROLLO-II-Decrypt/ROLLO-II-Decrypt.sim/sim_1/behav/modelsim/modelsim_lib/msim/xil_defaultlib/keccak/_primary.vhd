library verilog;
use verilog.vl_types.all;
entity keccak is
    generic(
        n               : integer := 149;
        m               : integer := 83;
        r               : integer := 5;
        d               : integer := 8;
        digit           : integer := 1;
        DELAY_rd        : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        in_ready        : in     vl_logic;
        mem_din         : in     vl_logic_vector;
        mem_rw          : out    vl_logic;
        mem_addr        : out    vl_logic_vector;
        out_usr         : out    vl_logic_vector(511 downto 0);
        out_ready       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of r : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
    attribute mti_svvh_generic_type of DELAY_rd : constant is 1;
end keccak;
