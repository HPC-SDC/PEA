  //output(3bit)_op1(3bit)_op2(3bit)_opcode(3bit)
  //控制信号一共12bit，其中opcode为3bit是预留了其他complex运算的位置

module PE_fp #(
  parameter ctrl_width = 12,
  parameter data_width = 32,
  parameter E_P = 8,
  parameter M_P = 23
)
(
  input clk,
  input reg [ctrl_width-1:0] ctrl,  
  //output(3bit)_op1(3bit)_op2(3bit)_opcode(3bit)
  //控制信号一共12bit
  input reg [data_width-1:0] E, S, W, N,
  output reg [data_width-1:0] OutputE, OutputS, OutputW, OutputN,Data_memory,
  
  input reg reset,
  input reg en,
  input reg input_ready,
  input reg yumi,
  
  //reg sub_i;
  output wire ready_and_o,
  output wire output_ready,
  //output wire [E_P+M_P:0] z_o,
  output wire unimplemented_o,
  output wire invalid_o,
  output wire overflow_o,
  output wire underflow_o
);

  
  reg [data_width-1:0] reg1, reg2;
  reg [data_width-1:0] operand1, operand2;
  reg [data_width-1:0] result;

  reg [data_width-1:0] temp_add, temp_mul;

  reg op;

  reg [5:0] delay_ctrl;
  reg [5:0] delay_ctrl1;         
  reg [5:0] delay_ctrl2; // 延时两个周期的 delay_ctrl 信号
  
  reg [5:0] delay_ctrl3;

  bsg_fpu_add_sub #(
    .e_p(E_P),
    .m_p(M_P)
  ) dut_add (
    .clk_i(clk),
    .reset_i(reset),
    .en_i(en),
    .v_i(input_ready),
    .a_i(operand1),
    .b_i(operand2),
    .sub_i(op),
    .ready_and_o(ready_and_o),
    .v_o(output_ready),
    .z_o(temp_add),
    .unimplemented_o(unimplemented_o),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o),
    .yumi_i(yumi)
  );

  bsg_fpu_mul #(
    .e_p(E_P),
    .m_p(M_P)
  ) dut_mul (
    .clk_i(clk),
    .reset_i(reset),
    .en_i(en),
    .v_i(input_ready),
    .a_i(operand1),
    .b_i(operand2),
    .ready_and_o(ready_and_o),
    .v_o(output_ready),
    .z_o(temp_mul),
    .unimplemented_o(unimplemented_o),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o),
    .yumi_i(yumi)
  );


    always @(posedge clk) begin
    delay_ctrl <= {ctrl[ctrl_width-1:ctrl_width-3], ctrl[2:0]};  // 将 ctrl 的前3位和最后3位组合为 delay_ctrl
    end

    always @(posedge clk) begin
    delay_ctrl1 <= delay_ctrl;  // 延时一个周期
    end

    always @(posedge clk) begin
    delay_ctrl2 <= delay_ctrl1;  // 延时一个周期
    end

    always @(posedge clk) begin
    delay_ctrl3 <= delay_ctrl2;  // 延时一个周期
    end

  
  always @(*) begin

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


  //always @(posedge clk) begin  
  always @(*) begin  
  case (ctrl[2:0])
      2'b000: op = 0;         
      2'b001: op = 1; // logic-AND
    //   2'b0010: result <= operand1 ^ operand2; // XOR
    //   2'b0011: result <= operand1 || operand2; // logic-OR
    //   2'b0100: result <= !operand1 ; // logic-NOT
    //   2'b0101: result <= operand1 + operand2;

    //   2'b0001: result <= operand1 && operand2 // logic-AND
    //   2'b0010: result <= operand1 ^ operand2; // XOR
    //   2'b0011: result <= operand1 || operand2; // logic-OR
    //   2'b0100: result <= !operand1 ; // logic-NOT
    //   2'b0101: result <= operand1 + operand2;

      default: begin end
    endcase
  end

  always @(*) begin

        case (delay_ctrl3[2:0])
      3'd000: begin
               result <= temp_add;
             end
      3'd001: begin
               result <= temp_add;
             end
      3'd010: begin
               result <= temp_mul;
             end
      default: begin
                 // do nothing
               end
    endcase


    // 根据控制信号选择结果输出位置
    case (delay_ctrl3[5:3])
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

endmodule