// Nota: Subsistema 4 de la tarea 3, correccion y mejora del modulo 3 de la tarea 1 y 2.

module sevenseg_driver (

    // Nota: clock para que al momento en que los valores del en binario se actualicen se ven reflejados de forma automatica en los 7 segmentos.
    input logic clk,
    // Nota: El boton de reinicio que permite restablecer los valores de los 7 segmentos a 0.
    input logic rst,
    // Nota: Variables de entrada del modulo BCD.
    input logic [3:0] unidades_input,
    input logic [3:0] decenas_input,
    input logic [3:0] centenas_input,
    input logic [3:0] millares_input,
    input logic ready,
    // Nota: Variable de salida para los 7 segmentos.
    output logic [6:0] segments,
    // Nota: Variable de salida para activar los transistores de ones, tens, hundreds y thousands; codificacion one_hot.
    output logic [3:0] digit_sel

    );
    
    // Nota: Variables internas para el proceso de entrada.
    logic [3:0] ones;
    logic [3:0] tens;
    logic [3:0] hundreds;
    logic [3:0] thousands;

    // Nota: Restablecer los valores de las variables internas a 0.
    always_ff @(posedge clk or posedge rst) begin

        if (rst) begin

            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;

        end else begin
            if (ready) begin

                ones = unidades_input;
                tens = decenas_input;
                hundreds = centenas_input;
                thousands = millares_input;

            end

        end

    end

    // Nota: Numero que se estaria proyectando en los 7 segmentos, el cual es asignado en la maquina de estados.
    logic [3:0] numero;

    // Nota: Asignacion por logica combinacional de los 7 segmentos.
    always_comb begin

        case (numero)
            
            4'd0: segments = 7'b0000001;
            4'd1: segments = 7'b1001111;
            4'd2: segments = 7'b0010010;
            4'd3: segments = 7'b0000110;
            4'd4: segments = 7'b1001100;
            4'd5: segments = 7'b0100100;
            4'd6: segments = 7'b0100000;
            4'd7: segments = 7'b0001111;
            4'd8: segments = 7'b0000000;
            4'd9: segments = 7'b0000100;
            default: segments = 7'b0110110;

        endcase

    end

    // Nota: Contador que selecciona cual de los estados se esta presentando.
    logic [1:0] selec = 2'd0;
    
    // Nota: Asignacion de cual fase se esta presentando, este cambia en cada flanco de clock.
    always_ff @(posedge clk) begin

        if (rst) begin

            selec <= 2'd0;

        end else begin

            selec <= (selec + 1) % 4;

        end

    end

    // Nota: Estados posibles de la maquina.
    localparam UNI = 4'd0;
    localparam DEC = 4'd1;
    localparam CEN = 4'd2;
    localparam MIL = 4'd3;

    // Nota: Maquina de estados
    // Nota: Comendar los estados que no se esten revisando para realizar las pruebas.
    always_comb begin 

        case (selec)

            UNI:begin
                numero = ones;
                digit_sel = 4'b0001;
            end

            DEC:begin
                numero = tens;
                digit_sel = 4'b0010;
            end

            CEN:begin
                numero = hundreds;
                digit_sel = 4'b0100;
            end

            MIL:begin
                numero = thousands;
                digit_sel = 4'b1000;
            end

            default: begin
                numero = 4'd0;
                digit_sel = 4'b0000;
            end

        endcase
        
    end

endmodule