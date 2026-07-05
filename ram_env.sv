class ram_env;
  ram_agent agent;
  ram_scoreboard sco;
  virtual intf.mon_mp mvif;
  virtual intf.drv_mp dvif;

  
  function void build();
    agent=new();
    agent.build();
    sco=new();
  endfunction
  
  function void connect(virtual intf.drv_mp dvif,virtual intf.mon_mp mvif);
    agent.connect(dvif,mvif);
    sco.connect(agent.mon2sco);
  endfunction
  
  task run();
    
    fork
    agent.gen.run();
    agent.drv.run();
    agent.mon.run();
    sco.run();
    join_any
    
  endtask
  
endclass
