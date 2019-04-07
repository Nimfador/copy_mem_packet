module reg_file
    #(
        parameter               pBITS = 8,
                                pWIDHT = 2
    )
    (
        input wire              iclk,
        input wire              iwr_en,
        input wire [pWIDHT-1:0] iw_addr,
        input wire [pWIDHT-1:0] ir_addr,
        input wire [pBITS-1:0]  iw_data,
        output wire [pBITS-1:0] or_data
    );

    // signal declaration
    reg [pBITS-1:0] rarray_reg [2**pWIDHT-1:0];

    // body
    always @(posedge iclk ) begin
        if (iwr_en) begin
            rarray_reg[iw_addr] <= iw_data;    
        end
    end

    // reset

    
    assign or_data = rarray_reg[ir_addr];

endmodule