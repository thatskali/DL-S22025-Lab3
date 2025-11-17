`timescale 1ns/1ps
`define SIMULATION   // fuerza el camino de simulación dentro del DUT

module top_general_tb;

  // ===== Config =====
  localparam SAFETY_FINISH_NS = 200_000_000; // 200 ms

  // ===== Señales TB <-> DUT =====
  logic        clk;
  logic        rst;
  wire  [3:0]  row;        // salida del DUT
  logic [3:0]  column;     // entrada (no la usamos en este modo)
  wire  [6:0]  segments;
  wire  [3:0]  digit_sel;

  // DUT
  top_general dut (
    .clk      (clk),
    .rst      (rst),
    .row      (row),
    .column   (column),
    .segments (segments),
    .digit_sel(digit_sel)
  );

  // Reloj y reset
  initial clk = 1'b0;
  always #10 clk = ~clk;       // 50 MHz (20 ns)
  initial begin
    $timeformat(-9,3," ns",10);
    rst    = 1'b1;
    column = 4'b1111;          // pull-ups; no usaremos el keypad real
    repeat (50) @(posedge clk);
    rst    = 1'b0;
  end

// ==================== MONITOREO LIGERO ====================
logic [31:0] sample_cnt = 0;

always @(posedge clk) begin
  sample_cnt <= sample_cnt + 1;
  // Muestra cada ~1 ms aprox (a 50 MHz -> 50_000 ciclos ≈ 1 ms)
  if (sample_cnt == 32'd50_000) begin
    sample_cnt <= 0;
    $display("%12t | res=%h  num_bcd=%h  seg=%b  dsel=%b  r1=%b r2=%b vld=%b done=%b listo_bcd=%b",
             $time,
             dut.resultado_mult,
             dut.numero_bcd,
             segments,
             digit_sel,
             dut.ready_1, dut.ready_2, dut.listoBCDBin, dut.done, dut.listo_bcd);
  end
end

// ============== CONDICIÓN DE SALIDA POR EVENTO ==============
// Termina cuando el multiplicador termina o el BCD está listo.
initial begin
  // Espera a que arranque (sale de reset)
  repeat (200_000) @(posedge clk);
  fork
    begin
      wait (dut.done === 1'b1);
      $display("[%0t] done=1 -> fin en 5 ms", $time);
      repeat (250_000) @(posedge clk);   // ~5 ms extra
      $finish;
    end
    begin
      wait (dut.listo_bcd === 1'b1);
      $display("[%0t] listo_bcd=1 -> fin en 5 ms", $time);
      repeat (250_000) @(posedge clk);   // ~5 ms extra
      $finish;
    end
  join_none
end

// ============== CORTE DE SEGURIDAD (por si algo falla) ==============
initial begin
  #(200_000_000);  // 200 ms
  $display("[%0t] FIN forzado por seguridad", $time);
  $finish;
end

  // Simulación (no hay teclado que presionar en este modo)
  initial begin
    // deja correr suficiente para ver el resultado en display
    repeat (5_000_000) @(posedge clk); // ~100 ms
    $finish;
  end

  // VCD
  initial begin
    $dumpfile("module_top_general_tb.vcd");
    $dumpvars(0, top_general_tb);
    $dumpvars(0, dut);  // el DUT (submódulos e internos)
  end



endmodule
