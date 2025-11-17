`timescale 1ns/1ps
module tb_BoothMul;
    // Parámetros
    parameter N = 8;        // Número de bits para multiplicando y multiplicador
    parameter MAX_CYCLES = 1000; // Máximo número de ciclos de espera
    
    // Señales de prueba
    logic clk;
    logic rst;
    logic valid;
    logic signed [N-1:0] multiplicando;
    logic signed [N-1:0] multiplicador;
    logic signed [2*N-1:0] result;
    logic done;
    
    // Contador de ciclos
    int ciclos_espera;

    // Instancia del módulo booth_multiplier
    booth_multiplier uut (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .multiplicando(multiplicando),
        .multiplicador(multiplicador),
        .result(result),
        .done(done)
    );

    // Generador de reloj de 27 MHz
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk; // 27 MHz -> ciclo de 37.037 ns
    end

    // Tarea para realizar una multiplicación
    task automatic realizar_multiplicacion(
        input logic signed [N-1:0] mult1,
        input logic signed [N-1:0] mult2,
        input int num_prueba
    );
        ciclos_espera = 0;
        
        // Configurar operandos
        multiplicando = mult1;
        multiplicador = mult2;
        
        // Iniciar multiplicación
        @(posedge clk);
        valid = 1;
        @(posedge clk);
        valid = 0;
        
        // Esperar result o timeout
        while (!done && ciclos_espera < MAX_CYCLES) begin
            @(posedge clk);
            ciclos_espera = ciclos_espera + 1;
        end
        
        // Verificar result
        if (ciclos_espera >= MAX_CYCLES) begin
            $display("✗ Prueba %0d: TIMEOUT después de %0d ciclos", num_prueba, ciclos_espera);
            $display("  Operación: %0d * %0d", mult1, mult2);
        end else begin
            if (result == (mult1 * mult2))
                $display("✓ Prueba %0d Exitosa: %0d * %0d = %0d (tomó %0d ciclos)", 
                    num_prueba, mult1, mult2, result, ciclos_espera);
            else
                $display("✗ Prueba %0d Fallida: %0d * %0d = %0d (esperado: %0d, tomó %0d ciclos)", 
                    num_prueba, mult1, mult2, result, mult1 * mult2, ciclos_espera);
        end
        
        // Esperar unos ciclos entre pruebas
        repeat(5) @(posedge clk);
    endtask

    // Proceso de prueba
    initial begin
        // Inicialización
        rst = 0;
        multiplicando = 0;
        multiplicador = 0;
        valid = 0;
        
        // Aplicar reset
        repeat(5) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        repeat(5) @(posedge clk);
        
        // Ejecutar pruebas con más casos extremos y números de 2 dígitos
        realizar_multiplicacion(10, 10, 1);       // Test 1: 10 x 10
        realizar_multiplicacion(50, -2, 2);       // Test 2: 50 x -2
        realizar_multiplicacion(-99, 1, 3);       // Test 3: -99 x 1
        realizar_multiplicacion(99, 1, 4);        // Test 4: 99 x 1
        realizar_multiplicacion(99, 99, 5);       // Test 5: 99 x 99
        realizar_multiplicacion(99, -99, 6);      // Test 6: 99 x -99
        realizar_multiplicacion(-50, -50, 7);     // Test 7: -50 x -50
        realizar_multiplicacion(15, -15, 8);      // Test 8: 15 x -15
        realizar_multiplicacion(25, 25, 9);       // Test 9: 25 x 25
        realizar_multiplicacion(-35, 35, 10);     // Test 10: -35 x 35
        
        // Finalizar simulación
        repeat(5) @(posedge clk);
        $display("\nSimulación completada");
        $finish;
    end

    // Dump de señales
    initial begin
        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0, tb_BoothMul);
    end
endmodule
