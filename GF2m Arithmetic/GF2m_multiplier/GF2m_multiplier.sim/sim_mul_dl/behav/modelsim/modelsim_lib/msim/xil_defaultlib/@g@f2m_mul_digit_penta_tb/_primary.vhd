library verilog;
use verilog.vl_types.all;
entity GF2m_mul_digit_penta_tb is
    generic(
        WIDTH           : integer := 67;
        k3              : integer := 5;
        k2              : integer := 2;
        k1              : integer := 1;
        d               : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of k3 : constant is 1;
    attribute mti_svvh_generic_type of k2 : constant is 1;
    attribute mti_svvh_generic_type of k1 : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
end GF2m_mul_digit_penta_tb;
