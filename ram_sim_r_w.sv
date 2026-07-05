class ram_sim_r_w extends ram_generator;
  ram_transaction packet;
    virtual task run();

    repeat(`NUM_OF_TRANS)
      begin
        packet=new();
        packet.randomize() with {packet.operation==SIM_RW;};
        gen2drv.put(packet);
        packet.print("SIM_READ_WRITE TEST");
      end
          endtask

endclass
