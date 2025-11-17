`timescale 1ns/1ps  // Definición de la unidad de tiempo y la precisión
module tb_ShiftReg;

    // Parámetros
    reg clk;
    reg rst;
    reg signed [15:0] sig_resultado;
    reg sig_done;
    reg sig_estado;
    reg [1:0] sig_temp;
    reg [2:0] sig_contador;

    // Salidas
    wire signed [15:0] result;
    wire done;
    wire estado_actual;
    wire [1:0] temp;
    wire [2:0] contador;

    // Instancia del módulo
    BancoRegistros uut (
        .clk(clk),
        .rst(rst),
        .sig_resultado(sig_resultado),
        .sig_done(sig_done),
        .sig_estado(sig_estado),
        .sig_temp(sig_temp),
        .sig_contador(sig_contador),
        .result(result),
        .done(done),
        .estado_actual(estado_actual),
        .temp(temp),
        .contador(contador)
    );

    // Generador de clk de 27 MHz
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk; // 27 MHz -> ciclo de 37.037 ns
    end

    // Proceso de prueba
    initial begin
        // Inicialización
        rst = 0;
        sig_resultado = 16'd0;
        sig_done = 1'b0;
        sig_estado = 1'b0;
        sig_temp = 2'b00;
        sig_contador = 3'b000;

        // Aplicar reset
        #10; // Esperar 10 ns
        rst = 1;

        // Test 1: Comprobar la inicialización después del rst
        #10;
        if (result !== 16'd0 || done !== 1'b0 || estado_actual !== 1'b0 || temp !== 2'b00 || contador !== 3'b000) begin
            $display("Error en la inicialización.");
        end else begin
            $display("Inicialización correcta.");
        end

        // Test 2: Actualizar registros con valores válidos
        #10;
        sig_resultado = 16'd15; // Establecer un result válido
        sig_done = 1'b1; // Señal de que es válido
        sig_estado = 1'b1; // Cambiar estado a 1
        sig_temp = 2'b01; // Cambiar temp
        sig_contador = 3'd2; // Cambiar contador

        // Aplicar cambios
        #10; // Esperar un ciclo de clk

        // Comprobar resultados
        if (result !== 16'd15 || done !== 1'b1 || estado_actual !== 1'b1 || temp !== 2'b01 || contador !== 3'd2) begin
            $display("Error: Resultado %d, done %b, Estado %b, Temp %b, Contador %d", result, done, estado_actual, temp, contador);
        end else begin
            $display("Actualización correcta con valores: Resultado %d, done %b, Estado %b, Temp %b, Contador %d", result, done, estado_actual, temp, contador);
        end

        // Test 3: Probar el rst nuevamente
        #10;
        rst = 1; // Volver a aplicar el rst

        // Comprobar la inicialización
        #10;
        if (result !== 16'd0 || done !== 1'b0 || estado_actual !== 1'b0 || temp !== 2'b00 || contador !== 3'b000) begin
            $display("Error en la inicialización después del rst.");
        end else begin
            $display("Inicialización correcta después del rst.");
        end

        // Finalizar simulación
        #20;
        $finish;
    end

    // Monitor de salidas
    initial begin
        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0, tb_ShiftReg);
    end
endmodule
