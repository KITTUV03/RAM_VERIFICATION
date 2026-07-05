class ram_monitor;
  mailbox #(ram_transaction) mon2sco;
  virtual intf.mon_mp mvif;
  ram_transaction packet;
  
  function void connect(mailbox #(ram_transaction) mon2sco, virtual intf mvif);
    this.mon2sco=mon2sco;
    this.mvif=mvif;
  endfunction
  
  task run();
    forever begin
      packet=new();
      get_from_dut();
      mon2sco.put(packet);
    end
  endtask
  
  task get_from_dut();
    repeat(2) @(mvif.mon_cb);
    packet.address  = mvif.mon_cb.address;
    packet.write_data = mvif.mon_cb.write_data;
    packet.write_enable = mvif.mon_cb.write_enable;
    packet.read_enable = mvif.mon_cb.read_enable;
    @(mvif.mon_cb);
    packet.read_data = mvif.mon_cb.read_data;
    packet.print("From Monitor");
  endtask
  
endclass
