//op2控制op1


module Steer_PE #(
  parameter ctrl_width = 13,//控制信号一共13位
  parameter data_width = 32
)
(
  input clk,
  input reg reset,
  input reg [ctrl_width-1:0] ctrl,  //output(3bit)_op1(3bit)_op2(3bit)_opcode(4bit)
  //op1 flow to next PE
  //op2 regarded as bool signal
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
      default: operand1 <= {data_width{1'bZ}}; // 默认情况下选择零
    endcase

    // 根据控制信号选择第二个操作数
    case (ctrl[ctrl_width-7:ctrl_width-9])
      {ctrl_width-6{1'b0}}, 3'd000: if(E!=0) result = operand1; else result = {data_width{1'bz}};
      {ctrl_width-6{1'b0}}, 3'd001: if(S!=0) result = operand1; else result = {data_width{1'bz}};
      {ctrl_width-6{1'b0}}, 3'd010: if(W!=0) result = operand1; else result = {data_width{1'bz}};
      {ctrl_width-6{1'b0}}, 3'd011: if(N!=0) result = operand1; else result = {data_width{1'bz}};

      default: operand2 <= {data_width{1'bz}}; // 默认情况下选择零
    endcase
    end

  end

//if(en&input_ready)  output_ready = 1;

  //always @(posedge clk) begin  
  always @(*) begin  

    if(en&input_ready)
    begin

    
    //output_ready = 1;


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