library verilog;
use verilog.vl_types.all;
entity shift_x_by_i is
    generic(
        WIDTH           : integer := 79;
        k               : integer := 9;
        i               : integer := 16
    );
    port(
        a               : in     vl_logic;
        p               : in     vl_logic_vector;
        px              : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of k : constant is 1;
    attribute mti_svvh_generic_type of i : constant is 1;
end shift_x_by_i;
