module PE_basic #(
  parameter ctrl_width = 13,//控制信号一共13位
  parameter data_width = 32
)
(
  input clk,
  input reg reset,
  input reg [ctrl_width-1:0] ctrl,  //output(3bit)_op1(3bit)_op2(3bit)_opcode(4bit)
  input reg [data_width-1:0] E, S, W, N,
  input reg en,
  input reg input_ready,
  
  output reg [data_width-1:0] OutputE, OutputS, OutputW, OutputN,
  output reg [data_width-1:0] Data_memory,
  output logic output_ready

);

  
  reg [data_width-1:0] reg1, reg2;
  reg [data_width-1:0] operand1, operand2;
  reg [data_width-1:0] result;


  always @(*) begin

    if (en & input_ready) begin
    output_ready <= 1'b1; // 高电平输出准备好
    end else begin
    output_ready <= 1'b0; // 低电平输出未准备好
    end

    if (en&input_ready)
    begin
    // 根据控制信号选择第一个操作数
    case (ctrl[ctrl_width-4:ctrl_width-6])
      {ctrl_width-3{1'b0}}, 3'd000: operand1 <= E;
      {ctrl_width-3{1'b0}}, 3'd001: operand1 <= S;
      {ctrl_width-3{1'b0}}, 3'd010: operand1 <= W;
      {ctrl_width-3{1'b0}}, 3'd011: operand1 <= N;
      {ctrl_width-3{1'b0}}, 3'd100: operand1 <= reg1;
      {ctrl_width-3{1'b0}}, 3'd101: operand1 <= reg2;
      default: operand1 <= {data_width{1'b0}}; // 默认情况下选择零
    endcase

    // 根据控制信号选择第二个操作数
    case (ctrl[ctrl_width-7:ctrl_width-9])
      {ctrl_width-6{1'b0}}, 3'd000: operand2 <= E;
      {ctrl_width-6{1'b0}}, 3'd001: operand2 <= S;
      {ctrl_width-6{1'b0}}, 3'd010: operand2 <= W;
      {ctrl_width-6{1'b0}}, 3'd011: operand2 <= N;
      {ctrl_width-6{1'b0}}, 3'd100: operand2 <= reg1;
      {ctrl_width-6{1'b0}}, 3'd101: operand2 <= reg2;
      default: operand2 <= {data_width{1'b0}}; // 默认情况下选择零
    endcase
    end

  end

//if(en&input_ready)  output_ready = 1;

  //always @(posedge clk) begin  
  always @(*) begin  

    if(en&input_ready)
    begin

    
    //output_ready = 1;

    case (ctrl[3:0])
        4'b0000: begin 
            //NOP
        end
        4'b0001: result <= operand1 & operand2; // AND
        4'b0010: result <= operand1 ^ operand2; // XOR
        4'b0011: result <= operand1 | operand2; // logic-OR
        4'b0100: result <= !operand1 ; // logic-NOT
        4'b0101: result <= operand1 + operand2;
        4'b0110: result <= operand1 - operand2; // 减法操作
        4'b0111: result <= operand1 * operand2; // 乘法操作
        4'b1000: result <= operand1 / operand2; // 除法操作

        default: begin 
            // NOP 遇到浮点类型也是不操作
        end
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

  end

endmodule