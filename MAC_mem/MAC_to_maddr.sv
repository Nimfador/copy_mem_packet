module MAC_to_maddr
    #(
        parameter pDATA_WIDTH = 8,
                  pSIZE_IN    = 48,
                  pSIZE_OUT   = 14
    )(
        input wire                      iclk,
        input wire [pDATA_WIDTH-1:0]    idata,
        input wire                      ivalid,
        output wire [pSIZE_OUT-1:0]     oaddr,
        output reg                      oready
    );

    reg [pSIZE_IN-1:0]                     rdatareg;
    reg [$clog2(pSIZE_IN/pDATA_WIDTH)-1:0] rcounter = pSIZE_IN/pDATA_WIDTH;

    always @(posedge iclk) begin
        if(ivalid) begin
            rcounter = rcounter - 1;
            if (rcounter == 0) begin
                oready   <= 1'b1;
                rcounter <= pSIZE_IN/pDATA_WIDTH;
                rdatareg <= rdatareg << pDATA_WIDTH;
                rdatareg[pDATA_WIDTH-1:0] <= idata;
            end
            else begin
                oready   <= 0'b0;
                rdatareg <= rdatareg << pDATA_WIDTH;
                rdatareg[pDATA_WIDTH-1:0] <= idata;
            end
        end
    end

    assign oaddr = rdatareg[pSIZE_OUT-1:0];
endmodule