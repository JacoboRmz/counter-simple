/*
  counter.v
  Simple synchronous counter with enable, load and irq when reach MAX.
*/
module counter #(
  parameter WIDTH = 8,
  parameter [WIDTH-1:0] MAX_COUNT = {WIDTH{1'b1}} // default all ones
)(
  input  wire                  clk,
  input  wire                  rst_n,    // active low reset
  input  wire                  enable,
  input  wire                  load,
  input  wire [WIDTH-1:0]      load_value,
  output reg  [WIDTH-1:0]      count,
  output reg                   irq
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= {WIDTH{1'b0}};
      irq   <= 1'b0;
    end else begin
      irq <= 1'b0; // default deassert
      if (load) begin
        count <= load_value;
      end else if (enable) begin
        if (count == MAX_COUNT) begin
          count <= {WIDTH{1'b0}};
          irq <= 1'b1;
        end else begin
          count <= count + 1'b1;
        end
      end
    end
  end

endmodule
