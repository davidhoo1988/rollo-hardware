library verilog;
use verilog.vl_types.all;
entity keccak is
    generic(
        n               : integer := 47;
        m               : integer := 79;
        r               : integer := 5;
        d               : integer := 6;
        digit           : integer := 1;
        FILE_E          : string  := "mem_E.txt"
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        in_ready        : in     vl_logic;
        out_usr         : out    vl_logic_vector(63 downto 0);
        out_ready       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of r : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
    attribute mti_svvh_generic_type of FILE_E : constant is 1;
end keccak;
