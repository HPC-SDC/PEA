# PEA
1.包括了PE的实现文件和testbench文件。

2.PE的实现思路：通过一个10bit的控制信号
`
input reg [10:0] ctrl,  //output（3bit）_op1(3bit)_op2(3bit)_opcode(2bit)
`
来控制ALU运算单元的操作
