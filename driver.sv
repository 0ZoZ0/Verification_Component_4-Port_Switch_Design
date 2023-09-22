`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 02:01:40 PM
// Design Name: 
// Module Name: driver
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

class driver extends base_component;
  
    sequencer sref;
   
    function new (string name, base_component parent);
        super.new(name, parent);
    endfunction
    
    virtual interface design_if vif;
    packet pkt;
    
    task run(int run);
        repeat(run) begin
            sref.next_item(pkt);
            $display("Driver (%s) sends packet IN @%t", pathname(), $time);
            pkt.print();
            vif.packet_drive(pkt);
            end
    endtask
    
    
endclass