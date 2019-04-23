module MAC_memory
    #(
        parameter               pBITS = 8,      //Data Width
                                pWIDHT = 3072   //Number of regs or depth of data
    )
    (
        input wire              iclk,
        input wire              iwr_en,
        input wire [$clog2(pWIDHT)-1:0] iw_addr,
        input wire [$clog2(pWIDHT)-1:0] ir_addr,
        input wire [pBITS-1:0]  iw_reg_data,
        output reg [pBITS-1:0] or_data
    );

    // signal declaration
    reg [pBITS-1:0] rarray [0:pWIDHT-1];
    
    // body
    always @(posedge iclk ) begin
        if (iwr_en) begin                           // write
            rarray[iw_addr] <= iw_reg_data;    
        end
    or_data <= rarray[ir_addr];
      
    end

    endmodule