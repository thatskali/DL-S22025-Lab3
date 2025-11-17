module edge_detector (
    input logic clk,
    input logic rst,
    input logic [3:0] row,           
    input logic [3:0] column,       
    output reg [3:0] key_pressed      
);

    logic [3:0] key_valid;          
    debounce anti_rebote_inst (
        .clk(clk),                 
        .rst(rst),
        .row(row),              
        .column(column),        
        .key_out(key_valid)            
    );

    // Nota: gestión del barrido de filas y detección de teclas
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            key_pressed <= 4'b0000;
        end else begin
            
            if (key_valid == 4'b0000) begin 
                case (row)
                    4'b1110: begin 
                        case (column)
                            4'b1110: key_pressed <= 4'd1;  
                            4'b1101: key_pressed <= 4'd2;  
                            4'b1011: key_pressed <= 4'd3;  
                            4'b0111: key_pressed <= 4'd10; 
                            default: key_pressed <= 4'b0000; 
                        endcase
                    end
                    4'b1101: begin 
                        case (column)
                            4'b1110: key_pressed <= 4'd4;  
                            4'b1101: key_pressed <= 4'd5;  
                            4'b1011: key_pressed <= 4'd6;  
                            4'b0111: key_pressed <= 4'd11; 
                            default: key_pressed <= 4'b0000; 
                        endcase
                    end
                    4'b1011: begin 
                        case (column)
                            4'b1110: key_pressed <= 4'd7;  
                            4'b1101: key_pressed <= 4'd8;  
                            4'b1011: key_pressed <= 4'd9;  
                            4'b0111: key_pressed <= 4'd12; 
                            default: key_pressed <= 4'b0000; 
                        endcase
                    end
                    4'b0111: begin 
                        case (column)
                            4'b1110: key_pressed <= 4'd14; 
                            4'b1101: key_pressed <= 4'd0;  
                            4'b1011: key_pressed <= 4'd15; 
                            4'b0111: key_pressed <= 4'd13; 
                            default: key_pressed <= 4'b0000; 
                        endcase
                    end
                    default: key_pressed <= 4'b0000; 
                endcase
            end else begin
                key_pressed <= 4'b0000; 
            end
        end
    end

endmodule
