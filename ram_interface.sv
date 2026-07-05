`include "ram_defines.svh"
interface intf(input logic clk,input logic reset);
  logic write_enable;
  logic read_enable;
  logic [`ADDR_WIDTH-1:0] address;
  logic [`DATA_WIDTH-1:0] write_data;
  logic [`DATA_WIDTH-1:0] read_data;
  
  clocking drv_cb @(posedge clk);
    default input #1 output #0;
    output write_enable,read_enable,address,write_data;
    input  read_data;
  endclocking
  
   clocking mon_cb @(posedge clk);
    default input #1;
    input write_enable,read_enable,address,write_data;
    input  read_data;
  endclocking
  
  modport drv_mp(clocking drv_cb,input clk,input reset);
  modport mon_mp(clocking mon_cb,input clk,input reset);

endinterface
