`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 02:50:35 PM
// Design Name: 
// Module Name: vc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


class vc extends base_component;

 agent agn;

  function new (string name, base_component parent);
    super.new(name, parent);
    agn = new("agn", this);
  endfunction

  function void configure(virtual interface design_if vif, int port_no);
    agn.drv.vif = vif;
    agn.mon.vif = vif;
    agn.seq.port_no = port_no;
    agn.mon.port_no = port_no;
  endfunction
    
  task run(int runs);
    fork
      agn.mon.run();
    join_none
      agn.drv.run(runs);
      
  endtask
endclass
