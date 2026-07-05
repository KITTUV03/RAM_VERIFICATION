class ram_idle extends ram_generator;
  ram_transaction packet;
  virtual task run();
    repeat(`NUM_OF_TRANS)
      begin
        packet=new();
        packet.randomize() with {packet.operation==IDLE;};
        gen2drv.put(packet);
        packet.print("IDLE TEST");
      end
        endtask

endclass
