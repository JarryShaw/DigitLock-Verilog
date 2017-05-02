`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:07 04/15/2017 
// Design Name: 
// Module Name:    DigitLocker 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module locker_sub(
    input wire [4:0] num,
    output reg [6:0] a_to_g
    );

    always@(*)
        case(num)
            0:  a_to_g = 7'b0000001;    //0  - '0'
            1:  a_to_g = 7'b1001111;    //1  - '1'
            2:  a_to_g = 7'b0010010;    //2  - '2'
            3:  a_to_g = 7'b0000110;    //3  - '3'
            4:  a_to_g = 7'b1001100;    //4  - '4'
            5:  a_to_g = 7'b0100100;    //5  - '5'
            6:  a_to_g = 7'b0100000;    //6  - '6'
            7:  a_to_g = 7'b0001111;    //7  - '7'
            8:  a_to_g = 7'b0000000;    //8  - '8'
            9:  a_to_g = 7'b0000100;    //9  - '9'
            10: a_to_g = 7'b0001000;    //10 - 'A'
            11: a_to_g = 7'b1100000;    //11 - 'B'
            12: a_to_g = 7'b0110001;    //12 - 'C'
            13: a_to_g = 7'b1000010;    //13 - 'D'
            14: a_to_g = 7'b0110000;    //14 - 'E'
            15: a_to_g = 7'b0111000;    //15 - 'F'
            20: a_to_g = 7'b1111010;    //20 - 'r'
            21: a_to_g = 7'b0110000;    //21 - 'E'
            22: a_to_g = 7'b0100100;    //22 - 'S'
            23: a_to_g = 7'b1110000;    //23 - 't'
            24: a_to_g = 7'b0100001;    //24 - 'G'
            25: a_to_g = 7'b1100010;    //25 - 'o'
            26: a_to_g = 7'b1000010;    //26 - 'd'
            27: a_to_g = 7'b0110001;    //27 - 'C'
            28: a_to_g = 7'b1110001;    //28 - 'L'
            29: a_to_g = 7'b1111111;    //29 - ''(null)
            default:
                a_to_g = 7'b1111110;    //df - '-'
        endcase
endmodule

module locker_top(
    input clk,
    input clr,
    input setting,
    input submit,
    input reset,
    input  wire [7:0] switch,
    output wire [3:0] an,
    output wire [6:0] a_to_g,
    output reg  [7:0] LED
    ); 

    reg [32:0]clk_cnt;
    reg [4:0] num;
    reg [7:0] password;
    reg [4:0] display_0;
    reg [4:0] display_1;
    reg [4:0] display_2;
    reg [4:0] display_3;
    reg [3:0] sw0;
    reg [3:0] sw1;
    reg [1:0] judge;
    reg [2:0] flag;
    wire control_0;
    wire control_1;

    always@(posedge clk) 
    begin
        assign LED = switch;                //用LED显示输入的密码
        assign sw0 = switch[3:0];           //低8位输入
        assign sw1 = switch[7:4];           //高8位输入

        if(reset)                           //重置，数码管显示输入的密码（十六进制）
        begin
            flag = 3'b000;
            clk_cnt = 0;
            case(sw0)
                4'b0000: display_0 = 0;
                4'b0001: display_0 = 1;
                4'b0010: display_0 = 2;
                4'b0011: display_0 = 3;
                4'b0100: display_0 = 4;
                4'b0101: display_0 = 5;
                4'b0110: display_0 = 6;
                4'b0111: display_0 = 7;
                4'b1000: display_0 = 8;
                4'b1001: display_0 = 9;
                4'b1010: display_0 = 10;
                4'b1011: display_0 = 11;
                4'b1100: display_0 = 12;
                4'b1101: display_0 = 13;
                4'b1110: display_0 = 14;
                4'b1111: display_0 = 15;
            endcase

            case(sw1)
                4'b0000: display_1 = 0;
                4'b0001: display_1 = 1;
                4'b0010: display_1 = 2;
                4'b0011: display_1 = 3;
                4'b0100: display_1 = 4;
                4'b0101: display_1 = 5;
                4'b0110: display_1 = 6;
                4'b0111: display_1 = 7;
                4'b1000: display_1 = 8;
                4'b1001: display_1 = 9;
                4'b1010: display_1 = 10;
                4'b1011: display_1 = 11;
                4'b1100: display_1 = 12;
                4'b1101: display_1 = 13;
                4'b1110: display_1 = 14;
                4'b1111: display_1 = 15;
            endcase

        display_2 = 29;
        display_3 = 29;
        end

        else if(setting)                    //设置密码，显示'SEt'
        begin
            flag = 3'b010;
            clk_cnt = 0;
            password = switch;
            display_0 = 23;
            display_1 = 21;
            display_2 = 22;
            display_3 = 29;
        end

        else if(submit)                     //输入密码并验证
        begin
            clk_cnt = clk_cnt + 1;
            if(switch == password)          //正确，显示'Good'
            begin
                flag = 3'b100;
                display_0 = 26;
                display_1 = 25;
                display_2 = 25;
                display_3 = 24;
            end

            else                            //错误，显示'Erro'
            begin
                flag = 3'b101;
                display_0 = 25;
                display_1 = 20;
                display_2 = 20;
                display_3 = 21;
            end
        end

        else if(clr)                        //密码清零，显示'Clr'
        begin
            flag = 3'b110;
            password = 8'b00000000;
            LED = 8'b00000000;
            display_0 = 20;
            display_1 = 28;
            display_2 = 27;
            display_3 = 29;
        end

        else                                //不进行任何操作
        begin
            clk_cnt = clk_cnt + 1;
            judge = clk_cnt[25:24];

            if(judge == 2'b11)
                LED = 8'b00000000;

            if(flag == 3'b000)              //保留前次操作后数码管显示，或更新当前输入数字
            begin
                case(sw0)
                    4'b0000: display_0 = 0;
                    4'b0001: display_0 = 1;
                    4'b0010: display_0 = 2;
                    4'b0011: display_0 = 3;
                    4'b0100: display_0 = 4;
                    4'b0101: display_0 = 5;
                    4'b0110: display_0 = 6;
                    4'b0111: display_0 = 7;
                    4'b1000: display_0 = 8;
                    4'b1001: display_0 = 9;
                    4'b1010: display_0 = 10;
                    4'b1011: display_0 = 11;
                    4'b1100: display_0 = 12;
                    4'b1101: display_0 = 13;
                    4'b1110: display_0 = 14;
                    4'b1111: display_0 = 15;
                endcase

                case(sw1)
                    4'b0000: display_1 = 0;
                    4'b0001: display_1 = 1;
                    4'b0010: display_1 = 2;
                    4'b0011: display_1 = 3;
                    4'b0100: display_1 = 4;
                    4'b0101: display_1 = 5;
                    4'b0110: display_1 = 6;
                    4'b0111: display_1 = 7;
                    4'b1000: display_1 = 8;
                    4'b1001: display_1 = 9;
                    4'b1010: display_1 = 10;
                    4'b1011: display_1 = 11;
                    4'b1100: display_1 = 12;
                    4'b1101: display_1 = 13;
                    4'b1110: display_1 = 14;
                    4'b1111: display_1 = 15;
                endcase

                display_2 = 29;
                display_3 = 29;
            end

            else if(flag == 3'b010)
            begin
                display_0 = 23;
                display_1 = 21;
                display_2 = 22;
                display_3 = 29;
            end

            else if(flag == 3'b100)
            begin
                display_0 = 26;
                display_1 = 25;
                display_2 = 25;
                display_3 = 24;
            end

            else if(flag == 3'b101)
            begin
                    display_0 = 25;
                    display_1 = 20;
                    display_2 = 20;
                    display_3 = 21;
            end

            else if(flag == 3'b110)
            begin
                display_0 = 20;
                display_1 = 28;
                display_2 = 27;
                display_3 = 29;
            end
            
            else
                clk_cnt = clk_cnt;
        end
    end

    assign control_0 = clk_cnt[15];
    assign control_1 = clk_cnt[16];
    assign an[3] = control_0 | control_1;
    assign an[2] = ~control_0 | control_1;
    assign an[1] = control_0 | ~control_1;
    assign an[0] = ~control_0 | ~control_1;

    always@(*)
        case({control_1, control_0})
            3'b00:num = display_0;
            3'b01:num = display_1;
            3'b10:num = display_2;
            3'b11:num = display_3;
        endcase

    locker_sub sub(
        .num(num),
        .a_to_g(a_to_g)
    );
endmodule
