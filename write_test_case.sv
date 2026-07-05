class ram_write_test extends ram_generator;
  ram_transaction packet;
    virtual task run();

    repeat(`NUM_OF_TRANS)
      begin
        packet=new();
        packet.randomize() with {packet.operation==WRITE;};
        gen2drv.put(packet);
        packet.print("WRITE TEST");
      end
    endtask
endclass
