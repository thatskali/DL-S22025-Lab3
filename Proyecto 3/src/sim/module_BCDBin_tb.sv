`timescale 1ns / 1ps

module module_BCDBin_tb;

    // Declaración de señales de entrada y salida para instanciar el DUT (Device Under Test)
    reg clk;
    reg rst;
    reg ready;
    reg listo1;
    reg listo2;
    reg [7:0] num1, num2;  // Entradas BCD para los números
    wire [7:0] num1O, num2O; // Salidas decodificadas en binario
    wire ready0;
    wire error;

    // Instancia del módulo
    bcd_to_bin uut (
        .clk(clk),
        .rst(rst),
        .listo1(listo1),
        .listo2(listo2),
        .num1(num1),
        .num2(num2),
        .num1O(num1O),
        .num2O(num2O),
        .ready0(ready0),
        .error(error)
    );

    // Generación de reloj de 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Proceso de simulación
    initial begin
        // Configuración inicial
        rst = 1;
        listo1 = 0;
        listo2 = 0;
        num1 = 8'b00000000; // BCD de 00
        num2 = 8'b00000000; // BCD de 00
        
        // Desactivar reset después de un ciclo de reloj
        #10;
        rst = 0;

        // Simulación del ingreso de num1 en dos pasos, comenzando en cuanto num1 != 0
        #10;
        num1 = 8'b00000100; // Ingresar "4" en el BCD del primer número (num1)
        
        #100;
        num1 = 8'b01000010; // Completar con "2", ahora num1 = "42" en BCD
        
        #10;
        listo1 = 1;  // Activa listo2 para indicar que el segundo número puede ser ingresado

        // Ingreso de num2 en dos pasos
        #10;
        num2 = 8'b00000001; // Ingresar "1" en el BCD del segundo número (num2)
        #100;

        #10;
        num2 = 8'b00011001; // Completar con "9", ahora num2 = "19" en BCD

        #10;
        listo2 = 1;
        // Esperar a que ready0 se active, indicando que ambos números están listos
        #20;

        // Finalizar la simulación
        #10;
        $finish;
    end

        // Dump de señales
    initial begin
        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0, module_BCDBin_tb);
    end

endmodule

