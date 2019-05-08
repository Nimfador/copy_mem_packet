module mac_mem 
    #(
        parameter   pTIME        = 300,
                    pCLK_PER_SEC = 125_000_000,
                    pNUM_PORTS   = 4,
                    pADDR_WIDTH  = 14,
                    pDATA_DEPTH  = 2**pADDR_WIDTH
    )
    (
        input wire                              iclk,
        input wire [$clog2(pNUM_PORTS)-1:0]     ipnum,          
        input wire [pADDR_WIDTH-1:0]            isa,
        input wire [pADDR_WIDTH-1:0]            ida,
        input wire                              iwr_en,

        
        output reg [$clog2(pNUM_PORTS)-1:0]     opnum,
        output reg                              oready
    );

    // register for inner sram module
    reg [pADDR_WIDTH-1:0]                        raddr_wr = 'b0;
    reg [pADDR_WIDTH-1:0]                        raddr_rd = 'b0;
    reg                                          rwr_en   = 'b0;
    reg [$clog2(pNUM_PORTS)+$clog2(pTIME)-1:0]   rdata_wr = 'b0;

    reg [$clog2(pNUM_PORTS)+$clog2(pTIME)-1:0]   rdata_rd;


    wire[$clog2(pNUM_PORTS)+$clog2(pTIME)-1:0]   wdata_rd;
    // general counter for controling time
    reg [$clog2(pCLK_PER_SEC)-1:0]               rtimer = pCLK_PER_SEC;                          

    sram 
    #(
        .DATA_WIDTH     ($clog2(pNUM_PORTS)+$clog2(pTIME)),
        .DEPTH          (pDATA_DEPTH)
    ) module_mem
    (
        .i_clk          (iclk),
        .i_addr_wr      (raddr_wr),
        .i_addr_r       (raddr_rd), 
        .i_write        (rwr_en),
        .i_data         (rdata_wr),
        .o_data         (wdata_rd)
    );

    // count time 
    always @(posedge iclk) begin
        if (rtimer ==  0) rtimer <= pCLK_PER_SEC;
        else rtimer <= rtimer - 1;
    end
    
    always @(posedge iclk) begin
        if (rtimer > pDATA_DEPTH*2) begin           // Write SA value to mem
            if(iwr_en) begin                           
                rwr_en <= 'b1;
                raddr_wr <= isa;
                rdata_wr /*[$clog2(pNUM_PORTS)+$clog2(pTIME)-1:$clog2(pTIME)] */ <= {ipnum, 9'd300};
            end 
            else rwr_en <= 'b0;
            raddr_rd <= ida;                        // read DA value from mem 
            oready <= 'b1;
        end
        else  begin                                 // decrement time 
            if(rtimer % 2) begin                    // update time value
                rwr_en <= 0;
                raddr_rd <= rtimer/2;
                raddr_wr <= rtimer/2;
                if(raddr_rd[$clog2(pTIME)-1:0] != 0)
                    rdata_wr <= {rdata_rd[$clog2(pNUM_PORTS)+$clog2(pTIME)-1:$clog2(pTIME)],
                                 rdata_rd[$clog2(pTIME)-1:0]-1};
                else rdata_wr <= 'b0;
            end
            else begin
                rwr_en <= 'b1;
            end
            oready <= 'b0;
        end
    end

    // output value for port
    assign opnum = rdata_rd[$clog2(pNUM_PORTS)+$clog2(pTIME)-1:$clog2(pTIME)];

    always @(posedge iclk) begin 
        rdata_rd <= wdata_rd;
    end

endmodule 
