class ram_agent;
  ram_generator gen;
  ram_driver drv;
  ram_monitor mon;
  mailbox #(ram_transaction) gen2drv;
  mailbox #(ram_transaction) mon2sco;

  
    virtual intf.mon_mp mvif;
    virtual intf.drv_mp dvif;

  
  function void build();
    drv=new();
    gen2drv=new();
    mon2sco=new();    
    mon=new();
  endfunction
  
  function void connect(virtual intf.drv_mp dvif,virtual intf.mon_mp mvif);
    drv.connect(gen2drv,dvif);
    mon.connect(mon2sco,mvif);
    if(gen != null)
      gen.connect(gen2drv);
  endfunction
  
endclass
