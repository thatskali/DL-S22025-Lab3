`timescale 1ns/1ps
module tb_UnidadControl;

    // Parámetros
    reg clk;
    reg rst;
    reg valid;
    reg [2:0] contador;
    reg estado_actual;

    // Salidas
    wire sig_estado;
    wire [2:0] sig_contador;
    wire sig_valido;

    // Instancia del módulo
    control_unit uut (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .contador(contador),
        .estado_actual(estado_actual),
        .sig_estado(sig_estado),
        .sig_contador(sig_contador),
        .sig_valido(sig_valido)
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
        valid = 0;
        contador = 3'd0;
        estado_actual = 1'b0;

        // Aplicar reset
        #10;
        rst = 1;

        // Test 1: Comprobar la inicialización después del rst
        #10;
        if (sig_valido !== 1'b0 || sig_contador !== 3'b000 || sig_estado !== estado_actual) begin
            $display("Error en la inicialización.");
        end else begin
            $display("Inicialización correcta.");
        end

        // Test 2: Activar valid
        #10;
        valid = 1; // Activar valid

        // Aplicar cambios
        #10; // Esperar un ciclo de clk

        // Comprobar resultados
        if (sig_estado !== 1'b1 || sig_contador !== 3'b001) begin
            $display("Error: Estado %b, Contador %d", sig_estado, sig_contador);
        end else begin
            $display("Estado cambiado a multiplicar: Estado %b, Contador %d", sig_estado, sig_contador);
        end

        // Test 3: Probar transición de estado
        #10;
        contador = 3'd6; // Cambiar contador a 6

        // Aplicar cambios
        #10; // Esperar un ciclo de clk

        // Comprobar resultados
        if (sig_estado !== 1'b1 || sig_contador !== 3'd7) begin
            $display("Error en el estado final: Estado %b, Contador %d", sig_estado, sig_contador);
        end else begin
            $display("Contador incrementado: Estado %b, Contador %d", sig_estado, sig_contador);
        end

        // Finalizar simulación
        #20;
        $finish;
    end
    // Dump de señales
    initial begin
        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0, tb_UnidadControl);
    end
endmodule
