library verilog;
use verilog.vl_types.all;
entity reg_file is
    generic(
        pBITS           : integer := 8;
        pWIDHT          : integer := 2
    );
    port(
        iclk            : in     vl_logic;
        iwr_en          : in     vl_logic;
        irst            : in     vl_logic;
        iw_addr         : in     vl_logic_vector;
        ir_addr         : in     vl_logic_vector;
        iw_data         : in     vl_logic_vector;
        or_data         : out    vl_logic_vector
    );
end reg_file;
