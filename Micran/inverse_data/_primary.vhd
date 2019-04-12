library verilog;
use verilog.vl_types.all;
entity inverse_data is
    generic(
        pDATA_WIDTH     : integer := 8
    );
    port(
        idata           : in     vl_logic_vector;
        ienable         : in     vl_logic;
        odata           : out    vl_logic_vector
    );
end inverse_data;
