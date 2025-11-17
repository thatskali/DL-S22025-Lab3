// ===============================================================
// Módulo: module_antirebote
// Descripción:
//   Implementa un filtro antirrebote para el teclado matricial.
//   En simulación, pasa directamente la señal sin retardo
//   para que las teclas sean detectadas de inmediato.
// ===============================================================

`timescale 1ns/1ps

`ifdef SIMULATION
// ===============================================================
// Versión RÁPIDA (sin retardos, para simulación)
// ===============================================================
module module_antirebote (
    input  logic clk,
    input  logic rst,
    input  logic tecla,   // señal bruta de tecla
    output logic salida   // señal filtrada
);
    // En simulación, pasa directo con reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            salida <= 1'b1;   // reposo = sin pulsar
        else
            salida <= tecla;  // pasa directo
    end
endmodule

`else
// ===============================================================
// Versión NORMAL (hardware real con retardo de rebote)
// ===============================================================
module module_antirebote (
    input  logic clk,
    input  logic rst,
    input  logic tecla,
    output logic salida
);
    // Ajusta el ancho del contador según tu reloj (ej: 27 MHz)
    localparam integer MAX_COUNT = 16'd50000;

    logic [15:0] counter;
    logic tecla_sync, tecla_prev;

    // Sincronización y detección de cambios
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tecla_sync <= 1'b1;
            tecla_prev <= 1'b1;
            counter    <= 16'd0;
            salida     <= 1'b1;
        end else begin
            tecla_sync <= tecla;
            if (tecla_sync != tecla_prev) begin
                tecla_prev <= tecla_sync;
                counter <= 16'd0;
            end else if (counter < MAX_COUNT) begin
                counter <= counter + 16'd1;
            end else begin
                salida <= tecla_sync;  // tecla estable
            end
        end
    end
endmodule
`endif
