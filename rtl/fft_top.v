//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name: Fast Fourier Transform (16-point) 
// Module Name: fft_top
// Project Name: Fast Fourier Transform (16-point)
/////////////////////////////////////////////////////////////////////////////////

module fft_top (
   input wire        clk,             
   input wire        reset,     
   input wire        in_push,
   input wire [15:0] in_real,
   input wire [15:0] in_imag,
   output wire       in_stall,
   output reg        out_push_F,
   output reg [15:0] out_real_F,
   output reg [15:0] out_imag_F,
   input wire        out_stall
);

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   wire [3:0]  read_addr_1;
   wire [31:0] read_data_1;
   wire [3:0]  read_addr_2;
   wire [31:0] read_data_2;
   wire [3:0]  write_addr_1;
   wire [31:0] write_data_1;
   wire [31:0] muxed_write_data_1;
   wire        write_en_1;
   wire [3:0]  write_addr_2;
   wire [31:0] write_data_2;
   wire        write_en_2;
   wire        write_back;

   wire [2:0]  W_addr;
   wire [31:0] W;

   wire [31:0] X;
   wire [31:0] Y;

   wire        out_push;

   /****************************************************************************
    * Continuous Assignments
    ***************************************************************************/

   assign muxed_write_data_1 = (write_back == 1'b1)? X : write_data_1;

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

   fft_ctrl_sm fft_ctrl_sm_0 (
      .clk             (clk),
      .reset           (reset),
      .in_push         (in_push),
      .in_real         (in_real),
      .in_imag         (in_imag),
      .in_stall_F      (in_stall),
      .read_addr_1_F   (read_addr_1),
      .read_addr_2_F   (read_addr_2),
      .W_addr_F        (W_addr),
      .write_addr_1_F  (write_addr_1),
      .write_data_1_F  (write_data_1),
      .write_en_1_F    (write_en_1),
      .write_addr_2_F  (write_addr_2),
      .write_en_2_F    (write_en_2),
      .write_back_F    (write_back),
      .out_push_F      (out_push),
      .out_stall       (out_stall)
   );

   mem_32x16 mem_32x16_0 (
      .clk           (clk),
      .write_addr_1  (write_addr_1),
      .write_data_1  (muxed_write_data_1),
      .write_en_1    (write_en_1),
      .write_addr_2  (write_addr_2),
      .write_data_2  (Y),
      .write_en_2    (write_en_2),
      .read_addr_1   (read_addr_1),
      .read_data_1   (read_data_1),
      .read_addr_2   (read_addr_2),
      .read_data_2   (read_data_2)
   );

   w_lut w_lut_0 (
      .addr (W_addr),
      .W    (W)
   );

   butterfly butterfly_0 (
      .clk  (clk),
      .Ar   (read_data_1[31:16]),
      .Ai   (read_data_1[15:0]),
      .Br   (read_data_2[31:16]),
      .Bi   (read_data_2[15:0]),
      .Wr   (W[31:16]),
      .Wi   (W[15:0]),
      .Xr_F (X[31:16]),
      .Xi_F (X[15:0]),
      .Yr_F (Y[31:16]),
      .Yi_F (Y[15:0])
   );

   /****************************************************************************
    * Synchronous Logic
    ***************************************************************************/

   always @(posedge clk) begin
      out_push_F <= out_push;
      out_real_F <= read_data_1[31:16];
      out_imag_F <= read_data_1[15:0];
   end

endmodule
