module debounce (
    input logic clk,              
    input logic rst,              
    input logic [3:0] row,        
    input logic [3:0] column,     
    output logic [3:0] key_out    
);

    
    parameter DEBOUNCE_COUNT = 100000;  

    
    logic [15:0] keys_stable;     
    logic [15:0] keys_sampled;     
    logic [31:0] debounce_counter; 

    
    logic [3:0] row_reg;
    logic [3:0] col_reg;

    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            row_reg <= 4'b1111;          
            col_reg <= 4'b1111;          
            debounce_counter <= 0;
            keys_stable <= 16'b0;
            keys_sampled <= 16'b0;
        end else begin
           
            col_reg <= {col_reg[2:0], 1'b1};  

            
            row_reg <= row;  

           
            keys_sampled <= {keys_sampled[14:0], row_reg}; 

           
            if (debounce_counter < DEBOUNCE_COUNT) begin
                debounce_counter <= debounce_counter + 1;
            end else begin
                if (keys_sampled == keys_stable) begin
                    keys_stable <= keys_sampled; 
                end
                debounce_counter <= 0; 
            end
        end
    end

    
    always_comb begin
       
        key_out = ~(keys_sampled[3:0] ^ keys_stable[3:0]); 
    end

endmodule


