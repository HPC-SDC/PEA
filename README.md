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
