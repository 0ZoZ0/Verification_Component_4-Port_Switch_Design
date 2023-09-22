`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 01:50:20 PM
// Design Name: 
// Module Name: sequencer
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


class sequencer extends base_component;
    
    int port_no, i;
    
    function new(string name, base_component parent);
        super.new(name, parent);
    endfunction
    
    function void next_item(output packet pkt);
        
        single pkt_s;
        multicast pkt_m;
        broadcast pkt_b;
        
        randcase
        1: begin
               pkt_s = new("pkt_s", port_no);
               i = pkt_s.randomize();
               pkt = pkt_s;   
           end
        1: begin
               pkt_m = new("pkt_m", port_no);
               i = pkt_m.randomize();
               pkt = pkt_m;   
           end
        1: begin
               pkt_b = new("pkt_b", port_no);
               i = pkt_b.randomize();
               pkt = pkt_b;   
           end
        endcase
    endfunction


endclass