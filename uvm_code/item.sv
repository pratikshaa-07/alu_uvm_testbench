`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include"def.sv"
  import uvm_pkg::*;
 // import pkg::*;

class sitem extends uvm_sequence_item;
rand bit [`oplen-1:0]opa;
rand bit [`oplen-1:0]opb;
rand bit cin;
rand bit mode;
rand bit ce;
rand bit [`cmdlen-1:0]cmd;
rand bit [1:0]inp_valid;
logic [`oplen:0] res;
logic e,g,l;
logic cout,oflow;
logic err;

`uvm_object_utils_begin(sitem)
`uvm_field_int(opa,UVM_ALL_ON)
`uvm_field_int(opb,UVM_ALL_ON)
`uvm_field_int(cin,UVM_ALL_ON)
`uvm_field_int(ce,UVM_ALL_ON)
`uvm_field_int(cmd,UVM_ALL_ON)
`uvm_field_int(inp_valid,UVM_ALL_ON)
`uvm_field_int(mode,UVM_ALL_ON)
`uvm_field_int(res,UVM_ALL_ON)
`uvm_field_int(oflow,UVM_ALL_ON)
`uvm_field_int(cout,UVM_ALL_ON)
`uvm_field_int(e,UVM_ALL_ON)
`uvm_field_int(g,UVM_ALL_ON)
`uvm_field_int(l,UVM_ALL_ON)
`uvm_field_int(err,UVM_ALL_ON)
`uvm_object_utils_end

function new(string name="sitem");
    super.new(name);
endfunction
endclass
