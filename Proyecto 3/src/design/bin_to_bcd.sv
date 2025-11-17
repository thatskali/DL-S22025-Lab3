// Nota: Modulo BCD, subsistema 3 de la tarea 3.

module bin_to_bcd (

    // Nota: clock del sistema.
    input logic clk,
    // Nota: El boton de reinicio que permite restablecer los valores a 0.
    input logic rst,
    // Nota: Valor de entrada en en binario.
    input [15:0] numero_input,
    // Nota: Variables de salida del modulo.
    output logic [3:0] unidades_output,
    output logic [3:0] decenas_output,
    output logic [3:0] centenas_output,
    output logic [3:0] millares_output,
    // Nota: Variable de salida que permite identificar al momento en que el ciclo del modulo se completa.
    output logic ready

    );

    // Nota: Variable que se modifica para poder obtener cada uno de los valores de salida sin afectar el valor de entrada directamente.
    logic [15:0] temp;
    // Nota: Variable de fase de la maquina.
    logic [3:0] estado;

    // Nota: Estados posibles de la maquina.
    localparam IDLE = 4'd0;
    localparam MILLARES = 4'd1;
    localparam CENTENAS = 4'd2;
    localparam DECENAS = 4'd3;
    localparam UNIDADES = 4'd4;

    // Nota: Proceso de division del numero de entrada en sus componentes, por medio de una maquina de estados.
    always @(posedge clk or posedge rst) begin

        if (rst) begin

            // Nota: Restablecer los valores de las variables y al primer fase de la maquina.
            unidades_output <= 4'b0000;
            decenas_output <= 4'b0000;
            centenas_output <= 4'b0000;
            millares_output <= 4'b0000;
            temp <= 16'b0;
            estado <= IDLE;
            ready <= 1'b0;

        end else begin

            case (estado)

                // Nota: fase inicial en el cual se en cuentra a la espera de recibir el dato de entrada y limpiar la variables de salida.
                IDLE: begin
                    temp <= numero_input;
                    millares_output <= 4'b0000;
                    centenas_output <= 4'b0000;
                    decenas_output <= 4'b0000;
                    unidades_output <= 4'b0000;
                    estado <= MILLARES;
                    ready <= 1'b0;
                end

                // Nota: Los siguientes estados se encargan de obtener los datos de salida.
                MILLARES: begin
                    if (temp >= 1000) begin
                        millares_output <= millares_output + 1;
                        temp <= temp - 1000;
                    end else begin
                        estado <= CENTENAS;
                    end
                end

                CENTENAS: begin
                    if (temp >= 100) begin
                        centenas_output <= centenas_output + 1;
                        temp <= temp - 100;
                    end else begin
                        estado <= DECENAS;
                    end
                end

                DECENAS: begin
                    if (temp >= 10) begin
                        decenas_output <= decenas_output + 1;
                        temp <= temp - 10;
                    end else begin
                        estado <= UNIDADES;
                    end
                end

                UNIDADES: begin
                    unidades_output <= temp;
                    estado <= IDLE;
                    ready <= 1'b1;
                end

            endcase

        end

    end

endmodule 