module shift_reg(
    input clk,
    input rst,
    input signed [15:0] sig_resultado,
    input sig_done,
    input sig_estado,
    input [1:0] sig_temp,
    input [2:0] sig_contador,
    input clear_output,            // Nota: entrada para limpiar salidas
    input valid,                   // Nota: Nueva entrada para detectar valid
    output reg signed [15:0] result,
    output reg done,
    output reg estado_actual,
    output reg [1:0] temp,
    output reg [2:0] contador
);
    // Nota: Registros adicionales para mantener valores
    reg signed [15:0] resultado_retenido;
    reg done_retenido;

    // Nota: Actualización síncrona de registros
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            result <= 16'd0;
            done <= 1'b0;
            estado_actual <= 1'b0;
            temp <= 2'd0;
            contador <= 3'd0;
            resultado_retenido <= 16'd0;
            done_retenido <= 1'b0;
        end
        else begin
            // Nota: Manejar líneas de gestión
            estado_actual <= sig_estado;
            temp <= sig_temp;
            contador <= sig_contador;

            // Nota: Manejar result y done
            if (valid) begin
                // Nota: reinicio inmediato al momento en que llega valid
                result <= 16'd0;
                done <= 1'b0;
                resultado_retenido <= 16'd0;
                done_retenido <= 1'b0;
            end
            else if (sig_done) begin
                // Nota: Nueva multiplicación completada
                result <= sig_resultado;
                done <= 1'b1;
                resultado_retenido <= sig_resultado;
                done_retenido <= 1'b1;
            end
            else if (!estado_actual) begin
                // Nota: En fase ESPERA, mantener valores retenidos
                result <= resultado_retenido;
                done <= done_retenido;
            end
            else begin
                // Nota: Durante la multiplicación, actualizar normalmente
                result <= sig_resultado;
                done <= 1'b0;
            end
        end
    end
endmodule
