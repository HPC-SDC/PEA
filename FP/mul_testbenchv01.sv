`timescale 1ns/1ps

module mul_testbench;

  // Parameters
  parameter E_P = 8;  // exponent width
  parameter M_P = 23; // fraction width

  // Signals
  reg clk;
  reg reset;
  reg en;
  reg v;
  reg [E_P+M_P:0] a;
  reg [E_P+M_P:0] b;

  wire ready_and;
  wire v_o;
  wire [E_P+M_P:0] z_o;
  wire unimplemented_o;
  wire invalid_o;
  wire overflow_o;
  wire underflow_o;
  reg yumi;

  // Instantiate the DUT
  bsg_fpu_mul #(
    .e_p(E_P),
    .m_p(M_P)
  ) dut (
    .clk_i(clk),
    .reset_i(reset),
    .en_i(en),
    .v_i(v),
    .a_i(a),
    .b_i(b),
    .ready_and_o(ready_and),
    .v_o(v_o),
    .z_o(z_o),
    .unimplemented_o(unimplemented_o),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o),
    .yumi_i(yumi)
  );

  // Test stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    // Release reset
    #1
    reset = 0;
    en = 1;
    v = 1;
    yumi = 1;

    #44

    a = 32'b0;
    b = 32'b0;
    // Test case 1: Normal operation
    #10;
    a = 32'b0_01111110_00000000000000000000000; // Example input values
    b = 32'b0_01111110_00000000000000000000000;

    #10
    // Test case 2: Overflow
    a = 32'b01111111001111111111111111111111;
    b = 32'b01111111001111111111111111111111;
    #20;

    // Add more test cases as needed...

  end

  always #5 clk = ~clk;

endmodule
