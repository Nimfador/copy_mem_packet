library verilog;
use verilog.vl_types.all;
entity copy_packet_to_mem is
    port(
        iclk            : in     vl_logic;
        i_rst           : in     vl_logic;
        idv             : in     vl_logic;
        irx_d           : in     vl_logic_vector(7 downto 0);
        iFSM_state      : in     vl_logic_vector(2 downto 0)
    );
end copy_packet_to_mem;
