typedef enum {lower_range, mid_range, upper_range} address_range;
typedef enum {IDLE, WRITE, READ, SIM_RW} ram_operation;

class ram_transaction;

  rand bit write_enable;
  rand bit read_enable;
  randc bit [`ADDR_WIDTH-1:0] address;
  rand bit [`DATA_WIDTH-1:0] write_data;
  rand bit reset;
  int que[$];
  

  bit [`DATA_WIDTH-1:0] read_data;

  rand address_range addr;
  rand ram_operation operation;

  
  constraint uniq_add
  {
    !(address inside {que});
  }
  
  constraint address_ranges
  {
    (addr == lower_range) -> address inside {[0:15]};
    (addr == mid_range)   -> address inside {[16:25]};
    (addr == upper_range) -> address inside {[26:31]};
  }

  constraint address_dist
  {
    addr dist
    {
      lower_range := 3,
      mid_range   := 3,
      upper_range := 3
    };
  }

  constraint operation_c
  {
    operation inside {IDLE, WRITE, READ};

    (operation == IDLE)  -> (write_enable == 0 && read_enable == 0);
    (operation == WRITE) -> (write_enable == 1 && read_enable == 0);
    (operation == READ)  -> (write_enable == 0 && read_enable == 1);
  }

 
  constraint reset_c
  {
    soft reset == 1;
  }

 
  function void post_randomize();

    
    que.push_back(address);
    
    if(que.size()==32)
      que.delete();
    if (write_enable && read_enable)
      $fatal("ERROR: Both write_enable and read_enable are asserted.");

  endfunction


  function void print(string str = "RAM_TRANSACTION");

    $display("\n==============================================================");
    $display("                     %s", str);
    $display("==============================================================");
    $display(" Operation      : %s", operation.name());
    $display(" Address Range  : %s", addr.name());
    $display(" Reset          : %0b", reset);
    $display(" Write Enable   : %0b", write_enable);
    $display(" Read Enable    : %0b", read_enable);
    $display(" Address        : 0x%0h (%0d)", address, address);
    $display(" Write Data     : 0x%0h", write_data);
    $display(" Read Data      : 0x%0h", read_data);
    $display("==============================================================\n");

  endfunction

endclass
