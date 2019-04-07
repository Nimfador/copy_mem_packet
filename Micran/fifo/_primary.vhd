library verilog;
use verilog.vl_types.all;
entity fifo is
    generic(
        pBITS           : integer := 8;
        pWIDHT          : integer := 4
    );
    port(
        iclk            : in     vl_logic;
        ireset          : in     vl_logic;
        ird             : in     vl_logic;
        iwr             : in     vl_logic;
        iw_data         : in     vl_logic_vector;
        oempty          : out    vl_logic;
        ofull           : out    vl_logic;
        or_data         : out    vl_logic_vector
    );
end fifo;
