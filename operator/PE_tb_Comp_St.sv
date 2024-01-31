`timescale 1ns / 1ps

module PE_tb_Comp_St();

  reg clk; // 时钟信号
  reg reset;

  // input
  reg [31:0] E1, S1, W1, N1;
  reg [31:0] E, S, W, N;
  reg [12:0] ctrl1; // 控制信号
  reg [12:0] ctrl; // 控制信号
  reg en;
  reg input_ready;

  //output
  wire  output_ready1;
  wire  output_ready;
  wire [31:0] OutputE1, OutputS1, OutputW1, OutputN1;
  wire [31:0] OutputE, OutputS, OutputW, OutputN;
  wire [31:0] Data_memory;
  
  Comp_PE Comp_PE1 (
    .clk(clk),
    .reset(reset),
    .ctrl(ctrl1),
    .E(E1),
    .S(S1),
    .W(W1),
    .N(N1),
    .en(en),
    .input_ready(input_ready),
    .OutputE(OutputE1),
    .OutputS(OutputS1),
    .OutputW(OutputW1),
    .OutputN(OutputN1),
    .Data_memory(Data_memory),
    .output_ready(output_ready1)
  );

  Steer_PE Steer_PE1 (
    .clk(clk),
    .reset(reset),
    .ctrl(ctrl),
    .E(E),
    .S(S),
    .W(OutputE1),
    .N(N),
    .en(en),
    .input_ready(output_ready1),
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

    E1 = 32'b0_00000000_00000000000000000000001;
    S1 = 32'b0_00000000_00000000000000000000010;
    W1 = 32'b0_00000000_00000000000000000000011;
    N1 = 32'b0_00000000_00000000000000000000100;

    //output（3bit）_op1(3bit)_op2(3bit)_opcode(4bit)
    ctrl1 = 13'b000_000_001_0010; // 


    // 在时钟上升沿时，更新寄存器的值
    
    #10 ctrl = 13'b001_001_010_0000; // 



   end

    always begin
   #5 clk = ~clk; // 定义一个 10ns 周期的时钟信号
   end


endmodule
