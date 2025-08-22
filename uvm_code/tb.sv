class test extends uvm_test;
  `uvm_component_utils(test)

    env e;

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction

  virtual task run_phase(uvm_phase phase);
     seq s;
    super.run_phase(phase);
    phase.raise_objection(this);
       s = seq::type_id::create("s");
   // $display("in the test");
    s.start(e.agt_a.sq);
    phase.drop_objection(this);
  endtask
endclass


class reg_test extends test;

  `uvm_component_utils(reg_test)

    regr rg;

  function new(string name = "",uvm_component parent=null);
    	super.new(name,parent);
  	endfunction 

	virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
        phase.raise_objection(this);
       rg = regr::type_id::create("rg");
        rg.start(e.agt_a.sq);
        phase.drop_objection(this);
  	endtask

endclass
