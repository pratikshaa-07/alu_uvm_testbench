`include"def.sv"
`include"uvm_macros.svh"
interface inf(input logic clk, rst);

  logic [`oplen-1:0] opa, opb;
  logic mode, ce, cin;
  logic [`cmdlen-1:0] cmd;
  logic [1:0] inp_valid;
  //logic valid_out;
  logic [`oplen:0] res;
  logic err, l, g, e, cout, oflow;

  clocking dcb @(posedge clk);
    default input #0 output #0;
    input  clk, rst;
    output opa, opb, mode, ce, cin, inp_valid, cmd;
  endclocking

  clocking mcb @(posedge clk);
    default input #0;
    input res, err, l, g, e, cout, oflow;
  endclocking

  clocking rcb @(posedge clk);
    default input #0;
    input clk, rst;
    input opa, opb, mode, ce, cin, inp_valid, cmd;
    input res, err, l, g, e, cout, oflow;
  endclocking

  modport DRV (clocking dcb);
  modport MON (clocking mcb);
  modport REF (clocking rcb);
    
// property p2;
//   @(posedge CLK);
//  (INP_VALID==1) |-> !$isunknown(OPA);

//    assert property (p2)
//       $info("INP_VALID is 1 and OPA is not unknown Assertion-2  Passed");
//    else
//       $error("INP_VALID is 1 and OPA is not unknow Assertion-2 Failed");

//   property p3;
//   @(posedge CLK);
//   (INP_VALID==2) |-> !$isunknown(OPB);

//    assert property (p3)
//       $info("INP_VALID is 2 and OPB is not unknown Assertion-3  Passed");
//    else
//       $error("INP_VALID is 2 and OPB is not unknow Assertion-3 Failed");

//   property p4;
//   @(posedge CLK);
//    (INP_VALID==3) |-> (!$isunknown(OPA) && !$isunknown(OPB));

//    assert property (p3)
//       $info("INP_VALID is 3 and OPA and OPB is not unknown Assertion-4  Passed");
//    else
//       $error("INP_VALID is 3 and OPA and OPB is not unknow Assertion-4 Failed");

//   property p5;
//   @(posedge CLK);
//    RST |-> (RES=='0 && E=0 && L=0 && G=0 && OFLOW=0 && COUT=0);

//    assert property (p5)
//       $info("RST condition Assertion-5  Passed");
//    else
//       $error("RST condition Assertion-5 Failed");

//   property p6;
//   @(posedge CLK);
//    CMD inside {14,15} |-> (RES='z);

//    assert property (p6)
//       $info("Invalid CMD for both modes Assertion-6  Passed");
//    else
//       $error("Inavlid CMD for both modes Assertion-6 Failed");

//   property p7;
//   @(posedge CLK);
//    (INP_VALID==3) |-> !$isunknown(CMD);

//    assert property (p7)
//   $info("INP_VALID is 3 and CMD is not unknown Assertion-7  Passed");
//    else
//       $error("INP_VALID is 3 and CMD is not unknow Assertion-7 Failed");
endinterface
    

