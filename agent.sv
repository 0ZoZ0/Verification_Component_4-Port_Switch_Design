`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 02:47:02 PM
// Design Name: 
// Module Name: agent
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


class agent extends base_component;

 driver drv;
 sequencer seq;
 monitor mon;

  function new (string name, base_component parent);
    super.new(name, parent);
    drv = new("drv", this);
    seq = new("seq", this);
    mon = new("mon",this);
    drv.sref = seq;
  endfunction
  
endclass