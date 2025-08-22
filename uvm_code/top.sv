`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "pkg.sv"
`include "inf.sv"
`include "design.sv"
module top;

  import uvm_pkg::*; 
  import pkg::*;
 

  bit clk = 0;
  bit rst = 0;

  initial begin
    forever #10 clk = ~clk;
  end

  initial begin
    rst = 1;
    repeat(1) @(posedge clk);
    rst = 0;
  end

   inf intf(clk,rst);
   ALU_DESIGN  dut(
    .CLK(clk),.RST(rst),
      .OPA(intf.opa),
      .OPB(intf.opb),
      .INP_VALID(intf.inp_valid),
      .CMD(intf.cmd),
      .MODE(intf.mode),
      .CE(intf.ce),
      .CIN(intf.cin),
      .RES(intf.res),
      .COUT(intf.cout),
      .ERR(intf.err),
      .OFLOW(intf.oflow),
      .G(intf.g),
      .E(intf.e),
      .L(intf.l)
  );

  initial begin

    uvm_config_db#(virtual inf)::set(uvm_root::get(),"*","vif",intf);

//     $dumpfile("dump.vcd");

//  $dumpvars;

  end

  initial begin

    run_test("reg_test");

      #100 $finish;

  end
endmodule

