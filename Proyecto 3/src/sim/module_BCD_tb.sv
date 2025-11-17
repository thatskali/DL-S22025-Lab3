// Testbench del module_divisor.

// Declaracion de la unidad de tiempo.
`timescale 1ns/1ps

module module_BCD_tb;

    // Declaracion de las señales para el testbench.
    logic [15:0] numero_input;
    logic clk;
    logic rst;
    logic [3:0] unidades_output;
    logic [3:0] decenas_output;
    logic [3:0] centenas_output;
    logic [3:0] millares_output;
    logic ready;

    // Declaracion de las instancias para el testbench, unidad bajo prueba "uut".
    bin_to_bcd uut (

        .numero_input(numero_input),
        .clk(clk),
        .rst(rst),
        .unidades_output(unidades_output),
        .decenas_output(decenas_output),
        .centenas_output(centenas_output),
        .millares_output(millares_output),
        .ready(ready)

    );

    // Establecer el sistema del reloj, cada periodo es igual a 10 ones de tiempo.
    always begin

        clk = 1; 
        #5;
        clk = 0;
        #5;

    end

    // Inicio de la prueba del modulo.
    initial begin

        // Valores iniciales de la prueba.
        rst = 1;
        numero_input = 0;

        // Cambio en el valor de rst, tras 10 ones de tiempo.
        #10; 
        rst = 0; 
        
        // Cambio en los valores de entrada, cada 10 ones de tiempo.
        // Primer cambio, valor introducido 1234.
        #10; numero_input = 16'd1234;
        #10; wait(ready);
        #10;
        $display("Numero: %d, Millares: %d, Centenas: %d, Decenas: %d, Unidades: %d", numero_input, millares_output, centenas_output, decenas_output, unidades_output);

        // Segundo cambio, valor introducido 5678.
        #10; numero_input = 16'd5678;
        #10; wait(ready);
        #10; 
        $display("Numero: %d, Millares: %d, Centenas: %d, Decenas: %d, Unidades: %d", numero_input, millares_output, centenas_output, decenas_output, unidades_output);

        // Tercer cambio, valor introducido 910.
        #10; numero_input = 16'd910; 
        #10; wait(ready);
        #10; 
        $display("Numero: %d, Millares: %d, Centenas: %d, Decenas: %d, Unidades: %d", numero_input, millares_output, centenas_output, decenas_output, unidades_output);
        #10; wait(ready);

        #10; 
        $display("Numero: %d, Millares: %d, Centenas: %d, Decenas: %d, Unidades: %d", numero_input, millares_output, centenas_output, decenas_output, unidades_output);

        #10;
        $finish;
    end

endmodule