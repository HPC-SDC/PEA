# PEA

# 20240101版本 PEv01
1.包括了PE的实现文件和testbench文件。

2.PE的实现思路：通过一个10bit的控制信号
`
input reg [10:0] ctrl,  //output（3bit）_op1(3bit)_op2(3bit)_opcode(2bit)
`
来控制ALU运算单元的操作

# 20240122版本 PEv02
1.数据位宽设置成parameter  ANSWER:已解决，可以在tb里面选择ctrl_width

2.operand不要用寄存器存起来  ANSWER:如果设成wire会报错,选择的方案是使用一个always@(*)然后综合出组合逻辑，最后结果中就看不到reg

3.always块内用 <=  ANSWER:已解决

4.PE异构，不同ALU功能；日本的paper，学习ALU设计（针对超算场景），看他们的论文

5.ALU部分改为组合逻辑  ANSWER:使用always@(*)综合出组合逻辑

6.config reg 也设置成 parameter,即另外单元传输长度可变的ctrl信号


# 20240127版本 PEv04
1.新增了complex PE的相关代码，PEv04.sv是单个complex PE的实现文件

2.FP文件夹是浮点运算需要用到的module，编译的时候要一起加入Modelsim编译

3.output(3bit)_op1(3bit)_op2(3bit)_opcode(3bit) //控制信号一共12bit，其中opcode为3bit是预留了其他complex运算的位置

4.时钟开始为 1 ，然后翻转

5.浮点运算的PE会延迟3个周期得到结果，所以使用delay_ctrl信号打三拍; 一定是上升沿触发！

6.最后使用打三拍之后的delay_ctrl和来控制输出

# 20240131版本 

## PEv05

1.PEv04是已经稳定的浮点运算模块，新增的PEv05是basic的运算，包括加减乘除，逻辑上的NOP,AND,OR,XOR,NOT等等。

2.为了保持和FP的一致性，保留了input_ready和output——ready信号。

## Operator中的steer和comp

1.仍然和之前一样采用ctrl为13位，多的位暂时不管，控制>,<,==,!=这四种情况

2.注意！comp单元的输出结果是以data流形式输出的！32位的0和32位的1.

## LS——tile

1.参考下图实现
<img width="506" alt="image" src="https://github.com/HPC-SDC/PEA/assets/150303558/fe8426c6-5182-49a5-924f-fa76feab4fc7">





