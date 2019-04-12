library verilog;
use verilog.vl_types.all;
entity copy_packet_to_mem is
    generic(
        pDATA_WIDTH     : integer := 8;
        pMIN_PACKET_LENGHT: integer := 64;
        pMAX_PACKET_LENGHT: integer := 1536
    );
    port(
        iclk            : in     vl_logic;
        i_rst           : in     vl_logic;
        idv             : in     vl_logic;
        irx_d           : in     vl_logic_vector;
        irx_er          : in     vl_logic;
        iframe_state    : in     vl_logic_vector(2 downto 0);
        ird_en          : in     vl_logic;
        oempty          : out    vl_logic;
        ofull           : out    vl_logic;
        or_data         : out    vl_logic_vector;
        olen_pac        : out    vl_logic_vector;
        onext_last      : out    vl_logic;
        obytes_to_read  : out    vl_logic_vector;
        ofifo_em        : out    vl_logic;
        ofifo_full      : out    vl_logic
    );
end copy_packet_to_mem;
