library verilog;
use verilog.vl_types.all;
entity sram is
    generic(
        DATA_WIDTH      : integer := 8;
        DEPTH           : integer := 3072
    );
    port(
        i_clk           : in     vl_logic;
        i_addr_wr       : in     vl_logic_vector;
        i_addr_r        : in     vl_logic_vector;
        i_write         : in     vl_logic;
        i_data          : in     vl_logic_vector;
        o_data          : out    vl_logic_vector
    );
end sram;
