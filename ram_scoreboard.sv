class ram_scoreboard;

  mailbox #(ram_transaction) mon2sco;
  ram_transaction packet;

  static int pass_count;
  static int fail_count;
  static int overall_count;

  bit [`DATA_WIDTH-1:0] expected_data[int];
  //int que[$];

  function void connect(mailbox #(ram_transaction) mon2sco);
    this.mon2sco = mon2sco;
  endfunction

  task run();
    forever begin
      mon2sco.get(packet);
      compare(packet);
      packet.print("From Scoreboard");
    end
  endtask

  task compare(ram_transaction packet);

    bit [`DATA_WIDTH-1:0] exp;

    if(expected_data.exists(packet.address))
      exp = expected_data[packet.address];
    else
      exp = '0;

    overall_count++;

    case({packet.write_enable, packet.read_enable})

      //----------------------------------------------------------
      // IDLE
      //----------------------------------------------------------
      2'b00: begin
        $display("\n==============================================================");
        $display("[TEST %0d] IDLE OPERATION", overall_count);
        $display("Address       : %0d", packet.address);
        $display("Expected Data : 0x%0h", exp);
        $display("Read Data     : 0x%0h", packet.read_data);
        $display("STATUS        : IDLE");
        $display("==============================================================");
      end

      //----------------------------------------------------------
      // READ
      //----------------------------------------------------------
      2'b01: begin

        $display("\n==============================================================");
        $display("[TEST %0d] READ OPERATION", overall_count);
        $display("Address       : %0d", packet.address);
        $display("Expected Data : 0x%0h", exp);
        $display("Actual Data   : 0x%0h", packet.read_data);

        if(exp === packet.read_data) begin
          pass_count++;
          $display("STATUS        : PASS");
        end
        else begin
          fail_count++;
          $display("STATUS        : FAIL");
        end

        $display("==============================================================");

      end

      //----------------------------------------------------------
      // WRITE
      //----------------------------------------------------------
      2'b10: begin

        expected_data[packet.address] = packet.write_data;

        pass_count++;

        $display("\n==============================================================");
        $display("[TEST %0d] WRITE OPERATION", overall_count);
        $display("Address       : %0d", packet.address);
        $display("Write Data    : 0x%0h", packet.write_data);
        $display("STATUS        : MEMORY UPDATED");
        $display("==============================================================");

      end

      //----------------------------------------------------------
      // SIMULTANEOUS READ & WRITE
      // RTL is WRITE-FIRST
      //----------------------------------------------------------
      2'b11: begin

        $display("\n==============================================================");
        $display("[TEST %0d] SIMULTANEOUS READ/WRITE", overall_count);
        $display("Address       : %0d", packet.address);
        $display("Old Data      : 0x%0h", exp);
        $display("Write Data    : 0x%0h", packet.write_data);
        $display("Read Data     : 0x%0h", packet.read_data);

        if(packet.read_data === packet.write_data) begin
          pass_count++;
          $display("STATUS        : PASS");
        end
        else begin
          fail_count++;
          $display("STATUS        : FAIL");
        end

        expected_data[packet.address] = packet.write_data;

        $display("==============================================================");

      end

      //----------------------------------------------------------
      // ILLEGAL
      //----------------------------------------------------------
      default: begin
        fail_count++;
        $display("Unknown Operation");
      end

    endcase

    $display("\n*************** SCOREBOARD SUMMARY ***************");
    $display("Total Tests : %0d", overall_count);
    $display("Passed      : %0d", pass_count);
    $display("Failed      : %0d", fail_count);
    $display("**************************************************\n");

  endtask

endclass
