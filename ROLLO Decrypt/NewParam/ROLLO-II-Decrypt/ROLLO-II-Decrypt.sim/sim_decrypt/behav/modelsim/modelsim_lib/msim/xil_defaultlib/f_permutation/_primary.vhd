library verilog;
use verilog.vl_types.all;
entity f_permutation is
    generic(
        DELAY_rd        : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        \in\            : in     vl_logic_vector(575 downto 0);
        in_ready        : in     vl_logic;
        ack             : out    vl_logic;
        \out\           : out    vl_logic_vector(1599 downto 0);
        out_ready       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DELAY_rd : constant is 1;
end f_permutation;
