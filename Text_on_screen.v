`timescale 1ns / 1ps
module ROM(
    input clk,
    input rst,
                                       // input valid, // это не valid_char, как раньше было, это разрешение по y, показывающая его диапазон
                                       // output busy, // ставим в 1 когда последовательно передаем на выход пакет из chars.v
    input newline,
    input newframe,
    input [9:0] y, // счетчики битов и строк
    input [9:0] x, 
    input [9:0] x0, //начальная точка блока меню(мегафункции константы)
    input [9:0] y0,
    input [31:0] line, // параметризируемо, по 8 бит на каждый символ
    input [7:0] exit_value,
    output out_R, // Здесь сразу выводим бит для каждого цвета
    output out_G,
    output out_B
);
//////////////////////////////////////////////////////////  
wire [7:0] pixels;
reg [5:0] char;
reg out;
wire window = (((x > x0) && x < (x0 + 500)) && (y > y0 && (y < (y0 + 150)))) ? 1 : 0; //Задаем рамки окна меню
reg [2:0] i, j = 0;
reg [1:0] valid;
reg out_bit_R;
reg out_bit_G;
reg out_bit_B;
//////////////////////////////////////////////////////////  
assign out_R = out_bit_R;
assign out_G = out_bit_G;
assign out_B = out_bit_B;
////////////////////////////////////////////////////////// 
chars chars(
    .char(char),
    .rownum(j[2:0]),
    .pixels(pixels)
);
//////////////////////////////////////////////////////////
//Блок отображения общего фона и строчек меню
//При желании можно ручным вводом корректировать, принцип хоть и громозкий, зато эффективный

always @(posedge clk) begin
    if (((y >= y0 + 10) && (y < y0 + 18)) && (x >= (x0 + 20) && (x < (x0 + 50)))) begin //Строка, где будет выводится первый набор символов под value == 1
        valid <= 2'b01;
    end else if ((y >= (y0 + 30)) && (y < (y0 + 38))) begin //Строка, где будет выводится второй набор символов под value == 2
         valid <= 2'b10;
    end else begin
        valid <= 2'b00;
    end
end
////////////////////////////////////////////////////////// 
//входной chars, где помещены символы, задействованные в тексте(exit_value - динамически изменяющийся выводимый параметр)
//Здесь мы формируем необходимое нам слово, расставляя символы в нужном поряке
always @(*) begin
    case (valid)
    2'b01: begin
                case (x[9:3])
                    7'd3: char = 15;
                    7'd7: char = 12;
                    // 7'd5: char = 
                    // 7'd7: char = 
                    // 7'd9: char = 
                    // 7'd12: char =
                    // 7'd13: char =
                    // 7'd14: char =
                    7'd18: char = exit_value[7:4];
                    7'd19: char = exit_value[3:0];
                default: char = 4'd15;
                endcase
            end
     2'b10: begin
                case (x[9:3])
                        x0 + 7'd5: char = 15;
                        x0 + 7'd10: char = 12;
                        // 7'd5: char = 
                        // 7'd7: char = 
                        // 7'd9: char = 
                        // 7'd12: char =
                        // 7'd13: char =
                        // 7'd14: char =
                        x0 + 7'd18: char = exit_value[7:4];
                        x0 + 7'd19: char = exit_value[3:0];
                    default: char = 7'd37;
                endcase
            end

    //             case (x[8:3])
    //                 7'd1: char = 6'd29;
    //                 7'd12: char = 6'd19;


    // //             case (x[9:3])
    // //                 7'd1: char = line[3:0];
    // //                 7'd3: char = line[15:12];
    // //                 7'd5: char = line[11:8];
    // //                 7'd7: char = line[15:12];
    // //                 7'd14: char = line[19:16];
    // //                 7'd18: char = line[7:4];
    // //                 7'd22: char = line[27:24];
    // //                 7'd26: char = line[31:28];
    // //                 7'd29: char = exit_value[7:4];
    // //                 7'd30: char = exit_value[3:0];
    //              default: char = 6'd37;
    //             endcase
    //         end
    endcase
end
//////////////////////////////////////////////////////////
//Полученный массив pixels выводим попиксельно в рамках полученного пакета
always @(posedge clk) begin
    case({window, valid})
        //Задний фон рамки
        3'b100: begin
                    out_bit_B <= 1;
                    out_bit_G <= 0;
                    out_bit_R <= 1; 
                end 
        //Символы внутри рамки 1
        3'b101: begin
                    if (pixels[7 - i]) begin
                        out_bit_R <= 1;
                        out_bit_G <= 1;
                        out_bit_B <= 1;
                    end else begin
                        out_bit_R <= 0;
                        out_bit_G <= 1;
                        out_bit_B <= 0;
                    end
                end
        //Символы внутри рамки 2
        3'b110: begin
                    if (pixels[7 - x[2:0]]) begin
                        out_bit_R <= 1;
                        out_bit_G <= 1;
                        out_bit_B <= 1;
                    end else begin
                        out_bit_R <= 0;
                        out_bit_G <= 0;
                        out_bit_B <= 0;
                    end
                end
        //Остальная часть экрана
        3'b000: begin
                    out_bit_B <= 0;
                    out_bit_G <= 0;
                    out_bit_R <= 0;
                end
    endcase
   
    
    // if (window == 1) begin
    //     out_bit_B <= 1;
    //     out_bit_G <= 0;
    //     out_bit_R <= 0;
    // end else begin
    //     out_bit_B <= 0;
    //     out_bit_G <= 0;
    //     out_bit_R <= 0;
    // end
    // if (valid) begin
    //     if (pixels[7 - x[2:0]]) begin
    //         out_bit_R <= 1;
    //         out_bit_G <= 1;
    //         out_bit_B <= 1;
    //     end else begin
    //         out_bit_R <= 0;
    //         out_bit_G <= 0;
    //         out_bit_B <= 0;
    //     end
    // end
end
//////////////////////////////////////////////////////////
//Этот счетчик нужен для chars.v, так как "y" может привязаться не к началу отрисовки символа
always @(posedge newline) begin
    if (valid) begin
        j <= j + 1;
    end
    if (j == 7) begin
        j <= 0;
    end
end
//////////////////////////////////////////////////////////

always @(posedge clk) begin
    if (valid != 0) begin
        i <= i + 1;
    end
    if (i == 7) begin
        i <= 0;
    end
end
endmodule