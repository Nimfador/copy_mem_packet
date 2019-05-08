module mac_mem_tb;
    parameter pTIME =  300,
              pCLK_PER_SEC = 125_000_00, 
              pNUM_PORTS = 4, 
              pADDR_WIDTH = 14,
              pDATA_DEPTH =  2**pADDR_WIDTH;
    
    reg                                             clk;
    reg [$clog2(pNUM_PORTS)-1:0]                    port_num_in;
    reg [pADDR_WIDTH-1:0]                           source_addr;
    reg [pADDR_WIDTH-1:0]                           dist_addr;
    reg                                             wr_en;

    wire [$clog2(pNUM_PORTS)-1:0]                   port_num_out;
    wire                                            ready;

    bit [$clog2(pNUM_PORTS)+$clog2(pTIME)-1:0]    test_mem_array[100];

    mac_mem 
    #(
        .pTIME                              (pTIME),
        .pCLK_PER_SEC                       (pCLK_PER_SEC),
        .pNUM_PORTS                         (pNUM_PORTS),
        .pADDR_WIDTH                        (pADDR_WIDTH),
        .pDATA_DEPTH                        (pDATA_DEPTH)
    ) DUT
    (
        .iclk                               (clk),
        .ipnum                              (port_num_in),          
        .isa                                (source_addr),
        .ida                                (dist_addr),
        .iwr_en                             (wr_en),
        .opnum                              (port_num_out),
        .oready                             (ready)
    );

    // write some values to test_mem_array at the begining of testing
    initial begin
        //$srandom(2**$clog2(pNUM_PORTS)+$clog2(pTIME));
        for(int i=0; i<$size(test_mem_array); i++)
            test_mem_array[i] = $urandom_range(50,1);
    end

    always begin
        #1 clk = ~clk;    
    end

    initial begin
        // write data from memory to module 
        // 10 firstly than pause and remaining 90
        clk = 0;
        wr_en = 1;
        #1
        for (int i=0; i<10; i++) begin
            #2 source_addr = test_mem_array[i][$clog2(pNUM_PORTS)+$clog2(pTIME)-1:$clog2(pTIME)-2];
            port_num_in = test_mem_array[i][$clog2(pTIME)-1:0];
        end
        wr_en = 0;
        #2000 wr_en = 1;
        for (int i=10; i<$size(test_mem_array); i++) begin
            #2 source_addr = test_mem_array[i][$clog2(pNUM_PORTS)+$clog2(pTIME)-1:$clog2(pTIME)-2];
            port_num_in = test_mem_array[i][$clog2(pTIME)-1:0];
        end
        // Then we are going to see what inside memory 
        // Take time to 
    end

endmodule 