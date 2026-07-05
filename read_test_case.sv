class ram_read_test extends ram_generator;
  ram_transaction packet;
    virtual task run();

    repeat(`NUM_OF_TRANS)
      begin
        packet=new();
        packet.randomize() with {packet.operation==READ;};
        gen2drv.put(packet);
        packet.print("READ TEST");
      end
          endtask

endclass
