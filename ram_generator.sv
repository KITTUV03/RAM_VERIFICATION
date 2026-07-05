virtual class ram_generator;
  mailbox #(ram_transaction) gen2drv;
  
  function void connect(mailbox #(ram_transaction) gen2drv);
      this.gen2drv=gen2drv;
  endfunction
  
    pure virtual task run();

endclass
      
      

