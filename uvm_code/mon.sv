
class monitor extends uvm_monitor;
virtual inf vif;
uvm_analysis_port#(sitem)mport;
sitem mitem;
bit flag;
int i;
sitem temp;
`uvm_component_utils(monitor)

function new(string name="",uvm_component parent=null);
    super.new(name,parent);
    mport=new("mport",this);
endfunction

//build phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf)::get(this, "", "vif", vif)) begin
        `uvm_error("MONITOR", "Interface not set");
    end
endfunction

//run phase
virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
i=0; 
repeat (3) @(posedge vif.mcb);
forever
begin
    i++; //increments for each transcation
    
    //16 clk cycle mechanism

    //checking for invalid input_valid for both modes
    if ((vif.ce && (vif.inp_valid != 0 && vif.inp_valid != 3) && vif.mode && (vif.cmd inside {0,1,2,3,9,10})) ||
        (vif.ce && (vif.inp_valid != 0 && vif.inp_valid != 3) && (vif.mode == 0) && (vif.cmd inside {0,1,2,3,4,12,13})))
    begin
      flag = 0;
      repeat (16) @(posedge vif.mcb)
      begin

      if(vif.inp_valid==3)
      begin
          flag=1;
        `uvm_info("MONITOR", $sformatf("[MONITOR-%0d] got inp_valid=3", i), UVM_LOW)
          break;
      end
      end
    end

    //for valid inp_valid 
    else
        flag=1;
    //for multiplication
    if(flag && vif.mode && vif.cmd inside {9,10})
        repeat(2)@(vif.mcb);
    else
        repeat(1)@(vif.mcb);

    //creating a new item  for each transaction
    mitem=sitem::type_id::create("mitem",this);
    
    //capturing the output of DUT
    mitem.opa=vif.opa;
    mitem.opb=vif.opb;
    mitem.cin=vif.cin;
    mitem.mode=vif.mode;
    mitem.ce=vif.ce;
    mitem.inp_valid=vif.inp_valid;
    mitem.cmd=vif.cmd;
  
    mitem.res=vif.mcb.res;
    mitem.e=vif.mcb.e;
    mitem.l=vif.mcb.l;
    mitem.g=vif.mcb.g;
    mitem.err=vif.mcb.err;
    mitem.oflow=vif.mcb.oflow;
    mitem.cout=vif.mcb.cout;
  `uvm_info("MONITOR",$sformatf("[MONITOR-%0d in] ce=%0d | mode=%0d | cmd=%0d | |inp_valid=%0d | opa=%0d | opb=%0d | cin=%0d ",i,vif.ce,vif.mode,vif.cmd,vif.inp_valid,vif.opa,vif.opb,vif.cin),UVM_LOW)
  `uvm_info("MONITOR",$sformatf("[MONITOR-%0d out] res=%0d | cout=%0d | oflow=%0d | e=%0d | g=%0d | l=%0d | err=%0d |",i,mitem.res,mitem.cout,mitem.oflow,mitem.e,mitem.g,mitem.l,mitem.err),UVM_LOW)

  //cloning the captured data and then writing into fifo for safety
  $cast(temp,mitem.clone());
  mport.write(temp);
  repeat(1)@(vif.mcb);
end
endtask
endclass
