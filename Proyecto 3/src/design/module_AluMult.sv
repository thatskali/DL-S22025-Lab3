// Nota: bloque de Ruta de Datos
module booth_alu(
    input clk,
    input rst,
    input valid,
    input signed [7:0] multiplicando, multiplicador,
    input [1:0] temp,                               
    input [2:0] contador,                           
    input estado_actual,                            // Nota: Añadido como entrada
    input signed [15:0] result,                  // Nota: Añadido como entrada
    output reg [1:0] sig_temp,                      
    output reg signed [15:0] sig_resultado          
);
    reg signed [15:0] resultado_temp;               
    
    // Nota: Estados de la máquina de estados (duplicados para acceso local)
    localparam ESPERA = 1'b0;       
    localparam MULTIPLICAR = 1'b1;   

    // Nota: Lógica combinacional para operaciones
    always @(*) begin
        if(valid && estado_actual == ESPERA) begin
            sig_temp = {multiplicando[0], 1'b0};
            sig_resultado = {8'd0, multiplicando};
        end
        else if(estado_actual == MULTIPLICAR) begin
            case(temp)
                2'b10:   resultado_temp = {result[15:8] - multiplicador, result[7:0]};
                2'b01:   resultado_temp = {result[15:8] + multiplicador, result[7:0]};
                default: resultado_temp = result;  // Nota: Cambiado para usar result directamente
            endcase
            sig_temp = {multiplicando[contador + 1], multiplicando[contador]};
            sig_resultado = resultado_temp >>> 1;
        end
        else begin
            sig_temp = 2'd0;
            sig_resultado = 16'd0;
        end
    end
endmodule

