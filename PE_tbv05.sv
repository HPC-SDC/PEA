`timescale 1ns / 1ps

//时钟开始为 1 ，然后翻转
//浮点运算的PE会延迟3个周期得到结果，所以使用delay_ctrl信号打三拍; 一定是上升沿触发！
//最后使用打三拍之后的delay_ctrl和来控制输出

module PE_testbench05();

  reg clk; // 时钟信号
  reg reset;

  // input
  reg [31:0] E, S, W, N;
  reg [12:0] ctrl; // 控制信号
  reg en;
  reg input_ready;

  //output
  wire  output_ready;
  wire [31:0] OutputE, OutputS, OutputW, OutputN;
  wire [31:0] Data_memory;
  
  PE_basic PE_basic (
    .clk(clk),
    .reset(reset),
    .ctrl(ctrl),
    .E(E),
    .S(S),
    .W(W),
    .N(N),
    .en(en),
    .input_ready(input_ready),
    .OutputE(OutputE),
    .OutputS(OutputS),
    .OutputW(OutputW),
    .OutputN(OutputN),
    .Data_memory(Data_memory),
    .output_ready(output_ready)
  );

  initial begin
    clk = 1'b1; // 初始化时钟信号为 1
    reset = 1;
    en = 0;
    input_ready = 0;
    
    #10
    reset = 0; // 复位信号保持低电平
    en = 1; // 使能信号置高
    input_ready = 1; // 输入准备信号置高


    // 初始化输入值和控制信号
    E = 32'b0_00000000_00000000000000000000001;
    S = 32'b0_00000000_00000000000000000000010;
    W = 32'b0_00000000_00000000000000000000011;
    N = 32'b0_00000000_00000000000000000000100;

    //output（3bit）_op1(3bit)_op2(3bit)_opcode(4bit)
    ctrl = 13'b000_000_001_0000; // 


    // 在时钟上升沿时，更新寄存器的值
    
    #10 ctrl = 13'b001_000_001_0001; // 
    en = 0;

    // 在时钟上升沿时，更新寄存器的值
    // 除法保留整数部分
    #10 ctrl = 13'b010_000_001_0010; //
    en = 1;

    #10 ctrl = 13'b011_000_001_0011; // 

    #10 ctrl = 13'b000_000_001_0100; // 


   end

    always begin
   #5 clk = ~clk; // 定义一个 10ns 周期的时钟信号
   end


endmodule
