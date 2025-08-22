class env extends uvm_env;
    agent agt_p;
    agent agt_a;
    sb s;
    coverage cv;
    `uvm_component_utils(env)

    function new(string name="", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db#(uvm_active_passive_enum)::set(this,"agt_a","is_active",UVM_ACTIVE);
      uvm_config_db#(uvm_active_passive_enum)::set(this,"agt_p","is_active",UVM_PASSIVE);
      agt_p = agent::type_id::create("agt_p", this);
      agt_a = agent::type_id::create("agt_a", this);
      cv = coverage::type_id::create("cv", this);
      s = sb::type_id::create("s", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // drv to fifo
      agt_a.mon.mport.connect(cv.a_mon.analysis_export);
      agt_a.mon.mport.connect(s.expected.analysis_export);
        // mon to fifo
      agt_p.mon.mport.connect(s.actual.analysis_export);
      agt_p.mon.mport.connect(cv.p_mon.analysis_export);
    endfunction
endclass
