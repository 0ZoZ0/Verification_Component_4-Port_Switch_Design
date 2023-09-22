`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 01:51:19 PM
// Design Name: 
// Module Name: base_component
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

class base_component;

    protected string name;
    base_component parent;

    function new(string name, base_component parent);
        this.name = name;
        this.parent = parent;
    endfunction
    
    function string pathname();
        base_component ptr = this;
        pathname = name;
        while (ptr.parent != null) begin
            ptr = ptr.parent;
            pathname = {ptr.name, ".", pathname};
        end
    endfunction : pathname
  
endclass