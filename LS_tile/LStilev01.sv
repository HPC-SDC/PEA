//offset(6bit)_address(6bit)_op(1bit)
//0:PE读内存
module LS_tile1 #(
  parameter ctrl_width = 13,//控制信号一共13位
  parameter data_width = 32,
    parameter x_memory = 64,
  parameter y_memory = 64
)
(
  input clk,
  input reg reset,
  input reg [ctrl_width-1:0] ctrl,  
  input reg [data_width-1:0] FromMemoryReg,
  input reg en,
  input reg input_ready,
  input reg [data_width-1:0] FromPE,
  
  //output reg [data_width-1:0] ToMmory[0:63][0:63],

  output reg [data_width-1:0] ToPE,
  output reg [data_width-1:0] ToMemoryReg,
  output logic output_ready
);

  
  reg [data_width-1:0] temp;


  always @(*) begin

    if (en & input_ready) begin
    output_ready <= 1'b1; // 高电平输出准备好
    end else begin
    output_ready <= 1'b0; // 低电平输出未准备好
    end

  end

//if(en&input_ready)  output_ready = 1;

  //always @(posedge clk) begin  
always @(*) begin  

    if(en&input_ready)
    begin
    
    //output_ready = 1;
    case (ctrl[0])
        1'b0: ToPE <= FromMemoryReg;
        1'b1: ToMemoryReg <= FromPE; 
        default: begin 
            // NOP 遇到浮点类型也是不操作
        end
        endcase
    end

  end

endmodule