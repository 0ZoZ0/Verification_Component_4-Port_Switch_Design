`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 03:17:11 PM
// Design Name: 
// Module Name: test
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


module test1();
    
  import pkg_packet::*;

  logic clk = 1'b0;
  logic reset = 1'b0;

  
  design_if port0(clk,reset);
  design_if port1(clk,reset);
  design_if port2(clk,reset);
  design_if port3(clk,reset);

  vc pvc0;
  vc pvc1;
  vc pvc2;
  vc pvc3;


  switch_port sw1 (.port0, .port1, .port2, .port3, .clk, .reset); 
  
  always
    #10 clk <= ~clk;

  initial begin
    
    port0.ip_suspend = 0;
    $timeformat(-9,2," ns",8);
    reset = 1'b0;
    @(posedge clk);
    reset = 1'b1;
    @(posedge clk);
    reset = 1'b0;

    
    pvc0 = new("pvc0", null);
    pvc0.configure(port0, 0);
    
    
    pvc1 = new("pvc1", null);
    pvc1.configure(port1, 1);
    
    
    pvc2 = new("pvc2", null);
    pvc2.configure(port2, 2);
    
    
    pvc3 = new("pvc3", null);
    pvc3.configure(port3, 3);
     
    
    fork
    pvc0.run(1);
    pvc1.run(1);
    pvc2.run(1);
    pvc3.run(1);  
    
    join    
    #500;
    $finish;
   
  end
  
    // Monitors to capture Switch output data
     initial begin : monitors
   fork
     port0.monitor(0);
     port1.monitor(1);
     port2.monitor(2);
     port3.monitor(3);
   join
 end
endmodule