//20240101更新
//1.数据位宽设置成parameter  ANSWER:已解决，可以在tb里面选择ctrl_width
//2.operand不要用寄存器存起来  ANSWER:如果设成wire会报错,选择的方案是使用一个always@(*)然后综合出组合逻辑，最后结果中就看不到reg
//3.always块内用 <=  ANSWER:已解决
//4.PE异构，不同ALU功能；日本的paper，学习ALU设计（针对超算场景），看他们的论文
//5.ALU部分改为组合逻辑  ANSWER:使用always@(*)综合出组合逻辑
//6.config reg 也设置成 parameter,即另外单元传输长度可变的ctrl信号

//C=A*B,需不需要从dense->sparse? ANSWER:不需要

//IP库关于浮点

//互联的形式先调研一下，别写代码


//20240121更新
//复现RIKEN的ALU
//sparse accumulator（是一个之前的工作），可以实现类似ROB的功能，SPM-SPM（输出是 DENSE的存储格式）
//SPM-GEM  STEP1:sym-bolitc先预先计算以SPARSE存储的C的大小。  STEP2: 给C分配一个内存空间   STEP3:计算具体数值


module PE02 #(
  parameter ctrl_width = 10,
  parameter data_width = 8
)
(
  input clk,
  input reg [ctrl_width-1:0] ctrl,  //output(3bit)_op1(3bit)_op2(3bit)_opcode(2bit)
  input reg [data_width-1:0] E, S, W, N,
  output reg [data_width-1:0] OutputE, OutputS, OutputW, OutputN,
  output reg [data_width-1:0] Data_memory
);

  
  reg [data_width-1:0] reg1, reg2;
  reg [data_width-1:0] operand1, operand2;
  reg [data_width-1:0] result;


  always @(*) begin
    // 根据控制信号选择第一个操作数
    case (ctrl[ctrl_width-4:ctrl_width-6])
      {ctrl_width-3{1'b0}}, 3'd000: operand1 <= E;
      {ctrl_width-3{1'b0}}, 3'd001: operand1 <= S;
      {ctrl_width-3{1'b0}}, 3'd010: operand1 <= W;
      {ctrl_width-3{1'b0}}, 3'd011: operand1 <= N;
      {ctrl_width-3{1'b0}}, 3'd100: operand1 <= reg1;
      {ctrl_width-3{1'b0}}, 3'd101: operand1 <= reg2;
      default: operand1 = {data_width{1'b0}}; // 默认情况下选择零
    endcase

    // 根据控制信号选择第二个操作数
    case (ctrl[ctrl_width-7:ctrl_width-9])
      {ctrl_width-6{1'b0}}, 3'd000: operand2 <= E;
      {ctrl_width-6{1'b0}}, 3'd001: operand2 <= S;
      {ctrl_width-6{1'b0}}, 3'd010: operand2 <= W;
      {ctrl_width-6{1'b0}}, 3'd011: operand2 <= N;
      {ctrl_width-6{1'b0}}, 3'd100: operand2 <= reg1;
      {ctrl_width-6{1'b0}}, 3'd101: operand2 <= reg2;
      default: operand2 = {data_width{1'b0}}; // 默认情况下选择零
    endcase
  end


  //always @(posedge clk) begin  
  always @(*) begin  
  case (ctrl[1:0])
      2'b00: result <= operand1 + operand2; // 加法操作
      2'b01: result <= operand1 - operand2; // 减法操作
      2'b10: result <= operand1 * operand2; // 乘法操作
      2'b11: result <= operand1 / operand2; // 除法操作
      default: result <= {data_width{1'b0}}; // 默认情况下输出零
    endcase

    // 根据控制信号选择结果输出位置
    case (ctrl[ctrl_width-1:ctrl_width-3])
      3'd000: begin
               OutputE <= result;
             end
      3'd001: begin
               OutputS <= result;
             end
      3'd010: begin
               OutputW <= result;
             end
      3'd011: begin
               OutputN <= result;
             end
      3'd100: begin
               Data_memory <= result;
             end
      3'd101: begin
               reg1 <= result;
             end
      3'd110: begin
               reg2 <= result;
             end
      default: begin
                 // do nothing
               end
    endcase
  end

/*
  always @(posedge clk) begin
    // 根据控制信号选择第一个操作数
    case (ctrl[ctrl_width-4:ctrl_width-6])
      {ctrl_width-3{1'b0}}, 3'd0: operand1 = E;
      {ctrl_width-3{1'b0}}, 3'd1: operand1 = S;
      {ctrl_width-3{1'b0}}, 3'd2: operand1 = W;
      {ctrl_width-3{1'b0}}, 3'd3: operand1 = N;
      {ctrl_width-3{1'b0}}, 3'd4: operand1 = reg1;
      {ctrl_width-3{1'b0}}, 3'd5: operand1 = reg2;
      default: operand1 = {data_width{1'b0}}; // 默认情况下选择零
    endcase

    // 根据控制信号选择第二个操作数
    case (ctrl[ctrl_width-7:ctrl_width-9])
      {ctrl_width-6{1'b0}}, 3'd0: operand2 = E;
      {ctrl_width-6{1'b0}}, 3'd1: operand2 = S;
      {ctrl_width-6{1'b0}}, 3'd2: operand2 = W;
      {ctrl_width-6{1'b0}}, 3'd3: operand2 = N;
      {ctrl_width-6{1'b0}}, 3'd4: operand2 = reg1;
      {ctrl_width-6{1'b0}}, 3'd5: operand2 = reg2;
      default: operand2 = {data_width{1'b0}}; // 默认情况下选择零
    endcase

    // 根据控制信号选择操作类型
    case (ctrl[1:0])
      2'b00: result = operand1 + operand2; // 加法操作
      2'b01: result = operand1 - operand2; // 减法操作
      2'b10: result = operand1 * operand2; // 乘法操作
      2'b11: result = operand1 / operand2; // 除法操作
      default: result = {data_width{1'b0}}; // 默认情况下输出零
    endcase

    // 根据控制信号选择结果输出位置
    case (ctrl[ctrl_width-1:ctrl_width-3])
      3'd0: begin
               OutputE = result;
             end
      3'd1: begin
               OutputS = result;
             end
      3'd2: begin
               OutputW = result;
             end
      3'd3: begin
               OutputN = result;
             end
      3'd4: begin
               Data_memory = result;
             end
      3'd5: begin
               reg1 = result;
             end
      3'd6: begin
               reg2 = result;
             end
      default: begin
                 // do nothing
               end
    endcase
  end
*/


endmodule

