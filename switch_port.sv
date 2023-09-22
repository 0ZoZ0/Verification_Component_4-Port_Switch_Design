`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 03:56:42 PM
// Design Name: 
// Module Name: switch_port
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


module switch_port ( design_if port0, port1, port2, port3,
                     input logic clk, reset);

  // switchring data 
  typedef logic[19:0] switchdata_t;


  bit debug = 0;

  // switchring unpacked array of pkts
  switchdata_t switchring [3:0];

  // input & output port FIFO's
  switchdata_t qin_zero [$:4];
  switchdata_t qin_one [$:4];
  switchdata_t qin_two [$:4];
  switchdata_t qin_three [$:4];
  switchdata_t qout_zero [$:4];
  switchdata_t qout_one [$:4];
  switchdata_t qout_two [$:4];
  switchdata_t qout_three [$:4];

  typedef enum {check, shift} state_t;
  state_t state;
  
  int packets_out, packets_in, packets_dropped;

 // loading from input ports
 always@(negedge clk iff port0.ip_valid == 1'b1)
   begin: port0_load
   qin_zero.push_back({port0.ip_data, port0.ip_data[3:0]});
   if (debug) $display("SWITCH: pkt in switch port 0 %h", port0.ip_data);
   packets_in++;
   end

 always@(negedge clk)
   begin: sus_check
   if (qin_zero.size() >= 4) begin
     port0.ip_suspend = 1'b1;
     $display("port0 input suspended");
   end
   else
     port0.ip_suspend = 1'b0;
   end
   
 always@(negedge clk iff port1.ip_valid == 1'b1)
   begin: port1_load
   qin_one.push_back({port1.ip_data, port1.ip_data[3:0]});
   if (debug) $display("SWITCH: pkt in switch port 1 %h", port1.ip_data);
   packets_in++;
   end

 assign port1.ip_suspend = (qin_one.size() >= 4);

 always@(negedge clk iff port2.ip_valid == 1'b1)
   begin: port2_load
   qin_two.push_back({port2.ip_data, port2.ip_data[3:0]});
   if (debug) $display("SWITCH: pkt in switch port 2 %h", port2.ip_data);
   packets_in++;
   end

 assign port2.ip_suspend = (qin_two.size() >= 4);

 always@(negedge clk iff port3.ip_valid == 1'b1)
   begin: port3_load
   qin_three.push_back({port3.ip_data, port3.ip_data[3:0]});
   if (debug) $display("SWITCH: pkt in switch port 3 %h", port3.ip_data);
   packets_in++;
   end

 assign port3.ip_suspend = (qin_three.size() >= 4);

 always
   begin: port0_unload
   port0.op_valid = 1'b0;
   @(negedge clk iff (qout_zero.size()> 0));
   wait (port0.op_suspend == 0);
   port0.op_data = qout_zero.pop_front();      
   port0.op_valid = 1'b1;
   if (debug) $display("SWITCH: pkt out switch port 0 %h @ %0d", port0.op_data, $time);
   packets_out++;
   @(negedge clk);
   end
   
 always
   begin: port1_unload
   port1.op_valid = 1'b0;
   @(negedge clk iff (qout_one.size()> 0));
   wait (port1.op_suspend == 0);
   port1.op_data = qout_one.pop_front();      
   port1.op_valid = 1'b1;
   if (debug) $display("SWITCH: pkt out switch port 1 %h @ %0d", port1.op_data, $time);
   packets_out++;
   @(negedge clk);
   end
   
 always
   begin: port2_unload
   port2.op_valid = 1'b0;
   @(negedge clk iff (qout_two.size()> 0))
   wait (port2.op_suspend == 0);
   port2.op_data = qout_two.pop_front();      
   port2.op_valid = 1'b1;
   if (debug) $display("SWITCH: pkt out switch port 2 %h @ %0d", port2.op_data, $time);
   packets_out++;
   @(negedge clk);
   end
   
 always
   begin: port3_unload
   port3.op_valid = 1'b0;
   @(negedge clk iff (qout_three.size()> 0))
   wait (port3.op_suspend == 0);
   port3.op_data = qout_three.pop_front();      
   port3.op_valid = 1'b1;
   if (debug) $display("SWITCH: pkt out switch port 3 %h @ %0d", port3.op_data, $time);
   packets_out++;
   @(negedge clk);
   end
   

   
 always@(negedge clk, posedge reset)
  if (reset) begin
    switchring = '{default:0};
    state = check;
    end
  else begin
  

  case (state)

  check : begin
          if (switchring[3][3] && (qout_three.size() < 4)) 
            begin
            switchring[3][3] <= 0;
            qout_three.push_back(switchring[3][19:4]);
            end
          if (switchring[2][2] && (qout_two.size() < 4)) 
            begin
            switchring[2][2] <= 0;
            qout_two.push_back(switchring[2][19:4]);
            end
          if (switchring[1][1] && (qout_one.size() < 4)) 
            begin
            switchring[1][1] <= 0;
            qout_one.push_back(switchring[1][19:4]);
            end

          if (switchring[0][0] && (qout_zero.size() < 4)) 
            begin
            switchring[0][0] <= 0;
            qout_zero.push_back(switchring[0][19:4]);
            end
          state <= shift;
          end

  shift : begin
           // switch 3
          if (switchring[0][3:0] != 0)
             switchring[3] <= switchring[0];
           else if (qin_three.size() > 0)
             switchring[3] <= qin_three.pop_front();
           else
             switchring[3] <= 0;
          
          // switch 2
          if (switchring[3][3:0] != 0)
             switchring[2] <= switchring[3];
          else if (qin_two.size() > 0)
             switchring[2] <= qin_two.pop_front();
          else
             switchring[2] <= 0;

          // switch 1
          if (switchring[2][3:0] != 0)
             switchring[1] <= switchring[2];
          else if (qin_one.size() > 0)
             switchring[1] <= qin_one.pop_front();
          else
             switchring[1] <= 0;

          // switch 0
          if (switchring[1][3:0] != 0)
             begin
             switchring[0] <= switchring[1];
             end
          else if (qin_zero.size() > 0)
             switchring[0] <= qin_zero.pop_front();
          else
             switchring[0] <= 0;
          
          state <= check;
          end 

  endcase

 end 


endmodule