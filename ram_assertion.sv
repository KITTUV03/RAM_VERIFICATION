module ram_assertions (
    input logic clk,
    input logic reset,
    input logic write_enable,
    input logic read_enable,
    input logic [4:0] address
);

property p_no_simultaneous_rw;
  @(posedge clk)
  disable iff (!reset)
  (!$isunknown({write_enable, read_enable}))
    |-> ({write_enable, read_enable} != 2'b11);
endproperty

  A_NO_SIM_RW:
assert property(p_no_simultaneous_rw)
else begin
    $display("[%0t] WE=%b RE=%b", $time, write_enable, read_enable);
    $error("Read and Write asserted simultaneously");
end

  property p_valid_address;
    @(posedge clk)
    disable iff (!reset)
    address inside {[0:31]};
  endproperty

  A_VALID_ADDR:
    assert property (p_valid_address)
    else
      $error("[%0t] ERROR: Invalid Address = %0d", $time, address);


endmodule
