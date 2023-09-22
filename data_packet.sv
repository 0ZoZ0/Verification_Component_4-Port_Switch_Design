`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 11:47:09 AM
// Design Name: 
// Module Name: data_packet
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

typedef enum {ANY,SINGLE,MULTICAST,BROADCAST} packet_type_t;

class packet;

    string name;
    
    rand bit [3:0] target;
    bit [3:0] source;
    rand bit [7:0] data;
    
    packet_type_t packet_type;
    
    function new(string name, int i);
        this.name = name;
        this.source = 1 << i;
        this.packet_type = ANY;
    endfunction
    
    
    constraint target_not_zero {target != 0;}
    constraint target_and_source_different { |(target & source) != 1;}
    
    task print();
        $display("%s----%s", name, get_type());
        $display("Source: %0d Target: %0d Data: %0d", source, target, data);
    endtask
    
    function string get_type();
        return packet_type.name();
    endfunction
    
    function string get_name();
        return name;
    endfunction

endclass

class single extends packet;
       constraint single {target inside {1,2,4,8};}
    
       function new (string name, int i);
         super.new(name, i);
         packet_type = SINGLE;
       endfunction
       
endclass
 
class multicast extends packet;
       constraint multicast {target inside {3,[5:7],[9:14]};}
    
       function new (string name, int i);
         super.new(name, i);
         packet_type = MULTICAST;
       endfunction
       
endclass
 
class broadcast extends packet;
       constraint target_and_source_different {}
       constraint broadcast {target == 15;}
      
       function new (string name, int i);
         super.new(name, i);
         packet_type = BROADCAST;
       endfunction
       
endclass 