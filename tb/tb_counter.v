`timescale 1ns/1ps

module tb_counter;

  parameter WIDTH = 8;
  parameter MAX_COUNT = {WIDTH{1'b1}};

  reg clk;
  reg rst_n;
  reg enable;
  reg load;
  reg [WIDTH-1:0] load_value;

  wire [WIDTH-1:0] count;
  wire irq;

  integer errors;

  // Reference model signals
  reg [WIDTH-1:0] expected_count;
  reg prev_was_max;

  //----------------------------------
  // DUT
  //----------------------------------
  counter #(
    .WIDTH(WIDTH)
  ) uut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .load(load),
    .load_value(load_value),
    .count(count),
    .irq(irq)
  );

  //----------------------------------
  // Clock generation
  //----------------------------------
  always #5 clk = ~clk;

  //----------------------------------
  // Reference Model (cycle accurate)
  //----------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      expected_count <= 0;
      prev_was_max   <= 0;
    end else begin
      prev_was_max <= (expected_count == MAX_COUNT);

      if (load)
        expected_count <= load_value;
      else if (enable) begin
        if (expected_count == MAX_COUNT)
          expected_count <= 0;
        else
          expected_count <= expected_count + 1;
      end
    end
  end

  //----------------------------------
  // Assertions
  //----------------------------------
  always @(posedge clk) begin
    if (rst_n) begin

      if (count !== expected_count) begin
        $display("ASSERT FAIL at %0t: expected %0h got %0h",
                 $time, expected_count, count);
        errors = errors + 1;
      end

      if (prev_was_max && enable && !load) begin
        if (irq !== 1) begin
          $display("ASSERT FAIL: IRQ not asserted on overflow");
          errors = errors + 1;
        end
      end

    end
  end

  //----------------------------------
  // Test sequence
  //----------------------------------
  initial begin
    $dumpfile("sim/waveform.vcd");
    $dumpvars(0, tb_counter);

    clk = 0;
    rst_n = 0;
    enable = 0;
    load = 0;
    load_value = 0;
    errors = 0;

    // Reset phase
    #20;
    rst_n = 1;

    // Test load
    @(posedge clk);
    load_value = 8'hFA;
    load = 1;
    @(posedge clk);
    load = 0;

    // Enable counting
    enable = 1;

    repeat (20) @(posedge clk);

    enable = 0;

    //----------------------------------
    // Final result
    //----------------------------------
    #10;
    if (errors == 0) begin
      $display("=================================");
      $display("TEST PASSED");
      $display("=================================");
    end else begin
      $display("=================================");
      $display("TEST FAILED with %0d errors", errors);
      $display("=================================");
    end

    #20;
    $finish;
  end

endmodule
