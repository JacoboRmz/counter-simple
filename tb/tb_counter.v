`timescale 1ns/1ps
module tb_counter;
  parameter WIDTH = 8;
  reg clk;
  reg rst_n;
  reg enable;
  reg load;
  reg [WIDTH-1:0] load_value;
  wire [WIDTH-1:0] count;
  wire irq;

  counter #(.WIDTH(WIDTH)) uut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .load(load),
    .load_value(load_value),
    .count(count),
    .irq(irq)
  );

  initial begin
    $dumpfile("sim/waveform.vcd");
    $dumpvars(0, tb_counter);

    clk = 0;
    rst_n = 0;
    enable = 0;
    load = 0;
    load_value = 0;

    #20; rst_n = 1;

    #20;
    load_value = 8'hFA;
    load = 1;
    #10;
    load = 0;

    #50;
    enable = 1;
    #100;
    enable = 0;

    #50;
    $finish;
  end

  always #5 clk = ~clk;

endmodule
