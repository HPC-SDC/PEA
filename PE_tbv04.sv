`timescale 1ns / 1ps

//时钟开始为 1 ，然后翻转
//浮点运算的PE会延迟3个周期得到结果，所以使用delay_ctrl信号打三拍; 一定是上升沿触发！
//最后使用打三拍之后的delay_ctrl和来控制输出

module PE_testbench04();

  reg clk; // 时钟信号
  reg reset;

  // input
  reg [31:0] E, S, W, N;
  reg [11:0] ctrl; // 控制信号
  reg en;
  reg input_ready;
  reg yumi;

  //output
  wire ready_and_o, output_ready;
  wire [31:0] OutputE, OutputS, OutputW, OutputN;
  wire [31:0] Data_memory;
  wire unimplemented_o, invalid_o, overflow_o, underflow_o;

  PE_fp complex_PE (
    .clk(clk),
    .reset(reset),
    .ctrl(ctrl),
    .E(E),
    .S(S),
    .W(W),
    .N(N),
    .en(en),
    .input_ready(input_ready),
    .yumi(yumi),
    .ready_and_o(ready_and_o),
    .output_ready(output_ready),
    .OutputE(OutputE),
    .OutputS(OutputS),
    .OutputW(OutputW),
    .OutputN(OutputN),
    .Data_memory(Data_memory),
    .unimplemented_o(unimplemented_o),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o)
  );

  initial begin
    clk = 1'b1; // 初始化时钟信号为 1
    reset = 1;
    en = 0;
    input_ready = 0;
    yumi = 0;
    
    #10
    reset = 0; // 复位信号保持低电平
    en = 1; // 使能信号置高
    input_ready = 1; // 输入准备信号置高
    yumi = 1; // yumi信号置高


    // 初始化输入值和控制信号
    E = 32'b0_10000000_10000000000000000000000;
    S = 32'b0_10000000_00000000000000000000000;
    W = 32'b0_01111110_10000000000000000000000;
    N = 32'b0_01111110_00000000000000000000000;

    //output（3bit）_op1(3bit)_op2(3bit)_opcode(2bit)
    ctrl = 12'b000_000_001_000; // 


    // 在时钟上升沿时，更新寄存器的值
    #10 ctrl = 12'b000_001_010_001; // REG1*W->REG2
  // REG2=4*2=1000(8)


    // 在时钟上升沿时，更新寄存器的值
    // 除法保留整数部分
    #10 ctrl = 12'b011_010_011_010; // REG1/REG2->Data_mem


    #10 ctrl = 12'b010_011_011_010; // REG1/REG2->Data_mem

    #10 ctrl = 12'b100_010_001_000; // REG1/REG2->Data_mem


   end

    always begin
   #5 clk = ~clk; // 定义一个 10ns 周期的时钟信号
   end


endmodule
