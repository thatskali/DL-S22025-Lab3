`timescale 1ns/1ps
module tb_AluMult;

    // Parámetros
    reg clk;
    reg rst;
    reg valid;
    reg signed [7:0] multiplicando;
    reg signed [7:0] multiplicador;
    reg [1:0] temp;
    reg [2:0] contador;
    reg estado_actual;
    reg signed [15:0] result;

    // Salidas
    wire [1:0] sig_temp;
    wire signed [15:0] sig_resultado;

    // Instancia del módulo
    AluMult uut (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .multiplicando(multiplicando),
        .multiplicador(multiplicador),
        .temp(temp),
        .contador(contador),
        .estado_actual(estado_actual),
        .result(result),
        .sig_temp(sig_temp),
        .sig_resultado(sig_resultado)
    );

    // Generador de clk de 27 MHz
    initial begin
        clk= 0;
        forever #18.5 clk= ~clk; // 27 MHz -> ciclo de 37.037 ns
    end

    // Proceso de prueba
    initial begin
        // Inicialización
        rst = 0;
        valid = 0;
        multiplicando = 8'd5; // Ejemplo
        multiplicador = 8'd3; // Ejemplo
        temp = 2'b00;
        contador = 3'b000;
        estado_actual = 1'b0;
        result = 16'd0;

        // Aplicar reset
        #10;
        rst = 1;

        // Test 1: Comprobar la inicialización después del rst
        #10;
        if (sig_temp !== 2'b00 || sig_resultado !== 16'd0) begin
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
        if (sig_temp !== {multiplicando[0], 1'b0} || sig_resultado !== {8'd0, multiplicando}) begin
            $display("Error: Temp %b, Resultado %d", sig_temp, sig_resultado);
        end else begin
            $display("Estado cambiado a multiplicar: Temp %b, Resultado %d", sig_temp, sig_resultado);
        end

        // Test 3: Probar multiplicación
        #10;
        temp = 2'b01; // Ejemplo
        contador = 3'b001; // Cambiar contador a 1

        // Aplicar cambios
        #10; // Esperar un ciclo de clk

        // Comprobar resultados
        if (sig_temp !== {multiplicando[contador + 1], multiplicando[contador]} || sig_resultado !== (result >>> 1)) begin
            $display("Error en la multiplicación: Temp %b, Resultado %d", sig_temp, sig_resultado);
        end else begin
            $display("Multiplicación correcta: Temp %b, Resultado %d", sig_temp, sig_resultado);
        end

        // Finalizar simulación
        #20;
        $finish;
    end

        // Dump de señales
    initial begin
        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0, tb_AluMult);
    end



endmodule