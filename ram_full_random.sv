class full_random extends ram_generator;
  ram_transaction packet;
  virtual task run();

    repeat(`NUM_OF_TRANS)
      begin
        packet=new();
        packet.randomize() with {packet.operation==WRITE;};
        gen2drv.put(packet);
        packet.print("WRITE TEST");
        count++;
      end

    repeat(`NUM_OF_TRANS)
      begin
        packet=new();
        packet.randomize() with {packet.operation==READ;};
        gen2drv.put(packet);
        packet.print("READ TEST");
         count++;
      end
    
    
//     repeat(1)
//       begin
//         packet=new();
//         packet.randomize() with {packet.operation==READ;packet.address==8'h1a;};
//         gen2drv.put(packet);
//         packet.print("READ TEST");
//       end
    
//      repeat(1)
//       begin
//         packet=new();
//         packet.randomize() with {packet.operation==READ;packet.reset==1'b0;};
//         gen2drv.put(packet);
//         packet.print("READ TEST");
//       end
    

//     repeat(`NUM_OF_TRANS)
//       begin
//         packet=new();
//         assert(packet.randomize());
//         gen2drv.put(packet);
//         packet.print("FULL RANDOM");
//       end
  endtask
endclass
