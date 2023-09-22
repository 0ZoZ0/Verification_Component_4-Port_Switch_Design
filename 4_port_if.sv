`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 11:33:53 AM
// Design Name: 
// Module Name: 4_port_if
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

/*

We are having 4-ports swtich design in which data is input to one of the port and the same data is sent to output of the port depending upon the type pf packet received

Packet_type: 1) Single: Data packet is sent to single port other than the source
             2) Multicast: Data packet is sent to multiple port other than the source
             3) Broadcast: Data packet is sent to all the port 

*/

interface design_if(
        input clk, rst);
        
        import pkg_packet::*;
        
        //input port signals
        logic ip_valid, ip_suspend;
        logic [15:0] ip_data;
        
        //output port signals
        logic op_valid, op_suspend;
        logic [15:0] op_data;
        
        
        always @(posedge rst)
        begin
            ip_valid <= 0;
            op_suspend <= 0;
        end
        
        //Driver Component task to send data to the dut
        task packet_drive(input packet pkt);
            @(posedge clk iff ip_suspend == 0);
                ip_data = {pkt.data, pkt.source, pkt.target};
                ip_valid = 1;
            @(posedge clk iff ip_suspend ==0);
                ip_valid = 0;
            repeat(2)
                @(posedge clk);
        endtask
        
        //Monitor Component task collecting data from the interface (data semt from driver to dut)
        task packet_collect(output packet pkt);
            @(posedge ip_valid);
                pkt = new("pkt",0);
                {pkt.data, pkt.source, pkt.target} = ip_data;
                pkt.packet_type = type_derive(pkt);
        endtask
        
        //Monitor Component task for data coming from the dut to the interface
        task monitor(int port_no);
            packet pkt;
            $display("Monitor started for port no. -- %0d", port_no);
            forever
                begin
                    @(posedge op_valid)
                    pkt = new("pkt",0);
                    {pkt.data, pkt.source, pkt.target} = op_data;
                    pkt.packet_type = type_derive(pkt);
                    $display("port %0d interface monitor: packet OUT @%t", port_no, $time);
                    pkt.print(); 
                end
        endtask
        
        function packet_type_t type_derive(packet pkt);
            case (pkt.target) inside
                1,2,4,8: type_derive = SINGLE;
                15     : type_derive = BROADCAST;
                3,[5:7],[8:14]: type_derive = MULTICAST;
                0      : $display("ERROR: target 0 found in task monitor");
                default: $display("ERROR: unknown target %b found in task monitor", pkt.target);
            endcase
        endfunction
            
endinterface