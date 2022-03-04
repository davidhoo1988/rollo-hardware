library verilog;
use verilog.vl_types.all;
entity shift_x_by_i is
    generic(
        WIDTH           : integer := 67;
        k3              : integer := 5;
        k2              : integer := 2;
        k1              : integer := 1;
        i               : integer := 16
    );
    port(
        a               : in     vl_logic;
        p               : in     vl_logic_vector;
        px              : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of k3 : constant is 1;
    attribute mti_svvh_generic_type of k2 : constant is 1;
    attribute mti_svvh_generic_type of k1 : constant is 1;
    attribute mti_svvh_generic_type of i : constant is 1;
end shift_x_by_i;
