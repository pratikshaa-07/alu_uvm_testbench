class coverage extends uvm_subscriber#(sitem);
  sitem am,pm;
  uvm_tlm_analysis_fifo#(sitem) p_mon;
  uvm_tlm_analysis_fifo#(sitem) a_mon;
  real pm_covg,am_covg;

  covergroup am_cg;
  CE:       coverpoint am.ce   { bins ce[]={0,1};}
  CMD:      coverpoint am.cmd  { bins cmd[]={[0:13]};}
  CIN:      coverpoint am.cin  { bins cin ={0,1};}
  OPA:      coverpoint am.opa  { bins opa={[0:`oplen-1]};}
  OPB:      coverpoint am.opb { bins opb={[0:`oplen-1]};}
  INP_VALID:coverpoint am.inp_valid { bins inp_valid[]={[0:3]};}
  MODE:     coverpoint am.mode { bins mode[]={0,1};}

  MODE_and_CMD:
  cross CMD, MODE {
  bins mode0_cmd = binsof(CMD) intersect {[0:13]} && binsof(MODE) intersect {0};
  bins mode1_cmd = binsof(CMD) intersect {[0:10]} && binsof(MODE) intersect {1};

  ignore_bins invalid_cmd_mode0 = binsof(CMD) intersect {[14:15]} && binsof(MODE) intersect {0};
  ignore_bins invalid_cmd_mode1 = binsof(CMD) intersect {[11:15]} && binsof(MODE) intersect {1};
   }

  IN_and_CMD:
  cross CMD,INP_VALID,MODE {
  bins inp3_cmd_mode1  = binsof(CMD) intersect {0,1,2,3,8,9,10} && binsof (MODE) intersect {1} &&  binsof (INP_VALID) intersect {3};
  bins inp3_cmd_mode0  = binsof(CMD) intersect {0,1,2,3,4,5,12,13} && binsof (MODE) intersect {0} && binsof (INP_VALID) intersect {3};

  bins inp1_cmd_mode1  = binsof(CMD) intersect {4,5} && binsof (MODE) intersect {1} && binsof (INP_VALID) intersect {1};
  bins inp1_cmd_mode0  = binsof(CMD) intersect {6,8,9} && binsof (MODE) intersect {0} && binsof (INP_VALID) intersect {1};

  bins inp2_cmd_mode0  = binsof(CMD) intersect {6,7} && binsof (MODE) intersect {1} && binsof (INP_VALID) intersect {2};
  bins inp2_cmd_mode1  = binsof(CMD) intersect {7,10,11} && binsof (MODE) intersect {0} && binsof (INP_VALID) intersect {2};

  }

  endgroup

    covergroup pm_cg;
    RES   : coverpoint pm.res    { bins result  = {[0:`oplen]}; }
    E     : coverpoint pm.e      { bins equal   = {0,1}; }
    L     : coverpoint pm.l      { bins less    = {0,1}; }
    G     : coverpoint pm.g      { bins greater = {0,1}; }
    COUT  : coverpoint pm.cout   { bins cout    = {0,1}; }
    OFLOW : coverpoint pm.oflow  { bins oflow   = {0,1}; }
    ERR   : coverpoint pm.err    { bins error   = {0,1}; }
  endgroup

  `uvm_component_utils(coverage)

  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    p_mon=new("p_mon",this);
    a_mon=new("m_mon",this);
    pm_cg= new();
    am_cg= new();
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      a_mon.get(am);
      am_cg.sample();
      p_mon.get(pm);
      pm_cg.sample();

      `uvm_info("COVERAGE",$sformatf("Coverage sampled for am=%0p", am), UVM_LOW)
      `uvm_info("COVERAGE",$sformatf("Coverage sampled for pm=%0p", pm), UVM_LOW)
    end
  endtask

function void write(sitem t);
   // Not used already present in base class
 endfunction

function void extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  am_covg = am_cg.get_coverage();
  pm_covg = pm_cg.get_coverage();
endfunction

  function void report_phase(uvm_phase phase);
   super.report_phase(phase);
    `uvm_info(get_type_name, $sformatf("INPUT COVERAGE  => %0.2f%%,", am_covg), UVM_MEDIUM);
    `uvm_info(get_type_name, $sformatf("OUTPUT COVERAGE => %0.2f%%", pm_covg), UVM_MEDIUM);
  endfunction

endclass
