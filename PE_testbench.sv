`timescale 1ns / 1ps

module PE_testbench;

  reg clk; // 时钟信号
  reg [7:0] E, S, W, N; // 输入
  reg [10:0] ctrl; // 控制信号
  wire [4:0] OutputE, OutputS, OutputW, OutputN; // 输出
  wire [7:0] Data_memory; // 数据存储

  PE uut (
    .clk(clk), // 添加时钟信号
    .ctrl(ctrl),
    .E(E),
    .S(S),
    .W(W),
    .N(N),
    .OutputE(OutputE),
    .OutputS(OutputS),
    .OutputW(OutputW),
    .OutputN(OutputN),
    .Data_memory(Data_memory)
  );

  initial begin
    clk = 1'b0; // 初始化时钟信号为 0
    forever  
        #5 clk = ~clk;  


    // 初始化输入值和控制信号
    E = 8'b10101010;
    S = 8'b11001100;
    W = 8'b11110000;
    N = 8'b00001111;

    //output（3bit）_op1(3bit)_op2(3bit)_opcode(2bit)
    ctrl = 11'b000_000_001_00; // 选择 E、S 作为操作数，并且执行加法操作

    // 在时钟上升沿时，更新寄存器的值
    #5 ctrl = 11'b000_001_010_00; // 选择 S、W 作为操作数，并且执行减法操作

    // 在时钟上升沿时，更新寄存器的值
    #5 ctrl = 11'b001_001_010_11; // 选择 S、W 作为操作数，并且执行乘法操作

  end

 initial begin
    #1000; // 等待一些时间
    $finish; // 结束仿真
 end

  //always #5 clk = ~clk; // 定义一个 10ns 周期的时钟信号

  always begin
    $display("clk= %b,OutputE = %b, OutputS = %b, OutputW = %b, OutputN = %b, Data_memory = %b",
             clk,OutputE, OutputS, OutputW, OutputN, Data_memory);
  end

endmodule
