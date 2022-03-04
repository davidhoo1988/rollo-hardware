library verilog;
use verilog.vl_types.all;
entity padder1 is
    port(
        \in\            : in     vl_logic_vector(31 downto 0);
        byte_num        : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end padder1;
