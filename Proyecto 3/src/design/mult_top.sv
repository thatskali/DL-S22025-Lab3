// Nota: bloque Principal modificado
module booth_multiplier(
    input clk,                          
    input rst,                       
    input valid,                         
    input signed [7:0] multiplicando,     
    input signed [7:0] multiplicador,     
    output signed [15:0] result,       
    output done                         
);
    // Nota: Declaración de líneas internas
    wire [1:0] temp, sig_temp;
    wire [2:0] contador, sig_contador;
    wire sig_done, sig_estado, estado_actual;
    wire signed [15:0] sig_resultado;
    wire clear_output;

    // Nota: Instanciación de la Unidad de gestión
    control_unit control(
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .contador(contador),
        .estado_actual(estado_actual),
        .sig_estado(sig_estado),
        .sig_contador(sig_contador),
        .sig_done(sig_done),
        .clear_output(clear_output)
    );

    // Nota: Instanciación de la Ruta de Datos
    booth_alu ruta_datos(
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .multiplicando(multiplicando),
        .multiplicador(multiplicador),
        .temp(temp),
        .contador(contador),
        .estado_actual(estado_actual),
        .result(result),
        .sig_temp(sig_temp),
        .sig_resultado(sig_resultado)
    );

    // Nota: Instanciación del Banco de Registros
    shift_reg registros(
        .clk(clk),
        .rst(rst),
        .sig_resultado(sig_resultado),
        .sig_done(sig_done),
        .sig_estado(sig_estado),
        .sig_temp(sig_temp),
        .sig_contador(sig_contador),
        .clear_output(clear_output),
        .valid(valid),              // Nota: Nueva conexión
        .result(result),
        .done(done),
        .estado_actual(estado_actual),
        .temp(temp),
        .contador(contador)
    );

endmodule