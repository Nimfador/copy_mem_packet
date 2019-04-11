module fifo_tb;
    
    
    fifo
    #(
        .pBITS                  (),
        .pWIDHT                 ()
    ) DUT_fifo
    (
        .iclk                   (),
        .ireset                 (),
        .ird                    (), 
        .iwr                    (),
        .iw_data                (),
        .oempty                 (),
        .ofull                  (),
        .or_data                ()
    );   

endmodule