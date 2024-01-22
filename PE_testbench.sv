`timescale 1ns / 1ps

module PE_testbench();

  reg clk; // 时钟信号
  reg [7:0] E, S, W, N; // 输入
  reg [10:0] ctrl; // 控制信号
  wire [4:0] OutputE, OutputS, OutputW, OutputN; // 输出
  wire [7:0] Data_memory; // 数据存储

  initial begin
    clk = 1'b0; // 初始化时钟信号为 0
    // 初始化输入值和控制信号
    E = 8'b00000001;
    S = 8'b00000111;
    W = 8'b00000010;
    N = 8'b00001111;

    //output（3bit）_op1(3bit)_op2(3bit)_opcode(2bit)
    ctrl = 11'b011_000_001_00; // 
  // S=100 (4)


    // 在时钟上升沿时，更新寄存器的值
    #100 ctrl = 11'b110_001_010_10; // REG1*W->REG2
  // REG2=4*2=1000(8)


    // 在时钟上升沿时，更新寄存器的值
    // 除法保留整数部分
    #100 ctrl = 11'b100_011_011_11; // REG1/REG2->Data_mem
    // 4/8=0.5

  end

  always begin
  #10 clk = ~clk; // 定义一个 10ns 周期的时钟信号
  $display("clk= %b,OutputE = %b, OutputS = %b, OutputW = %b, OutputN = %b, Data_memory = %b",
             clk,OutputE, OutputS, OutputW, OutputN, Data_memory);
  end


  PE02 #(
    .ctrl_width(11),
    .data_width(8)
  )  uut (
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

endmodule
