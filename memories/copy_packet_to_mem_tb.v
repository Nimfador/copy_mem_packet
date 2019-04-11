module copy_packet_to_mem_tb;

    reg                     iclk      ;         
    reg                     i_rst     ;
    reg                     idv       ;
    reg                     irx_d     ;         // 7:0
    reg                     irx_er    ;
    reg                     iFSM_state;
    reg                     ir_addr   ;
    reg                     oempty    ;
    reg                     ofull     ;
    reg                     or_data   ;
    reg                     olen_pac  ;   

    copy_packet_to_mem 
    #(
        .pFIFO_LENGHT           (),    // 8  
        .pRB_WIDHT              (),
        .pFIFO_SIZE             (),
        .pMEM_WIDTH             ()
    ) DUt
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