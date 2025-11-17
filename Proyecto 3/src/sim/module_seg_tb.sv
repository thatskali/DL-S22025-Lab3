// Testbench del subsistema 3, modulo en uut sevenseg_driver.

// Declaracion de la unidad de tiempo.
`timescale 1ns/1ps

module module_seg_tb;

    // Declaracion de las señales para el testbench.
    logic clk;
    logic rst;
    logic [3:0] unidades_input;
    logic [3:0] decenas_input;
    logic [3:0] centenas_input;
    logic [3:0] millares_input;
    logic ready;
    logic [6:0] segments;
    logic [3:0] digit_sel;

    // Declaracion de las instancias para el testbench, unidad bajo prueba "uut".
    sevenseg_driver uut (

        .clk(clk),
        .rst(rst),
        .unidades_input(unidades_input),
        .decenas_input(decenas_input),
        .centenas_input(centenas_input),
        .millares_input(millares_input),
        .ready(ready),
        .segments(segments),
        .digit_sel(digit_sel)

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
        unidades_input = 4'd0;
        decenas_input = 4'd0;
        centenas_input = 4'd0;
        millares_input = 4'd0;
        ready = 0;

        // Cambio en el valor de rst, tras 10 ones de tiempo.
        #10;
        rst = 0;

        // Cambio en los valores de entrada, cada 40 ones de tiempo.
        // Primer cambio, valor introducido 7609.
        #40;
        unidades_input = 4'd9;
        decenas_input = 4'd0;
        centenas_input = 4'd6;
        millares_input = 4'd7;
        ready = 1;
        #10;
        ready = 0;

        // Segundo cambio, valor introducido 3193.
        #40;
        unidades_input = 4'd3;
        decenas_input = 4'd9;
        centenas_input = 4'd1;
        millares_input = 4'd3;
        ready = 1;
        #10;
        ready = 0;

        // Tercer cambio, valor introducido 0094.
        #40;
        unidades_input = 4'd4;
        decenas_input = 4'd9;
        centenas_input = 4'd0;
        millares_input = 4'd0;
        ready = 1;
        #10;
        ready = 0;
        
        // Finalizacion de la prueba.
        #100;
        $finish;
        
    end

    // Sistema de guardado de los resultados del testbench.
    initial begin

        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0,module_seg_tb);

    end 

endmodule 