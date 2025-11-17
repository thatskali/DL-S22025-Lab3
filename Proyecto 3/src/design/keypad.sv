module keypad (
    input logic clk,
    input logic rst,                    
    input logic [3:0] column,                
    input logic [3:0] row,
    input logic [3:0] key_out,              
    output logic [7:0] first_num,          
    output logic [7:0] second_num,
    output logic ready_1,
    output logic ready_2,
    output logic ready
);

    typedef enum logic [1:0] {
        IDLE,        
        READ_FIRST,  
        READ_SECOND  
    } statetype;

    statetype state, nextstate;  
    logic [3:0] key_pressed;                                  
    logic prev_key_pressed;           // Nota: Para detectar flanco negativo de "A"
    logic tecla_ya_procesada;         // Nota: registro para asegurar que solo procesemos la tecla una vez en el segundo número
    logic tecla_ya_procesada_1;       // Nota: registro para asegurar que solo procesemos la tecla una vez en el primer número

    debounce anti_rebote_inst(
        .clk(clk),
        .rst(rst),
        .key_out(key_out),
        .row(row),
        .column(column)
    );
    
    // Nota: Instancia del bloque de detección de teclas
    edge_detector teclado_detector_inst (
        .clk(clk),          
        .rst(rst),              
        .row(row),             
        .column(column),           
        .key_pressed(key_pressed) 
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            first_num <= 8'b0;
            second_num <= 8'b0;
            ready <= 0;
            ready_1 <= 0;
            ready_2 <= 0;
            prev_key_pressed <= 4'b0;
            tecla_ya_procesada <= 1'b0;  // Nota: Inicializamos la variable para el segundo número
            tecla_ya_procesada_1 <= 1'b0; // Nota: Inicializamos la variable para el primer número
        end else begin
            state <= nextstate;
            
            // Nota: Detectamos el flanco negativo de la tecla "A" (4'd10) para pasar a READ_SECOND
            if (key_pressed == 4'd10 && prev_key_pressed != 4'd10) begin
                prev_key_pressed <= key_pressed;
                nextstate = READ_SECOND;
            end
            
            // Nota: en caso de que hay una tecla presionada, la almacenamos en last_key
            if (key_pressed != 4'b0000) begin
                case (state)
                    READ_FIRST: begin
                        // Nota: Controlamos en caso de que la tecla ya fue procesada en el primer número
                        if (!tecla_ya_procesada_1 && key_pressed != 4'd10) begin
                            first_num <= {first_num[7:0], key_pressed};
                            tecla_ya_procesada_1 <= 1; // Nota: Marcamos la tecla como procesada
                        end else if (key_pressed == 4'd10) begin
                            ready_1 <= 1; // Nota: en caso de que presionamos "A", ready el primer número
                        end
                    end
                    READ_SECOND: begin
                        // Nota: Guardamos solo en caso de que la tecla no ha sido procesada aún en este fase
                        if (!tecla_ya_procesada && key_pressed != 4'd10 && key_pressed != 4'd11) begin
                            second_num <= {second_num[7:0], key_pressed}; // Nota: Guardar solo una vez
                            tecla_ya_procesada <= 1; // Nota: Marcamos la tecla como procesada
                        end else if (key_pressed == 4'd11) begin // Nota: en caso de que se presiona "B", ready el segundo número
                            ready_2 <= 1;
                        end
                    end
                endcase
            end else begin
                // Nota: en caso de que no hay tecla presionada, reseteamos `tecla_ya_procesada`
                tecla_ya_procesada <= 0;
                tecla_ya_procesada_1 <= 0; // Nota: Reseteamos también la línea para el primer número
            end
        end
    end
            
    always_comb begin
        nextstate = state;
        ready = 0;
        
        case (state)
            IDLE: begin
                if (key_pressed != 4'b0000 & key_pressed !=4'd11) begin
                    nextstate = READ_FIRST;
                end
            end
            READ_FIRST: begin
                if (key_pressed == 4'd10) begin // Nota: en caso de que se presiona "A", preparar para READ_SECOND
                    nextstate = READ_SECOND;
                end
            end
            READ_SECOND: begin
                if (key_pressed == 4'd11) begin // Nota: en caso de que se presiona "B", volver a IDLE
                    nextstate = IDLE;
                    ready = 1;
                end
            end
            default: nextstate = IDLE;
        endcase
    end

endmodule






