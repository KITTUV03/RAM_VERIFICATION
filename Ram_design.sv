`define DEPTH      32
`define WIDTH       8
`define ADD_WIDTH   5

module single_port (
    input                           clk,
    input                           reset,
    input                           re,
    input                           we,
    input  [`ADD_WIDTH-1:0]         address,
    input  [`WIDTH-1:0]             data_in,
    output reg [`WIDTH-1:0]         data_out
);

integer i;

reg [`WIDTH-1:0] mem [0:`DEPTH-1];

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < `DEPTH; i = i + 1)
            mem[i] <= '0;

        data_out <= '0;
    end
    else begin
        case ({we, re})

            2'b01: begin
                data_out <= mem[address];
            end

            2'b10: begin
                mem[address] <= data_in;
            end

            2'b11: begin
                mem[address] <= data_in;
                data_out     <= data_in;   // Write-first behavior
            end

            default: begin
                data_out <= data_out;      // Hold previous value
            end

        endcase
    end
end

endmodule
