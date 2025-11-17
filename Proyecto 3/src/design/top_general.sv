// Nota: Bloque Top. Integra teclado, conversores, multiplicador y display.

module top_general (
    input  wire        clk,
    input  wire        rst,
    output wire [3:0]  row,        // el DUT barre filas (salida)
    input  wire [3:0]  column,     // columnas entran desde keypad/TB
    output wire [6:0]  segments,
    output wire [3:0]  digit_sel
);

    // Líneas internas
    wire [7:0]  first_num, second_num;
    wire        ready_1, ready_2, listo_teclado;
    wire        done;
    wire [15:0] resultado_mult;
    wire [15:0] numero_bcd;
    wire [3:0]  ones, tens, hundreds, thousands;
    wire        listo_bcd;
    wire [3:0]  key_out;
    wire        listoBCDBin;
    wire [7:0]  num1O, num2O;
    wire        error;
    wire        clk_div;

    // Divisor (usa -DSIMULATION para hacerlo rápido en sim)
    clk_divider u_divisor (
        .clk    (clk),
        .rst    (rst),
        .clk_div(clk_div)
    );

`ifdef SIMULATION
    // ===== BYPASS TOTAL para simular solo el driver de 7-seg =====
    // Row/column no se usan en esta prueba
    assign row     = 4'b1111;
    assign key_out = 4'b0000;

    // Registritos para los 4 dígitos y el ready con PULSO
    logic [3:0] ones_r, tens_r, hundreds_r, thousands_r;
    logic       listo_bcd_r;

    // Después de reset, carga "0408" y da un pulso de ready
    always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
        ones_r      <= 4'd0;
        tens_r      <= 4'd0;
        hundreds_r  <= 4'd0;
        thousands_r <= 4'd0;
        listo_bcd_r <= 1'b0;
      end else begin
        // espera unas decenas de ciclos y luego emite un pulso
        // (suficiente para que el driver lo detecte)
        ones_r      <= 4'd8;
        tens_r      <= 4'd0;
        hundreds_r  <= 4'd4;
        thousands_r <= 4'd0;

        // pulso de 1 ciclo
        if (!listo_bcd_r)
          listo_bcd_r <= 1'b1;
        else
          listo_bcd_r <= 1'b0;
      end
    end

    // Conectar los registros al resto del top
    assign ones       = ones_r;
    assign tens       = tens_r;
    assign hundreds   = hundreds_r;
    assign thousands  = thousands_r;
    assign listo_bcd  = listo_bcd_r;

    // Desactivar el resto del pipeline en esta prueba (evitar X)
    assign ready_1        = 1'b1;
    assign ready_2        = 1'b1;
    assign listo_teclado  = 1'b1;
    assign listoBCDBin    = 1'b1;
    assign first_num      = 8'd0;
    assign second_num     = 8'd0;
    assign resultado_mult = 16'd0;
    assign numero_bcd     = 16'd0;
`else
    // ===== Keypad real (hardware) =====
    keypad u_teclado (
      .clk       (clk_div),
      .rst       (rst),
      .row       (row),
      .column    (column),
      .key_out   (key_out),
      .first_num (first_num),
      .second_num(second_num),
      .ready_1   (ready_1),
      .ready_2   (ready_2),
      .ready     (listo_teclado)
    );
`endif

    // BCD -> Binario (operandos)
    bcd_to_bin decoBCDBin (
        .clk    (clk),
        .rst    (rst),
        .listo1 (ready_1),
        .listo2 (ready_2),
        .num1   (first_num),
        .num2   (second_num),
        .num1O  (num1O),
        .num2O  (num2O),
        .ready0 (listoBCDBin),
        .error  (error)
    );

    // Multiplicador Booth 8x8 con signo
    booth_multiplier u_mult (
        .clk          (clk),
        .rst          (rst),
        .valid        (listoBCDBin),
        .multiplicando(num1O),
        .multiplicador(num2O),
        .result       (resultado_mult),
        .done         (done)
    );

    // Selección de qué valor mostrar
    priority_mux u_prio (
        .clk          (clk),
        .rst          (rst),
        .num_1        (num1O),            // 8 bits
        .num_2        (num2O),            // 8 bits
        .num_mul      (resultado_mult),
        .ready_1      (ready_1),
        .ready_2      (ready_2),
        .ready        (done),
        .numero_output(numero_bcd)
    );

    // Binario -> BCD (4 dígitos)
    bin_to_bcd u_bcd (
        .clk              (clk),
        .rst              (rst),
        .numero_input     (numero_bcd),
        .unidades_output  (ones),
        .decenas_output   (tens),
        .centenas_output  (hundreds),
        .millares_output  (thousands),
        .ready            (listo_bcd)
    );

    // Driver de 7 segmentos (refresco con reloj lento)
    sevenseg_driver u_display (
        .clk           (clk_div),
        .rst           (rst),
        .unidades_input(ones),
        .decenas_input (tens),
        .centenas_input(hundreds),
        .millares_input(thousands),
        .ready         (listo_bcd),
        .segments      (segments),
        .digit_sel     (digit_sel)
    );

endmodule
