class agent extends uvm_agent;
seqr sq;
driver drv;
monitor mon;

`uvm_component_utils(agent)

function new(string name="",uvm_component parent=null);
    super.new(name,parent);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   if(get_is_active()==UVM_ACTIVE)
    drv.seq_item_port.connect(sq.seq_item_export);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum) :: get(this,"","is_active",is_active);
   if(get_is_active()==UVM_ACTIVE)
     begin
    drv = driver::type_id::create("drv", this);
    sq  = seqr::type_id::create("sq", this);
  end
       mon = monitor::type_id::create("mon", this);
endfunction

endclass
