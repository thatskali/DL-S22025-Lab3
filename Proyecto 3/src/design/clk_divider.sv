module clk_divider (
  input  logic clk,
  input  logic rst,
  output logic clk_div
);
`ifdef SIMULATION
  localparam int DIV_MAX = 15'd50;      // rápido en sim
`else
  localparam int DIV_MAX = 15'd26999;   // tu valor HW (~1 MHz)
`endif
  logic [14:0] counter;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= '0;
      clk_div <= 1'b0;
    end else begin
      if (counter == DIV_MAX) begin
        clk_div <= ~clk_div;
        counter <= '0;
      end else begin
        counter <= counter + 15'd1;
      end
    end
  end
endmodule
