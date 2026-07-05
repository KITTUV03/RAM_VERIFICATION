class full_random extends ram_generator;
  ram_transaction packet;
  virtual task run();
    repeat(`NUM_OF_TRANS)
      begin
        packet=new();
        packet.randomize();
        gen2drv.put(packet);
        packet.print("FULL RANDOM");
      end
  endtask
endclass
