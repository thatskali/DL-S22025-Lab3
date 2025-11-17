`timescale 1ns/1ps

module module_detector_tb;

    // Señales del testbench
    logic clk;
    logic rst;
    logic [3:0] row;
    logic [3:0] column;
    logic [3:0] key_pressed;

    // Instanciación del módulo bajo prueba (DUT)
    edge_detector dut (
        .clk(clk),
        .rst(rst),
        .row(row),
        .column(column),
        .key_pressed(key_pressed)
    );

    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de reloj de 10 ones de tiempo
    end

    // Procedimiento de prueba
    initial begin
        // Inicialización
        rst = 1;
        row = 4'b1111;
        column = 4'b1111;
        #20;
        
        // Desactivar reset
        rst = 0;

        // Prueba de cada tecla
        // Prueba de tecla '1'
        row = 4'b1110; column = 4'b1110;
        #1000;
        assert(key_pressed == 4'd1) else $error("Error en tecla 1");
        rst = 1;
        #100
        rst = 0;
        #100

        // Prueba de tecla '2'
        row = 4'b1110; column = 4'b1101;
        #1000;
        assert(key_pressed == 4'd2) else $error("Error en tecla 2");

       

        // Prueba de tecla '3'
        row = 4'b1110; column = 4'b1011;
        #10000;
        assert(key_pressed == 4'd3) else $error("Error en tecla 3");

        // Prueba de tecla 'A'
        row = 4'b1110; column = 4'b0111;
        #10000;
        assert(key_pressed == 4'd10) else $error("Error en tecla A");

        // Prueba de tecla '5'
        row = 4'b1101; column = 4'b1101;
        #1000;
        assert(key_pressed == 4'd5) else $error("Error en tecla 5");

        // Prueba de tecla '6'
        row = 4'b1101; column = 4'b1011;
        #10000;
        assert(key_pressed == 4'd6) else $error("Error en tecla 6");

        // Prueba de tecla 'B'
        row = 4'b1101; column = 4'b0111;
        #10000;
        assert(key_pressed == 4'd11) else $error("Error en tecla B");

        // Prueba de tecla '0'
        row = 4'b0111; column = 4'b1101;
        #10000;
        assert(key_pressed == 4'd0) else $error("Error en tecla 0");

        
        // Prueba de tecla 'D'
        row = 4'b0111; column = 4'b0111;
        #10000;
        assert(key_pressed == 4'd13) else $error("Error en tecla D");

        // Finalización de la simulación
        $display("Todas las pruebas pasaron correctamente");
     $finish;
    end






    initial begin
        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0, module_detector_tb);
    end

endmodule
