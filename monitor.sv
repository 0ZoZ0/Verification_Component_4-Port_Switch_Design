`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 02:18:39 PM
// Design Name: 
// Module Name: monitor
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


class monitor extends base_component;
    function new(string name, base_component parent);
        super.new(name, parent);
    endfunction
    
    virtual interface design_if vif;
    packet pkt;
    int port_no;
    
    task run();
        forever
            begin
                vif.packet_collect(pkt);
                $display("Port%0d Monitor (%s) captures packet IN @%t",port_no, pathname(), $time);
                pkt.print();
            end
    endtask
endclass