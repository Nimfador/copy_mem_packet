module mac_mem 
    #(
        parameter   pTIME = 300
                    pCLK_PER_SEC = 125_000_000,
                    pNUM_PORTS = 4
                    pADDR_WIDTH = 14,
                    pDATA_DEPTH = 2**pADDR_WIDTH,
    )
    (
        input wire                              iclk,
        input wire [$clog2(pNUM_PORTS)-1:0]     ipnum,          
        input wire [pADDR_WIDTH-1:0]            isa,
        input wire [pADDR_WIDTH-1:0]            ida,

        output reg [$clog2(pNUM_PORTS)-1:0]     opnum,
        output                                  oready,
    );

    // register for inner sram module
    reg [pADDR_WIDTH-1:0]                       raddr_wr;
    reg [pADDR_WIDTH-1:0]                       raddr_rd;
    reg                                         rwr_en;
    reg [$clog2(pNUM_PORTS)+$clog2(pTIME)-1:0]  rdata_wr;
    reg [$clog2(pNUM_PORTS)+$clog2(pTIME)-1:0]  rdata_rd;

    // general counter for controling time
    reg [$clog2(pCLK_PER_SEC)-1:0]              rtimer = pCLK_PER_SEC;
    reg [$clog2(pDATA_DEPTH*2)-1:0]             rtimer2;                       // Maybe not needed

    sram 
    #(
        .DATA_WIDTH     ($clog2(pNUM_PORTS)+$clog2(pTIME)),
        .DEPTH          (pDATA_DEPTH)
    )(
        .i_clk          (iclk),
        .i_addr_wr      (raddr_wr),
        .i_addr_r       (raddr_rd), 
        .i_write        (rwr_en),
        .i_data         (rdata_wr),
        .o_data         (rdata_rd)
    );

    // count time 
    always @(posedge iclk) begin
        if (rtimer ==  0) rtimer <= pCLK_PER_SEC;
        else rtimer <= rtimer - 1;
    end

    always @(posedge iclk) begin
        if (rtimer > pDATA_DEPTH*2) begin
            
        end
        else  begin
            if(rtimer % 2) begi
                rwr_en <= 0;
                raddr_rd <= rtimer/2;
                raddr_wr <= rtimer/2;
                rdata_wr <= {raddr_rd[$clog2(pNUM_PORTS)+$clog2(pTIME)-1:$clog2(pTIME)-2],
                             raddr_rd[$clog2(pTIME)-1:0]-1};
            end
            else begin
                rwr_en <= 1;
            end
        end
    end





    // Write SA value to mem

    // read DA value from mem 

    // update time value 

    always@(posedge iclk) begin 

    end


    // output value for port
endmodule 
