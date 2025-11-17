`timescale 1ns/1ps

module module_teclado_tb;

    // Señales de entrada y salida
    logic clk;
    logic rst;
    logic [3:0] row;
    logic [3:0] column;
    logic key_out;
    logic [7:0] first_num;
    logic [7:0] second_num;
    logic ready_1;
    logic ready_2;
    logic ready;

   
    module_teclado1 uut (
        .clk(clk),
        .rst(rst),
        .column(column),
        .row(row),
        .key_out(key_out),
        .first_num(first_num),
        .second_num(second_num),
        .ready_1(ready_1),
        .ready_2(ready_2),
        .ready(ready)
    );

    // Generación del reloj
    always #5 clk = ~clk; // Periodo de reloj de 10 ones de tiempo

    // Inicialización de señales
    initial begin
        // Inicializar las señales
        clk = 0;
        rst = 1;
        row = 4'b1111;
        column = 4'b1111;
        key_out = 1;
        
        // Desactivar reset y empezar la simulación
        #2000 rst = 0;

        // Ingresar la primera secuencia de teclas
        ingresar_tecla(4'b1110, 4'b1110);
        #1000 // Presionar "1"
        ingresar_tecla(4'b1110, 4'b1101); 
         #1000// Presionar "2"
        ingresar_tecla(4'b1110, 4'b0111); // Presionar "A" (indica fin del primer número)
 #1000
        // Verificar si el primer número está ready
        #10 if (ready_1) $display("Primer número almacenado: %0d", first_num);
         #1000
        // Ingresar la segunda secuencia de teclas
        ingresar_tecla(4'b1110, 4'b1011); // Presionar "3"
         #1000
        ingresar_tecla(4'b1101, 4'b1110); // Presionar "4"
         #1000
        ingresar_tecla(4'b1101, 4'b0111); // Presionar "A" (indica fin del segundo número)
 #1000
        // Verificar si el segundo número está ready
        #1099 if (ready_2) $display("Segundo número almacenado: %0d", second_num);
 #1000
        // Verificar si la secuencia completa está lista
        #1000 if (ready) $display("Secuencia completa lista");

        #1000$finish;
    end

    // Tarea para simular la pulsación de una tecla
    task ingresar_tecla(input logic [3:0] fila, input logic [3:0] columna);
        begin
            row = fila;
            column = columna;
            key_out = 0; // Señal de tecla presionada
            #1000;
            key_out = 1; // Liberar tecla
            #1000;
        end
    endtask



    initial begin
        $dumpfile("module_top_general_tb.vcd");
        $dumpvars(0, module_teclado_tb);
    end

endmodule
