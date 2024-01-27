`timescale 1ns/1ps

module add_mul_tb;

  // Parameters
  parameter E_P = 8;  // exponent width
  parameter M_P = 23; // fraction width

  // Signals
  reg clk;
  reg reset_add;
  reg en_add;
  reg v_add;
  reg yumi_add;
  reg op; //操作符，0表示加法，1表示减法
  reg [E_P+M_P:0] a;
  reg [E_P+M_P:0] b;

  reg reset_mul;
  reg en_mul;
  reg v_mul;
  reg yumi_mul;

  wire ready_and;
  wire v_o_add;
  wire v_o_mul;
  wire [E_P+M_P:0] z_o_add;
  wire [E_P+M_P:0] z_o_mul;
  wire unimplemented_o;
  wire invalid_o;
  wire overflow_o;
  wire underflow_o;
  

  // Instantiate the DUT
  // bsg_fpu_mul #(
  //   .e_p(E_P),
  //   .m_p(M_P)
  // ) dut_mul (
  //   .clk_i(clk),
  //   .reset_i(reset_mul),
  //   .en_i(en_mul),
  //   .v_i(v_mul),
  //   .a_i(a),
  //   .b_i(b),
  //   .ready_and_o(ready_and),
  //   .v_o(v_o_mul),
  //   .z_o(z_o_mul),
  //   .unimplemented_o(unimplemented_o),
  //   .invalid_o(invalid_o),
  //   .overflow_o(overflow_o),
  //   .underflow_o(underflow_o),
  //   .yumi_i(yumi_mul)
  // );

  bsg_fpu_add_sub #(
    .e_p(E_P),
    .m_p(M_P)
  ) dut_add (
    .clk_i(clk),
    .reset_i(reset_add),
    .en_i(en_add),
    .v_i(v_add),
    .a_i(a),
    .b_i(b),
    .sub_i(op),
    .ready_and_o(ready_and),
    .v_o(v_o_add),
    .z_o(z_o_add),
    .unimplemented_o(unimplemented_o),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o),
    .yumi_i(yumi_add)
  );

  // Test stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    reset_add = 1;
    reset_mul = 1;

    // Release reset
    reset_add = 0;
    reset_mul = 0;
    en_add = 1;
    v_add = 1;
    yumi_add = 1;
    op = 0;
    // Test case 1: Normal operation
    a = 32'b0_10000000_10000000000000000000000; // Example input values
    b = 32'b0_10000000_10000000000000000000000;

    #10
    reset_add=0;

    #10
    en_mul = 1; en_add= 0;
    v_mul = 1;
    yumi_mul = 1;
    // Test case 2: Overflow
    a = 32'b0_01111110_10000000000000000000000;
    b = 32'b0_01111110_00000000000000000000000;
    #20;

    // Add more test cases as needed...

  end

  always #5 clk = ~clk;

endmodule
