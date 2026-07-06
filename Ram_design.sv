/************************************************************************
Copyright 2013-2014 - RV-VLSI. All Rights Reserved.
*************************************************************************
Author:         vaibbhav@rv-vlsi.com

Filename:	ram.sv   

Date:   	1st July 2014

Version:	1.0
************************************************************************/
module RAM (
    input              clk,
    input              reset,      // Active-low reset
    input      [4:0]   address,
    input      [7:0]   data_in,
    input              write_enb,
    input              read_enb,
    output reg [7:0]   data_out
);

reg [7:0] memory [0:31];
integer i;

always @(posedge clk) begin

    // Active-low reset
    if (!reset) begin

        // Reset entire memory
        for (i = 0; i < 32; i = i + 1)
            memory[i] <= 8'bz;

        data_out <= 8'bz;
    end

    // Write only
    else if (write_enb && !read_enb) begin
        memory[address] <= data_in;
    end

    // Read only
    else if (read_enb && !write_enb) begin
        data_out <= memory[address];
    end
          
    // Idle
    else begin
        data_out <= data_out;
    end

end

endmodule

