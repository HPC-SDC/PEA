`timescale 1ns / 1ps

module PE_tb_LS();

  parameter data_width = 32;

  parameter x_memory = 64;
  parameter y_memory = 64;

  reg clk; // 时钟信号
  reg reset;

  // input
  reg [12:0] ctrl; // 控制信号
  reg en;
  reg [31:0] outputW;
  reg input_ready;

  //output
  wire  output_ready;
  wire [31:0] ToPE;
  //wire [31:0] OutputE, OutputS, OutputW, OutputN;



  reg [data_width-1:0] FromMemoryReg;
  reg [data_width-1:0] ToMemoryReg;
  reg [data_width-1:0] Memory[x_memory][y_memory];
  
  LS_tile1 LS (
    .clk(clk),
    .reset(reset),
    .ctrl(ctrl),
    .FromMemoryReg(FromMemoryReg),
    .en(en),
    .input_ready(input_ready),
    .FromPE(outputW),
    .ToPE(ToPE),
    .ToMemoryReg(ToMemoryReg),
    .output_ready(output_ready1)
  );

  initial begin
    clk = 1'b1; // 初始化时钟信号为 1
    reset = 1;
    en = 0;
    input_ready = 0;

    // 逐个填充内存A
        for (int i = 0; i < 64; i++) begin
            for (int j = 0; j < 64; j++) begin
                Memory[i][j] <= i*64 + j; // 填充内存A为递增序列
            end
        end
    
    #10
    reset = 0; // 复位信号保持低电平
    en = 1; // 使能信号置高
    input_ready = 1; // 输入准备信号置高



    // 初始化输入值和控制信号
    outputW = 32'b0_00000000_00000000000000000000001;

    //output（3bit）_op1(3bit)_op2(3bit)_opcode(4bit)
    ctrl = 13'b000001_000001_0; // 

    FromMemoryReg = Memory[1][1];

    #10
    ctrl = 13'b000001_000010_1; //写入 

    Memory[1][2] = ToMemoryReg ;

   end

    always begin
   #5 clk = ~clk; // 定义一个 10ns 周期的时钟信号
   end


endmodule
