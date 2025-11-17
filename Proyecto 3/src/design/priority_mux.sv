// Nota: Este modulo permite establecer cuales son los valores que se mostrarian en los 7 segmentos.

module priority_mux (

     // Nota: clock para que al momento en que los valores del en binario se actualicen se ven reflejados de forma automatica en los 7 segmentos.
    input logic clk,
    // Nota: El boton de reinicio que permite restablecer los valores de los 7 segmentos a 0.
    input logic rst,
    // Nota: Valores de entrada del modulo keypad.
    input logic [7:0] num_1,
    // Nota: input logic sig_1,
    input logic [7:0] num_2,
    // Nota: input logic sig_2,
    input logic ready_1,
    input logic ready_2,
    input logic ready,
    // Nota: Valores de entrada del modulo multiplicador.
    input logic [15:0] num_mul,
    // Nota: input logic sig_mul,
    // Nota: Valores de salida del modulo a modulo BCD y a el 7 segmentos de signo.
    output logic [15:0] numero_output
    // Nota: output logic signo_output

    );

    // Nota: Variable interna para establecer preferencia
    logic [1:0] prioridad;

    // Nota: Estados posibles de la maquina.
    localparam prio_num_1 = 2'd0;
    localparam prio_num_2 = 2'd1;
    localparam prio_num_mul = 2'd2;

    // Nota: Asignacion de la preferencia en base a las líneas de gestión del modulo keypad.
    always_ff @(posedge clk or posedge rst) begin

        if (rst) begin

            prioridad <= prio_num_1;

        end else begin
            
            if (ready) begin

                prioridad <= prio_num_mul;

            end else begin

                if (ready_1) begin

                    prioridad <= prio_num_2;

                end else begin

                        prioridad <= prio_num_1;

                end

            end

        end
        
    end

    // Nota: Asignacion a las salidas en base a la preferencia
    always_comb begin

        case (prioridad)

            prio_num_1:begin
                numero_output = num_1;
                // Nota: signo_output = sig_1;
            end

            prio_num_2:begin
                numero_output = num_2;
                // Nota: signo_output = sig_2;
            end

            prio_num_mul:begin
                numero_output = num_mul;
                // Nota: signo_output = sig_mul;
            end

            default: begin
                numero_output = 16'd0;
                // Nota: signo_output = 1'b0;
            end

        endcase

    end

endmodule