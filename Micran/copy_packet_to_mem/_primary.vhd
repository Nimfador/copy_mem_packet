library verilog;
use verilog.vl_types.all;
entity copy_packet_to_mem is
    generic(
        pFIFO_LENGHT    : integer := 4;
        pRB_WIDHT       : integer := 14;
        pFIFO_SIZE      : integer := 16;
        pMEM_WIDTH      : integer := 8
    );
    port(
        iclk            : in     vl_logic;
        i_rst           : in     vl_logic;
        idv             : in     vl_logic;
        irx_d           : in     vl_logic_vector;
        iFSM_state      : in     vl_logic_vector(2 downto 0);
        oempty          : out    vl_logic;
        ofull           : out    vl_logic;
        or_data         : out    vl_logic_vector;
        olen_pac        : out    vl_logic_vector
    );
end copy_packet_to_mem;
