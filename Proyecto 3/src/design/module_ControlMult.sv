module control_unit(
    input clk,                    
    input rst,                 
    input valid,                   
    input [2:0] contador,           
    input estado_actual,            
    output reg sig_estado,          
    output reg [2:0] sig_contador,  
    output reg sig_done,
    output reg clear_output        // Nota: línea para limpiar salidas
);
    // Nota: Estados de la máquina de estados
    localparam ESPERA = 1'b0;       
    localparam MULTIPLICAR = 1'b1;   

    // Nota: Lógica combinacional para el gestión
    always @(*) begin
        // Nota: Inicializar líneas
        sig_contador = contador;
        sig_done = 1'b0;
        sig_estado = estado_actual;
        clear_output = 1'b0;

        case(estado_actual)
            ESPERA: begin
                sig_contador = 3'b0;          
                clear_output = valid;  // Nota: Activar clear al momento en que hay valid
                sig_estado = valid ? MULTIPLICAR : ESPERA;
            end
            MULTIPLICAR: begin
                sig_contador = contador + 1'b1;
                sig_done = (contador == 3'd7);
                sig_estado = (contador == 3'd7) ? ESPERA : MULTIPLICAR;
            end
            default: begin
                sig_contador = 3'b0;
                sig_estado = ESPERA;
            end
        endcase
    end
endmodule