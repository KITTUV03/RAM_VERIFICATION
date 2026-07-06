/***********************************************************************************************

 * ██╗  ██╗ ██╗ ████████╗ ████████╗ ██╗  ██╗    ██████╗   █████╗  ████████╗ ███████╗ ██╗         *
 * ██║ ██╔╝ ██║ ╚══██╔══╝ ╚══██╔══╝ ██║  ██║    ██╔══██╗ ██╔══██╗ ╚══██╔══╝ ██╔════╝ ██║         *
 * █████╔╝  ██║    ██║       ██║    ██║  ██║    ██████╔╝ ███████║    ██║    █████╗   ██║         *
 * ██╔═██╗  ██║    ██║       ██║    ██║  ██║    ██╔═══╝  ██╔══██║    ██║    ██╔══╝   ██║         *
 * ██║  ██╗ ██║    ██║       ██║    ╚█████╔╝    ██║      ██║  ██║    ██║    ███████╗ ███████╗   *
 * ╚═╝  ╚═╝ ╚═╝    ╚═╝       ╚═╝     ╚════╝     ╚═╝      ╚═╝  ╚═╝    ╚═╝    ╚══════╝ ╚══════╝   *
 * *
 ***********************************************************************************************/


`include "Ram_design.sv"
`include "ram_package.sv"
module ram_tb;
  import ram_pkg::*;
  bit clk;
  bit reset;

  always #5 clk=~clk;

  intf inf(clk,reset);
  ram_test test;

  RAM dut(.clk(clk),.reset(reset),.data_in(inf.write_data),.data_out(inf.read_data),.write_enb(inf.write_enable),.read_enb(inf.read_enable),.address(inf.address));


  task apply_reset;
    reset=1'b0;
    repeat(2) @(posedge clk);
    reset=1'b1;
  endtask

  initial begin
    test=new();
    test.build();
    test.connect(inf.drv_mp,inf.mon_mp);
  end

  initial begin
    apply_reset;
    test.run();
    wait(test.env.finish_test.triggered());
    $finish;
  end

   initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

final begin

$display("\n==================================================");
$display("        FUNCTIONAL COVERAGE REPORT");
$display("==================================================");
$display(" Functional Coverage = %0.2f%%", test.env.agent.drv.cvg.get_coverage());
$display("==================================================\n");
end
endmodule
