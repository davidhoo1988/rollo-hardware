library verilog;
use verilog.vl_types.all;
entity RegFiles is
    generic(
        n               : integer := 47;
        m               : integer := 101;
        wr              : integer := 6
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        rw              : in     vl_logic;
        ctrl_w          : in     vl_logic_vector;
        addr            : in     vl_logic_vector;
        data_in         : in     vl_logic_vector;
        data_out        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of wr : constant is 1;
end RegFiles;
