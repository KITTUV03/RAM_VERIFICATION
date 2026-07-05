class ram_test;
  ram_env env;
  ram_write_test wr;
  ram_read_test rd;
  ram_sim_r_w srw;
  ram_idle idle;
  full_random rnd;
  
  virtual intf.mon_mp mvif;
  virtual intf.drv_mp dvif;

  
  function void build();
    env=new();
    env.build();
    wr=new();
    rd=new();
    srw=new();
    idle=new();
    rnd=new();
  endfunction
  
  function void test_case();
    if($test$plusargs("Write"))begin
       wr = new();
       env.agent.gen = wr;
    end
     
    if($test$plusargs("Read")) begin
     rd = new();
     env.agent.gen = rd;
    end
     
    if($test$plusargs("Simultaneous"))begin
     srw = new();
     env.agent.gen = srw;
     end
    
     
    if($test$plusargs("IDLE"))begin
     idle = new();
     env.agent.gen = idle;
     end
    
     
    if($test$plusargs("Random"))begin
     rnd = new();
     env.agent.gen = rnd;
     end
    
  endfunction
  
function void connect(virtual intf.drv_mp dvif,
                      virtual intf.mon_mp mvif);
    this.dvif = dvif;
    this.mvif = mvif;
    test_case();          
    env.connect(dvif,mvif); 

endfunction
  
  task run();
    env.run();
  endtask
  
endclass
