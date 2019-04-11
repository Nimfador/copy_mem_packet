module sram_tb;
    sram 
    #(
        .DATA_WIDTH             (), 
        .DEPTH                  ()
    )(
        .i_clk                  (),
        .i_addr_wr              (),
        .i_addr_r               (), 
        .i_write                (),
        .i_data                 (),
        .o_data                 ()
    );

endmodule