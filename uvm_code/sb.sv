class sb extends uvm_scoreboard;

  uvm_tlm_analysis_fifo#(sitem) actual;
  uvm_tlm_analysis_fifo#(sitem) expected;
  int i;
  localparam bits_req = $clog2(`oplen);
  virtual inf vif;
  int shift_val;

  `uvm_component_utils(sb)

  // new
  function new(string name="", uvm_component parent=null);
      super.new(name,parent);
  endfunction

  
  // build phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual inf)::get(this,"","vif",vif))
          `uvm_error("REF","vif not set")
      actual  = new("actual", this);
      expected = new("expected", this);
      i = 0;
  endfunction

  // refmodel task
  task ref_mod(input sitem in_s, inout sitem out_s);
    
      bit is_mul;
      bit got;
      bit e, g, l, err, oflow, cout;
      bit [8:0] store;
      bit [bits_req-1:0] shift_val;
      shift_val = in_s.opb[bits_req-1:0];
      is_mul = 0;
    // `uvm_info("REF_MODEL",$sformatf("[REF] GOT PACKET"),UVM_LOW)
      out_s.cout  = 'z;
      out_s.oflow = 'z;
      out_s.e     = 'z;
      out_s.g     = 'z;
      out_s.l     = 'z;
      out_s.err   = 'z;
      out_s.res   = 'z;

if (vif.rst) begin
    out_s.cout  = 0;
    out_s.oflow = 0;
    out_s.e     = 0;
    out_s.g     = 0;
    out_s.l     = 0;
    out_s.err   = 0;
    out_s.res   = '0;
    got = 0;
end
else if ((in_s.mode == 1 && !(in_s.cmd inside {0,1,2,3,4,5,6,7,8,9,10})) ||
         (in_s.mode == 0 && !(in_s.cmd inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13}))) begin
    out_s.err = 1;
    got = 0;
end
    else if ((in_s.mode && in_s.cmd inside {0,1,2,3,8,9,10}  && (in_s.inp_valid != 2'b11 || in_s.inp_valid == 2'b00)) ||(in_s.mode==0 && (in_s.cmd inside {0,1,2,3,8,9,10}) && (in_s.inp_valid != 2'b11 || in_s.inp_valid == 2'b00))) begin
    got = 0;
    out_s.err = 1;
end
else begin
    got = 1;
end

      if (got && (in_s.ce != 0)) begin
          if (in_s.mode) begin
              case (in_s.inp_valid)
                  2'b01: begin
                      case (in_s.cmd)
                          4'd4: out_s.res = in_s.opa + 1;
                          4'd5: out_s.res = in_s.opa - 1;
                          default: out_s.res = 'z;
                      endcase
                  end
                  2'b10: begin
                      case (in_s.cmd)
                          4'd6: out_s.res = in_s.opa + 1;
                          4'd7: out_s.res = in_s.opb - 1;
                          default: out_s.res = 'z;
                      endcase
                  end
                  2'b11: begin
                      case (in_s.cmd)
                          4'd4: begin 
                              out_s.res = in_s.opa + 1; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd5: begin 
                              out_s.res = in_s.opa - 1; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd6: begin 
                              out_s.res = in_s.opb + 1; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd7: begin 
                              out_s.res = in_s.opb - 1; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd0: begin 
                              out_s.res = in_s.opa + in_s.opb; 
                              out_s.cout = out_s.res[`oplen]; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd1: begin 
                              out_s.res = in_s.opa - in_s.opb; 
                              out_s.oflow = (in_s.opa < in_s.opb); 
                              out_s.cout = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd2: begin 
                              out_s.res = in_s.opa + in_s.opb + in_s.cin; 
                              out_s.cout = out_s.res[`oplen]; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd3: begin 
                              out_s.res = in_s.opa - in_s.opb - in_s.cin; 
                              out_s.oflow = (in_s.opa >= (in_s.opb + in_s.cin)); 
                              out_s.cout = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd8: begin
                              if (in_s.opa > in_s.opb) begin 
                                  out_s.cout = 'z; 
                                  out_s.oflow = 'z; 
                                  out_s.e = 'z; 
                                  out_s.g = 1; 
                                  out_s.l = 'z; 
                                  out_s.err = 'z; 
                                  out_s.res = 'z; 
                              end
                              else if (in_s.opa < in_s.opb) begin 
                                  out_s.cout = 'z; 
                                  out_s.oflow = 'z; 
                                  out_s.e = 'z; 
                                  out_s.g = 'z; 
                                  out_s.l = 1; 
                                  out_s.err = 'z; 
                                  out_s.res = 'z; 
                              end
                              else begin 
                                  out_s.cout = 'z; 
                                  out_s.oflow = 'z; 
                                  out_s.e = 1; 
                                  out_s.g = 'z; 
                                  out_s.l = 'z; 
                                  out_s.err = 'z; 
                                  out_s.res = 'z; 
                              end
                          end
                          4'd9: begin 
                              out_s.res = (in_s.opa + 1)*(in_s.opb + 1); 
                              is_mul = 1; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          4'd10: begin 
                              out_s.res = (in_s.opa << 1) * in_s.opb; 
                              is_mul = 1; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                          end
                          default: out_s.res = 'z;
                      endcase
                  end
                  2'b00: begin 
                      out_s.err = 1; 
                      out_s.res = store; 
                      out_s.e = e; 
                      out_s.g = g; 
                      out_s.l = l; 
                  end
                  default: out_s.res = 'z;
              endcase
          end else begin : mode0_block
              case (in_s.inp_valid)
                  2'b01: begin
                      case (in_s.cmd)
                          4'd6: out_s.res = {1'b0, ~in_s.opa};
                          4'd8: out_s.res = {1'b0, in_s.opa >> 1};
                          4'd9: out_s.res = {1'b0, in_s.opa << 1};
                          default: out_s.res = 'z;
                      endcase
                  end
                  2'b10: begin
                      case (in_s.cmd)
                          4'd7: out_s.res = {1'b0, ~in_s.opb};
                          4'd10: out_s.res = {1'b0, in_s.opb >> 1};
                          4'd11: out_s.res = {1'b0, in_s.opb << 1};
                          default: out_s.res = 'z;
                      endcase
                  end
                  2'b11: begin
                      case (in_s.cmd)
                          4'd6: begin
                              out_s.res = {1'b0, ~in_s.opa}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd8: begin
                              out_s.res = {1'b0, in_s.opa >> 1}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd9: begin
                              out_s.res = {1'b0, in_s.opa << 1}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd7: begin
                              out_s.res = {1'b0, ~in_s.opb}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd10: begin
                              out_s.res = {1'b0, in_s.opb >> 1}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd11: begin
                              out_s.res = {1'b0, in_s.opb << 1}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd0: begin
                              out_s.res = {1'b0, in_s.opa & in_s.opb}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd1: begin
                              out_s.res = {1'b0, ~(in_s.opa & in_s.opb)}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd2: begin
                              out_s.res = {1'b0, in_s.opa | in_s.opb}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd3: begin
                              out_s.res = {1'b0, ~(in_s.opa | in_s.opb)}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd4: begin
                              out_s.res = {1'b0, in_s.opa ^ in_s.opb}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd5: begin
                              out_s.res = {1'b0, ~(in_s.opa ^ in_s.opb)}; 
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z;
                          end
                          4'd12: begin
                              if(|in_s.opb[`oplen-1:bits_req]) begin
                                  out_s.err = 1; 
                                  out_s.res = 0; 
                                  out_s.e = 'z; 
                                  out_s.l = 'z; 
                                  out_s.g = 'z; 
                              end else begin
                                  out_s.res = {1'b0, (in_s.opa << shift_val) | (in_s.opa >> (`oplen - shift_val))};
                                  out_s.e = 'z; 
                                  out_s.l = 'z; 
                                  out_s.g = 'z; 
                                  out_s.err = 'z;
                              end
                          end
                          4'd13: begin
                              if(|in_s.opb[`oplen-1:bits_req]) begin
                                  out_s.err = 1; 
                                  out_s.res = 0; 
                                  out_s.e = 'z; 
                                  out_s.l = 'z; 
                                  out_s.g = 'z;
                              end else begin
                                  out_s.res = {1'b0, (in_s.opa >> shift_val) | (in_s.opa << (`oplen - shift_val))};
                                  out_s.e = 'z; 
                                  out_s.l = 'z; 
                                  out_s.g = 'z; 
                                  out_s.err = 'z;
                              end
                          end
                          default: begin
                              out_s.cout = 'z; 
                              out_s.oflow = 'z; 
                              out_s.e = 'z; 
                              out_s.g = 'z; 
                              out_s.l = 'z; 
                              out_s.err = 'z; 
                              out_s.res = 'z;
                          end
                      endcase
                  end
                  2'b00: begin
                      out_s.err = 1; 
                      out_s.res = store; 
                      out_s.e = e; 
                      out_s.g = g; 
                      out_s.l = l; 
                      out_s.oflow = oflow; 
                      out_s.cout = cout;
                  end
                  default: begin 
                      out_s.cout = 'z; 
                      out_s.oflow = 'z; 
                      out_s.e = 'z; 
                      out_s.g = 'z; 
                      out_s.l = 'z; 
                      out_s.err = 'z; 
                      out_s.res = 'z; 
                  end
              endcase
          end
      end
    
      else begin //got=0
          if(in_s.ce == 0) begin
              out_s.res = store; 
              out_s.g = g; 
              out_s.e = e; 
              out_s.l = l; 
              out_s.oflow = oflow; 
              out_s.cout = cout;
          end else begin
              out_s.cout = 'z; 
              out_s.oflow = 'z; 
              out_s.e = 'z; 
              out_s.g = 'z; 
              out_s.l = 'z; 
             out_s.err = 1; 
              out_s.res = 'z;
          end
      end

     
      if(in_s.cmd != 8 && in_s.mode) 
      begin
          out_s.e = 'z; 
          out_s.g = 'z; 
          out_s.l = 'z;
      end
      store = out_s.res; g = out_s.g; e = out_s.e; l = out_s.l;
      i++;
      `uvm_info("REF",$sformatf("[REFERENCE MODEL] Passing data to scoreboard at %0t",$time), UVM_LOW)
      `uvm_info("REF",$sformatf("THE INPUTS  : CE=%0d | INP_VALID=%0d | CMD=%0d | MODE=%0d | OPA=%0d | OPB=%0d | CIN=%0d",
                in_s.ce, in_s.inp_valid, in_s.cmd, in_s.mode, in_s.opa, in_s.opb, in_s.cin), UVM_LOW)
      `uvm_info("REF",$sformatf("THE OUTPUTS : RES=%0d | OFLOW=%0d | COUT=%0d | ERR=%0d | G=%0d | E=%0d | L=%0b",
                out_s.res, out_s.oflow, out_s.cout, out_s.err, out_s.g, out_s.e, out_s.l), UVM_LOW)

  endtask

  virtual task run_phase(uvm_phase phase);
      sitem act, drv_in, exp;
      forever begin
        exp = sitem :: type_id :: create("exp");
        expected.get(drv_in);
          ref_mod(drv_in,exp);
        `uvm_info("SCOREBOARD",$sformatf("[SB-REF] res=%0d | cout=%0d | oflow=%0d | e=%0d | g=%0d | l=%0d | err=%0d ",exp.res,exp.cout,exp.oflow,exp.e,exp.g,exp.l,exp.err),UVM_LOW);
          actual.get(act);
        `uvm_info("SCOREBOARD",$sformatf("[SB-MON] res=%0d | cout=%0d | oflow=%0d | e=%0d | g=%0d | l=%0d | err=%0d ",act.res,act.cout,act.oflow,act.e,act.g,act.l,act.err),UVM_LOW);
     

        if (act.res === exp.res && act.oflow===exp.oflow && act.cout===exp.cout && act.err===exp.err && act.l===exp.l && act.e===exp.e && act.g===exp.g ) begin
          `uvm_info("SCOREBOARD",$sformatf("MATCH: Actual=Expected"), UVM_LOW)
          `uvm_info("DONE",$sformatf("--------------------------------------------------------------"), UVM_LOW)
          end 
        else begin
          `uvm_error("SCOREBOARD",$sformatf("MISMATCH: Expected! = Actual"))
              if(act.res != exp.res) `uvm_info("MISMATCH_DETAIL",$sformatf("RES mismatch: exp=%0d, act=%0d",exp.res,act.res), UVM_LOW)
              if(act.cout != exp.cout) `uvm_info("MISMATCH_DETAIL",$sformatf("COUT mismatch: exp=%0d, act=%0d",exp.cout,act.cout), UVM_LOW)
              if(act.oflow != exp.oflow) `uvm_info("MISMATCH_DETAIL",$sformatf("OFLOW mismatch: exp=%0d, act=%0d",exp.oflow,act.oflow), UVM_LOW)
              if(act.e != exp.e) `uvm_info("MISMATCH_DETAIL",$sformatf("E mismatch: exp=%0d, act=%0d",exp.e,act.e), UVM_LOW)
              if(act.g != exp.g) `uvm_info("MISMATCH_DETAIL",$sformatf("G mismatch: exp=%0d, act=%0d",exp.g,act.g), UVM_LOW)
              if(act.l != exp.l) `uvm_info("MISMATCH_DETAIL",$sformatf("L mismatch: exp=%0d, act=%0d",exp.l,act.l), UVM_LOW)
              if(act.err != exp.err) `uvm_info("MISMATCH_DETAIL",$sformatf("ERR mismatch: exp=%0d, act=%0d",exp.err,act.err), UVM_LOW)
          end
          $display("---------------------------------------------------");
      end
  endtask

endclass
