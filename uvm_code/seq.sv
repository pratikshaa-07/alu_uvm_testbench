`include"def.sv"
`include"uvm_macros.svh"

//base seq
class seq extends uvm_sequence#(sitem);
`uvm_object_utils(seq)

function new(string name="");
    super.new(name);
endfunction

virtual task body();
    repeat (50)
    begin
      `uvm_do_with(req,{req.ce==1'b1;})
    end
endtask
endclass

//arithematic
class seq1 extends seq;
`uvm_object_utils(seq1)

function new(string name="");
    super.new(name);
endfunction

task body();
    repeat(50)
    begin
    `uvm_do_with(req,{req.mode==1'b1;req.ce==1'b1;})
    end
endtask
endclass

//logical
class seq2 extends seq;
`uvm_object_utils(seq2)

function new(string name="");
    super.new(name);
endfunction

task body();
    repeat(50)
    begin
    `uvm_do_with(req,{req.mode==1'b0;req.ce==1'b1;})
    end
endtask
endclass

//tc-4
class seq3 extends seq;
  `uvm_object_utils(seq3)

function new(string name="");
    super.new(name);
endfunction

task body();
    repeat(50)
    begin
  `uvm_do_with(req,{req.inp_valid==2'b00;})
    end
endtask
endclass

//invalid command
class seq4 extends seq;
  `uvm_object_utils(seq4)

function new(string name="");
    super.new(name);
endfunction

task body();
    repeat(50)
   begin
  `uvm_do_with(req,{req.cmd inside {14,15};})
  end
endtask
endclass

//ce=0
class seq5 extends seq;
  `uvm_object_utils(seq5)

function new(string name="");
    super.new(name);
endfunction

task body();
    repeat(50)
    begin
    `uvm_do_with(req,{req.ce==1'b0;})
    end
endtask
endclass

//shift
class seq6 extends seq;
  `uvm_object_utils(seq6)

function new(string name="");
    super.new(name);
endfunction

task body();
    repeat(50)
    begin
    `uvm_do_with(req,{req.mode==1'b0;req.ce==1'b1;req.cmd inside {12,13};})
    end
endtask
endclass

//regression
class regr extends uvm_sequence#(sitem);
`uvm_object_utils(regr);
//handles of testcases
seq s;
seq1 s1;
seq2 s2;
seq3 s3;
seq4 s4;
seq5 s5;
seq6 s6;

function new(string name="");
    super.new(name);
endfunction

task body();
    `uvm_do(s)
    `uvm_do(s1)
    `uvm_do(s2)
    `uvm_do(s3)
    `uvm_do(s4)
    `uvm_do(s5)
endtask
endclass


