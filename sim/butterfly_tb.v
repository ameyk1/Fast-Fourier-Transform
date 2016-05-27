`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name: Fast Fourier Transform (16-point) 
// Module Name: butterfly_tb
// Project Name: Fast Fourier Transform (16-point)
//////////////////////////////////////////////////////////////////////////////

module butterfly_tb;

   /****************************************************************************
    * Signals
    ***************************************************************************/

   reg clk;
   reg reset;

   reg signed [15:0] Ar;
   reg signed [15:0] Ai;
   reg signed [15:0] Br;
   reg signed [15:0] Bi;
   reg signed [15:0] Wr;
   reg signed [15:0] Wi;

   wire signed [15:0] Xr;
   wire signed [15:0] Xi;
   wire signed [15:0] Yr;
   wire signed [15:0] Yi;

   integer i;

   /****************************************************************************
    * Generate Clock Signals
    ***************************************************************************/

   // 250 MHz clock
   initial clk = 1'b1;
   always #2 clk = ~clk;

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

   butterfly butterfly_0 (
      .clk  (clk),
      .Ar   (Ar),
      .Ai   (Ai),
      .Br   (Br),
      .Bi   (Bi),
      .Wr   (Wr),
      .Wi   (Wi),
      .Xr_F (Xr),
      .Xi_F (Xi),
      .Yr_F (Yr),
      .Yi_F (Yi)
   );

   /****************************************************************************
    * Apply Stimulus
    ***************************************************************************/

   initial begin

      repeat (1) @(posedge clk);

      reset = 1'b1;
      repeat (1) @(posedge clk);

      reset = 1'b0;

/* -----\/----- EXCLUDED -----\/-----
      Ar = 16'b1011001000101000;
      Ai = 16'b0100101001001010;

      Br = 16'b0100010100011101;
      Bi = 16'b1000101010011100;

      Wr = 16'b0100101001010001;
      Wi = 16'b0000001010000000;
 -----/\----- EXCLUDED -----/\----- */

      Ar = 16'b00000010_10000000; // 2.5
      Ai = 16'b00000101_01000000; // 5.25

      Br = 16'b00000110_00000000; // 6
      Bi = 16'b00000001_10000000; // 1.5

      Wr = 16'b01_00000000000000; // 1
      Wi = 16'b00_01100000000000; // 0.375

      repeat (5) @(posedge clk);

      $display("Xr = %d", Xr);
      $display("Xi = %d", Xi);
      $display("Yr = %d", Yr);
      $display("Yi = %d", Yi);

      $display("Xr = %16b", Xr);
      $display("Xi = %16b", Xi);
      $display("Yr = %16b", Yr);
      $display("Yi = %16b", Yi);

      repeat (1) @(posedge clk);

      $finish;

   end

endmodule
