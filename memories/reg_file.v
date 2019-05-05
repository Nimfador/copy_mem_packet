`include "header.v"

module reg_file
    (
        input wire                              iclk,
        input wire                              iwr_en,
        input wire [$clog2(pDEPTH_RAM)-1:0]     iw_addr,
        input wire [$clog2(pDEPTH_RAM)-1:0]     ir_addr,
        input wire [pDATA_WIDTH-1:0]            iw_reg_data,
        output reg [pDATA_WIDTH-1:0]            or_data
    );

    // signal declaration
    reg [pDATA_WIDTH-1:0] rarray [0:pDEPTH_RAM-1];
    
    // body
    always @(posedge iclk ) begin
        if (iwr_en) begin                           // write
            rarray[iw_addr] <= iw_reg_data;    
        end
    or_data <= rarray[ir_addr];
      
    end

    endmodule