`timescale 1ns / 1ps
module value_ROM(
    input [9:0] some_value, 
    input en,
    input newframe,
    output [7:0] exit_value
);
////////////////////////////////////////////////////////// 
reg [3:0] units;
reg [3:0] dozens;
reg [3:0] hundreds;
reg [11:0] value;
//////////////////////////////////////////////////////////
assign exit_value = value;
//////////////////////////////////////////////////////////
always @(posedge newframe) begin
    units <= some_value % 10;
    dozens <= (some_value / 10) % 10;
    hundreds <= some_value / 100;
    //первый разряд входного числа
    case(units)
        4'd0: value[3:0] = 4'd0;
        4'd1: value[3:0] = 4'd1;
        4'd2: value[3:0] = 4'd2;
        4'd3: value[3:0] = 4'd3;
        4'd4: value[3:0] = 4'd4;
        4'd5: value[3:0] = 4'd5;
        4'd6: value[3:0] = 4'd6;
        4'd7: value[3:0] = 4'd7;
        4'd8: value[3:0] = 4'd8;
        4'd9: value[3:0] = 4'd9;

    endcase
    //второй разряд входного числа
    case(dozens)
        4'd0: value[7:4] = 4'd0;
        4'd1: value[7:4] = 4'd1;
        4'd2: value[7:4] = 4'd2;
        4'd3: value[7:4] = 4'd3;
        4'd4: value[7:4] = 4'd4;
        4'd5: value[7:4] = 4'd5;
        4'd6: value[7:4] = 4'd6;
        4'd7: value[7:4] = 4'd7;
        4'd7: value[7:4] = 4'd7;
        4'd8: value[7:4] = 4'd8;
        4'd9: value[7:4] = 4'd9;
    endcase
    //третий разряд входного числа
    case(hundreds)
        4'd0: value[11:8] = 4'd0;
        4'd1: value[11:8] = 4'd1;
        4'd2: value[11:8] = 4'd2;
        4'd3: value[11:8] = 4'd3;
        4'd4: value[11:8] = 4'd4;
        4'd5: value[11:8] = 4'd5;
        4'd6: value[11:8] = 4'd6;
        4'd7: value[11:8] = 4'd7;
        4'd7: value[11:8] = 4'd7;
        4'd8: value[11:8] = 4'd8;
        4'd9: value[11:8] = 4'd9;
    endcase
end
endmodule
//На вход подаем значение в двоичном коде. 
//В процессе этого модуля переводим его в ВОСЬМЕРИЧНОЕ представление, смотрим каждый разряд и перебираем все цифры,
//присваивая нужный адрес в chars.v, его всовываем в выделенное место на экране (сделать в ROM отдельно)
//Также для теста сделаю счетчик до 15, значение которого и буду передавать на ROM --> чтобы соблюсти правильность сигналов, реализую счетчик в топе.