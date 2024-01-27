`timescale 1ns/1ps

module add_mul_tb03;

  // Parameters
  localparam E_P = 8;  // 选择合适的值
  localparam M_P = 23; // 选择合适的值

  // Inputs
  reg clk_i;
  reg reset_i;
  reg en_i;
  reg v_i;
  reg [E_P+M_P:0] a_i;
  reg [E_P+M_P:0] b_i;
  reg sub_i;
  reg yumi_i;

  // Outputs
  wire ready_and_o;
  wire v_o;
  wire [E_P+M_P:0] z_o;
  wire unimplemented_o;
  wire invalid_o;
  wire overflow_o;
  wire underflow_o;

  // Instantiate the DUT
  bsg_fpu_add_sub #(
    .e_p(E_P),
    .m_p(M_P)
  ) dut (
    .clk_i(clk_i),
    .reset_i(reset_i),
    .en_i(en_i),
    .v_i(v_i),
    .a_i(a_i),
    .b_i(b_i),
    .sub_i(sub_i),
    .ready_and_o(ready_and_o),
    .v_o(v_o),
    .z_o(z_o),
    .unimplemented_o(unimplemented_o),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o),
    .yumi_i(yumi_i)
  );


  reg reset_mul;
  reg en_mul;
  reg v_mul;
  reg yumi_mul;

  wire v_o_mul;
  wire [E_P+M_P:0] z_o_mul;

  bsg_fpu_mul #(
    .e_p(E_P),
    .m_p(M_P)
  ) dut_mul (
    .clk_i(clk_i),
    .reset_i(reset_mul),
    .en_i(en_mul),
    .v_i(v_mul),
    .a_i(a_i),
    .b_i(b_i),
    .ready_and_o(ready_and_o),
    .v_o(v_o_mul),
    .z_o(z_o_mul),
    .unimplemented_o(unimplemented_o),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o),
    .yumi_i(yumi_i)
  );


  // Clock generation
  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    reset_i = 1;
    reset_mul = 1;

    // Release reset
    #10 reset_i = 0;
    reset_mul = 0; 

    en_i = 1;
    v_i = 1;
    //en_mul = 1; 
    v_mul = 1;
    yumi_mul = 1;

    a_i = 32'b0_10000000_10000000000000000000000;  // 设置合适的值
    b_i = 32'b0_10000000_10000000000000000000000;  // 设置合适的值
    sub_i = 1;
    yumi_i = 1;

    #10
    en_i = 1;
    en_mul = 1; 
    v_mul = 0;
    a_i = 32'b0_10000000_00000000000000000000000;  // 设置合适的值
    b_i = 32'b0_10000000_10000000000000000000000;  // 设置合适的值


    #10
    en_i = 1;

    v_mul = 1;

    sub_i = 0;
    a_i = 32'b0_10000000_10000000000000000000000;  // 设置合适的值
    b_i = 32'b0_10000000_00000000000000000000000;  // 设置合适的值

    #10
    v_mul = 0 ;

    a_i = 32'b0_10000000_00000000000000000000000;  // 设置合适的值
    b_i = 32'b0_01111110_10000000000000000000000;  // 设置合适的值
   
   
    #10
    v_mul = 1 ;

    a_i = 32'b0_10000000_00000000000000000000000;  // 设置合适的值
    b_i = 32'b0_01111110_00000000000000000000000;  // 设置合适的值
   
   
    // Add your test cases here
    // ...

    // Terminate simulation after some time
    #1000 $finish;
  end

endmodule
