library verilog;
use verilog.vl_types.all;
entity GF2m_mul_digit is
    generic(
        WIDTH           : integer := 79;
        k               : integer := 9;
        d               : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        op_a            : in     vl_logic_vector;
        op_b            : in     vl_logic_vector;
        done            : out    vl_logic;
        op_c            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of k : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
end GF2m_mul_digit;
