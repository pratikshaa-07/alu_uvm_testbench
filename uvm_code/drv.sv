class driver extends uvm_driver #(sitem);
  virtual inf vif;
  sitem ditem;
  bit flag;
  int i;
  sitem temp;
  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual inf)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Virtual Interface Not Set")
  endfunction

  // run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    i = 0;
    repeat (2) @(posedge vif.dcb);
    forever begin
      seq_item_port.get_next_item(ditem);
      i++;
      `uvm_info("DRIVER", $sformatf("[DRIVER-%0d] ce=%0d | mode=%0d | cmd=%0d | inp_valid=%0d | opa=%0d | opb=%0d | cin=%0d",
                 i, ditem.ce, ditem.mode, ditem.cmd, ditem.inp_valid, ditem.opa, ditem.opb, ditem.cin), UVM_LOW);
      drive(ditem);
      seq_item_port.item_done();
    end
  endtask

  task drive(sitem ditem);
    vif.opa        <= ditem.opa;
    vif.opb        <= ditem.opb;
    vif.cin        <= ditem.cin;
    vif.ce         <= ditem.ce;
    vif.mode       <= ditem.mode;
    vif.cmd        <= ditem.cmd;
    vif.inp_valid  <= ditem.inp_valid;

    @(posedge vif.dcb);

    if ((ditem.ce && (ditem.inp_valid != 0 && ditem.inp_valid != 3) && ditem.mode && (ditem.cmd inside {0,1,2,3,9,10})) ||
        (ditem.ce && (ditem.inp_valid != 0 && ditem.inp_valid != 3) && (ditem.mode == 0) && (ditem.cmd inside {0,1,2,3,4,12,13}))) begin

      flag = 0;
      ditem.cmd.rand_mode(0);
      ditem.mode.rand_mode(0);
      ditem.ce.rand_mode(0);
      ditem.inp_valid.rand_mode(0);

      for (int i = 0; i < 16; i++) begin
        void'(ditem.randomize());
        vif.opa        <= ditem.opa;
        vif.opb        <= ditem.opb;
        vif.cin        <= ditem.cin;
        vif.ce         <= ditem.ce;
        vif.mode       <= ditem.mode;
        vif.cmd        <= ditem.cmd;
        vif.inp_valid  <= ditem.inp_valid;
   `uvm_info("DRIVER", $sformatf("[DRIVER-%0d] got inp_valid %0d", i, ditem.inp_valid), UVM_LOW)
        @(posedge vif.dcb);
         
        if (ditem.inp_valid == 3) begin
          flag = 1;
          break;
        end
      end

      ditem.cmd.rand_mode(1);
      ditem.mode.rand_mode(1);
      ditem.ce.rand_mode(1);
    end
    else begin
      flag = 1;
    end

    if (flag && (ditem.cmd inside {9,10}) && ditem.mode)
      repeat (2) @(posedge vif.dcb);
    else
      repeat (1) @(posedge vif.dcb);
  endtask
endclass
