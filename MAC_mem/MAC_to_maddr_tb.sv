module MAC_to_maddr_tb;


    reg                       clk;
    reg [7:0]                 data;
    reg                       valid;

    wire                      addr;
    wire                      ready;


    MAC_to_maddr
    #(
        .pDATA_WIDTH            (8),
        .pSIZE_IN               (48),
        .pSIZE_OUT              (14)
    )   DUT
    (
        .iclk                   (clk),
        .idata                  (data),
        .ivalid                 (valid),
        .oaddr                  (addr),
        .oready                 (ready)
    );

    initial begin
        clk = 0;
        valid = 1; 
        #200
        valid = 0;
        #100 $finish;

    end

    always begin
      #1  clk = ~clk;
    end

    always begin 
      #2 data = $urandom();
    end
    

endmodule