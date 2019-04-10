module copy_packet_to_mem_tb;

    copy_packet_to_mem 
    #(
        .pFIFO_LENGHT           = 4,    // 8  
        .pRB_WIDHT              = 14,
        .pFIFO_SIZE             = 16,
        .pMEM_WIDTH             = 8
    )
    (
        .iclk                   (),
        .i_rst                  (),
        .idv                    (),
        .irx_d                  (),
        .irx_er                 (),
        .iFSM_state             (),
        .ir_addr                (),
        .oempty                 (),
        .ofull                  (),
        .or_data                (),
        .olen_pac               ()
   );



endmodule