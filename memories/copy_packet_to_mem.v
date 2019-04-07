module copy_packet_to_mem (
    input wire              iclk,
    input wire              i_rst,
    input wire              idv,
    input wire [7:0]        irx_d,
    input wire [2:0]        iFSM_state

    );

    fifo
    #(
        .pBITS                  (),         // pointers widht
        .pWIDHT                 ()          
    ) lenght_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (),
        .ird                    (), 
        .iwr                    (),
        .iw_data                (),
        .oempty                 (),
        .ofull                  (),
        .or_data                ()
    );

    reg_file
    #(
        .pBITS                  (),         // 
        .pWIDHT                 ()
    ) memory_for_packet
    (
        .iclk                   (iclk),
        .iwr_en                 (),
        .iw_addr                (),
        .ir_addr                (),
        .iw_data                (),
        .or_data                ()
    );



endmodule