
module bcd_to_bin(
    input wire clk,                // Nota: línea de clock
    input wire rst,                // Nota: reinicio asíncrono activo en alto
    input wire listo1,             // Nota: líneas de ready 
    input wire listo2,
    input wire [7:0] num1, num2,  // Nota: Entradas BCD (2 dígitos para cada número)
    output reg [7:0] num1O, num2O, // Nota: Salidas binarias
    output reg ready0,             // Nota: línea de ready0
    output reg error              // Nota: Indica error en caso de que los dígitos BCD no son válidos
);

    // Nota: Extraer dígitos BCD para num1
    wire [3:0] decenas1 = num1[7:4];
    wire [3:0] unidades1 = num1[3:0];
    
    // Nota: Extraer dígitos BCD para num2
    wire [3:0] decenas2 = num2[7:4];
    wire [3:0] unidades2 = num2[3:0];
    
    // Nota: líneas para el cálculo usando shifters
    wire [7:0] decenas1_ext = {4'b0000, decenas1};
    wire [7:0] shift_3_1_num1 = decenas1_ext << 3;  // Nota: decenas1 * 8
    wire [7:0] shift_1_num1 = decenas1_ext << 1;     // Nota: decenas1 * 2
    wire [7:0] decenas1_x10 = shift_3_1_num1 + shift_1_num1;  // Nota: (decenas1 * 8) + (decenas1 * 2)

    wire [7:0] decenas2_ext = {4'b0000, decenas2};
    wire [7:0] shift_3_1_num2 = decenas2_ext << 3;  // Nota: decenas2 * 8
    wire [7:0] shift_1_num2 = decenas2_ext << 1;     // Nota: decenas2 * 2
    wire [7:0] decenas2_x10 = shift_3_1_num2 + shift_1_num2;  // Nota: (decenas2 * 8) + (decenas2 * 2)

    reg [1:0] state; // Nota: 00: esperando, 01: leyendo num1, 10: leyendo num2, 11: terminado

    // Nota: Estados
    localparam WAIT = 2'b00, NUM1 = 2'b01, NUM2 = 2'b10, DONE = 2'b11;
    reg [7:0] prev_num1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Nota: reinicio asíncrono
            num1O <= 8'b0;
            num2O <= 8'b0;
            ready0 <= 1'b0;
            error <= 1'b0;
            state <= WAIT;
            prev_num1<=8'b0;
        end else begin
            case (state)
                WAIT: begin
                    ready0=0;
                    // Nota: en caso de que num1 es distinto de 0, empieza la decodificación de num1
                    if (num1 != prev_num1) begin
                        state <= NUM1;  // Nota: Cambiar al fase de lectura de num1
                    end
                end
                
                NUM1: begin
                    // Nota: Verificar en caso de que los dígitos BCD de num1 son válidos (0-9)
                    if (decenas1 <= 4'd9 && unidades1 <= 4'd9) begin

                        if(decenas1==4'd0) begin
                            num1O <= unidades1;
                        end else begin
                        // Nota: Realizar la conversión para num1
                        num1O <= decenas1_x10 + {4'b0000, unidades1};
                        
                        // Nota: Mantenerse en NUM1 hasta que se active listo2 para comenzar con num2
                        if (listo1) begin
                            state <= NUM2;  // Nota: Cambiar al fase de lectura de num2
                            prev_num1<=num1;
                        end else begin
                            state <= NUM1;  // Nota: Continuar en NUM1 hasta que listo1 se active
                        end
                        end
                    end else begin
                        // Nota: en caso de que los dígitos BCD no son válidos
                        num1O <= 8'b0;
                        num2O <= 8'b0;
                        ready0 <= 1'b0;
                        error <= 1'b1;
                        state <= DONE;  // Nota: Pasar al fase de DONE por error
                    end
                end

                NUM2: begin
                    // Nota: Verificar en caso de que los dígitos BCD de num1 son válidos (0-9)
                    if (decenas2 <= 4'd9 && unidades2 <= 4'd9) begin
                        if(decenas2==4'd0) begin
                            num2O <= unidades2;
                        end else begin
                        // Nota: Realizar la conversión para num1
                        num2O <= decenas2_x10 + {4'b0000, unidades2};
                        
                        // Nota: Mantenerse en NUM2 hasta que se active listo2 para comenzar con terminar
                        if (listo2) begin
                            state <= DONE;  // Nota: Cambiar al fase de lectura de DONE
                        end else begin
                            state <= NUM2;  // Nota: Continuar en NUM2 hasta que listo2 se active
                        end
                        end
                    end else begin
                        // Nota: en caso de que los dígitos BCD no son válidos
                        num1O <= 8'b0;
                        num2O <= 8'b0;
                        ready0 <= 1'b0;
                        error <= 1'b1;
                        state <= DONE;  // Nota: Pasar al fase de DONE por error
                    end
                end

                DONE: begin
                    // Nota: al momento en que los dos números se hayan decodificado, activar ready0
                    ready0 <= 1'b1;
                    state <= WAIT;  // Nota: Volver a esperar por un nuevo número
                end
            endcase
        end
    end

endmodule





