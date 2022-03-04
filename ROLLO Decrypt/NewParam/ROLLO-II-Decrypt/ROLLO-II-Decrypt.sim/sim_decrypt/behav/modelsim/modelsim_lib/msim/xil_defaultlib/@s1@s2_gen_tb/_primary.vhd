library verilog;
use verilog.vl_types.all;
entity S1S2_gen_tb is
    generic(
        m               : integer := 83;
        n               : integer := 189;
        d               : integer := 5;
        WIDTH           : vl_notype;
        DEPTH           : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 3;
    attribute mti_svvh_generic_type of DEPTH : constant is 3;
end S1S2_gen_tb;
