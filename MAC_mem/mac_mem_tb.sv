module mac_mem_tb;

    mac_mem 
    #(
        .pTIME                              (),
        .pCLK_PER_SEC                       (),
        .pNUM_PORTS                         (),
        .pADDR_WIDTH                        (),
        .pDATA_DEPTH                        ()
    )
    (
        .iclk                               (),
        .ipnum                              (),          
        .isa                                (),
        .ida                                (),
        .opnum                              (),
        .oready                             ()
    );

endmodule 