class ram_driver;
  mailbox #(ram_transaction) gen2drv;
  virtual intf.drv_mp dvif;
  ram_transaction packet;


covergroup cvg;
    coverpoint packet.address {
        bins lower_address[]  = {[0:15]};
        bins mid_address[]    = {[16:25]};
        bins higher_address[] = {[26:31]};
    }
endgroup

function new();
    cvg = new();
endfunction

  function void connect(mailbox #(ram_transaction) gen2drv, virtual intf dvif);
    this.gen2drv=gen2drv;
    this.dvif=dvif;
  endfunction

 task run();
    forever begin
        $display("[%0t] Driver: Waiting for packet...", $time);
        gen2drv.get(packet);
        cvg.sample();
        $display("[%0t] Driver: Packet received", $time);
        send_to_dut(packet);
    end
endtask

  task send_to_dut(ram_transaction packet);
    @(dvif.drv_cb);

   if(!packet.reset)
   begin
        dvif.drv_cb.address <= 'b0;
        dvif.drv_cb.write_data <= 'b0;
        dvif.drv_cb.write_enable <= 'b0;
        dvif.drv_cb.read_enable <= 'b0;
   end

    else begin
    case(packet.operation)
      IDLE: begin
        dvif.drv_cb.address <= 'b0;
        dvif.drv_cb.write_data <= 'b0;
        dvif.drv_cb.write_enable <= packet.write_enable;
        dvif.drv_cb.read_enable <= packet.read_enable;
      end

       WRITE: begin
        dvif.drv_cb.address <= packet.address;
        dvif.drv_cb.write_data <= packet.write_data;
        dvif.drv_cb.write_enable <= packet.write_enable;
        dvif.drv_cb.read_enable <= packet.read_enable;
      end

       READ: begin
        dvif.drv_cb.address <=  packet.address;
        dvif.drv_cb.write_data <= 'b0;
        dvif.drv_cb.write_enable <= packet.write_enable;
        dvif.drv_cb.read_enable <= packet.read_enable;
      end

       SIM_RW: begin
        dvif.drv_cb.address <= packet.address;
        dvif.drv_cb.write_data <= packet.write_data;
        dvif.drv_cb.write_enable <= packet.write_enable;
        dvif.drv_cb.read_enable <= packet.read_enable;
      end

    endcase

    @(dvif.drv_cb);
    packet.read_data = dvif.drv_cb.read_data;

  end

  endtask

endclass
