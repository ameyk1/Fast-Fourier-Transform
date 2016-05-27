//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name: Fast Fourier Transform (16-point) 
// Module Name:    butterfly 
// Project Name: Fast Fourier Transform (16-point)
//////////////////////////////////////////////////////////////////////////////////


module butterfly #(
   parameter NBITS = 16
)(
   input wire                    clk,
   input wire signed [NBITS-1:0] Ar,
   input wire signed [NBITS-1:0] Ai,
   input wire signed [NBITS-1:0] Br,
   input wire signed [NBITS-1:0] Bi,
   input wire signed [NBITS-1:0] Wr,
   input wire signed [NBITS-1:0] Wi,
   output reg signed [NBITS-1:0] Xr_F,
   output reg signed [NBITS-1:0] Xi_F,
   output reg signed [NBITS-1:0] Yr_F,
   output reg signed [NBITS-1:0] Yi_F
);

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   // Registered input values.
   // These are in 8.8 format.
   reg signed [NBITS-1:0] Ar_F;
   reg signed [NBITS-1:0] Ai_F;
   reg signed [NBITS-1:0] Br_F;
   reg signed [NBITS-1:0] Bi_F;
   reg signed [NBITS-1:0] Wr_F;
   reg signed [NBITS-1:0] Wi_F;

   // Re-registered A values.
   // These are in 8.8 format.
   reg signed [NBITS-1:0] Ar_Fd2;
   reg signed [NBITS-1:0] Ai_Fd2;

   // Intermediate values used to store the product of B and W.
   // The output of the multiply is 10.22 format.
   // These are in 10.20 format because the final two bits are truncated.
   reg signed [NBITS*2-3:0] Zra_F;
   reg signed [NBITS*2-3:0] Zrb_F;
   reg signed [NBITS*2-3:0] Zia_F;
   reg signed [NBITS*2-3:0] Zib_F;

   // Intermediate values used to store partial output sums.
   // These are in 11.20 format.
   reg signed [NBITS*2-2:0] Zrsub;
   reg signed [NBITS*2-2:0] Ziadd;

   // Intermediate values used to store the pre-saturated X and Y values.
   // These are in 12.20 format.
   reg signed [NBITS*2-1:0] Xr_full_F;
   reg signed [NBITS*2-1:0] Xi_full_F;
   reg signed [NBITS*2-1:0] Yr_full_F;
   reg signed [NBITS*2-1:0] Yi_full_F;

   /****************************************************************************
    * Data Path
    ***************************************************************************/

   always @(*) begin

      // Compute the first portion of the X and Y outputs.
      Zrsub = ({Zra_F[29], Zra_F} - {Zrb_F[29], Zrb_F});
      Ziadd = ({Zia_F[29], Zia_F} + {Zib_F[29], Zib_F});

   end

   always @(posedge clk) begin

      // Register the inputs.
      Ar_F <= Ar;
      Ai_F <= Ai;
      Br_F <= Br;
      Bi_F <= Bi;
      Wr_F <= Wr;
      Wi_F <= Wi;

      // Re-register the A inputs.
      Ar_Fd2 <= Ar_F;
      Ai_Fd2 <= Ai_F;

      // Register the outputs of the multipliers. Also truncate the last two
      // bits to help meet timing.
      Zra_F <= (Br_F * Wr_F) >>> 2;
      Zrb_F <= (Bi_F * Wi_F) >>> 2;
      Zia_F <= (Br_F * Wi_F) >>> 2;
      Zib_F <= (Bi_F * Wr_F) >>> 2;

      // Compute the X and Y outputs.
      Xr_full_F <= { {4{Ar_Fd2[15]}}, Ar_Fd2, {12{1'b0}} } + {Zrsub[30], Zrsub};
      Xi_full_F <= { {4{Ai_Fd2[15]}}, Ai_Fd2, {12{1'b0}} } + {Ziadd[30], Ziadd};
      Yr_full_F <= { {4{Ar_Fd2[15]}}, Ar_Fd2, {12{1'b0}} } - {Zrsub[30], Zrsub};
      Yi_full_F <= { {4{Ai_Fd2[15]}}, Ai_Fd2, {12{1'b0}} } - {Ziadd[30], Ziadd};

      // Saturate and truncate to get the final output values. In the first
      // stage, the output of saturate() will be a 9.7 format number; in the
      // second, third, and fourth stages, the output will be a 10.6, 11.5, and
      // 12.4 format number, respectively. This gradual format change prevents
      // the output from saturating unnecessarily.
      Xr_F <= saturate(Xr_full_F);
      Xi_F <= saturate(Xi_full_F);
      Yr_F <= saturate(Yr_full_F);
      Yi_F <= saturate(Yi_full_F);

   end

   /****************************************************************************
    * Functions
    ***************************************************************************/

   function signed [15:0] saturate(
      input signed [31:0] value
   );

      // If the value is greater than the largest positive number that can be
      // represented by a 12.4 format number, saturate positive.
      if (value > $signed(32'h7fff0000))
         saturate = 16'h7fff;

      // If the value is smaller than the smallest negative number that can be
      // represented by a 12.4 format number, saturate negative.
      else if (value < $signed(32'h80000000))
         saturate = 16'h8000;

      // Otherwise, return the value. This select also changes the number
      // format, shifting the decimal point to the right by one place.
      else
         saturate = value[28:13];

   endfunction

endmodule
