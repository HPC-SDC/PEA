module PE (
  input clk,
  input reg [10:0] ctrl,  //output（3bit）_op1(3bit)_op2(3bit)_opcode(2bit)
  input reg [7:0] E, S, W, N,
  output reg [4:0] OutputE, OutputS, OutputW, OutputN,
  output reg [7:0] Data_memory
);
  
  reg [7:0] reg1, reg2;
  reg [7:0] operand1, operand2;
  reg [7:0] result;

  always @(posedge clk)
    begin
      // 根据控制信号选择第一个操作数
      case (ctrl[7:5])
        3'b000: operand1 = E;
        3'b001: operand1 = S;
        3'b010: operand1 = W;
        3'b011: operand1 = N;
        3'b100: operand1 = reg1;
        3'b101: operand1 = reg2;
        default: operand1 = 8'b0; // 默认情况下选择零
      endcase

      // 根据控制信号选择第二个操作数
      case (ctrl[4:2])
        3'b000: operand2 = E;
        3'b001: operand2 = S;
        3'b010: operand2 = W;
        3'b011: operand2 = N;
        3'b100: operand2 = reg1;
        3'b101: operand2 = reg2;
        default: operand2 = 8'b0; // 默认情况下选择零
      endcase

      // 根据控制信号选择操作类型
      case (ctrl[1:0])
        2'b00: result = operand1 + operand2; // 加法操作
        2'b01: result = operand1 - operand2; // 减法操作
        2'b10: result = operand1 * operand2; // 乘法操作
        2'b11: result = operand1 / operand2; // 除法操作
        default: result = 8'b0; // 默认情况下输出零
      endcase
      
      // 根据控制信号选择结果输出位置
      case (ctrl[10:8])
        3'b000: begin
                 OutputE <= result;
               end
        3'b001: begin
                 OutputS <= result;
               end
        3'b010: begin
                 OutputW <= result;
               end
        3'b011: begin
                 OutputN <= result;
               end
        3'b100: begin
                 Data_memory <= result;
               end
        3'b101: begin
                 reg1 <= result;
               end
        3'b110: begin
                 reg2 <= result;
               end
        default: begin
                   // do nothing
                 end
      endcase
    end

endmodule
