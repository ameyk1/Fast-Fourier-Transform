//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name: Fast Fourier Transform (16-point) 
// Module Name:  mem_32x16
// Project Name: Fast Fourier Transform (16-point)
///////////////////////////////////////////////////////////////////////////////

module mem_32x16 (
   input wire         clk,
   input wire  [3:0]  write_addr_1,
   input wire  [31:0] write_data_1,
   input wire         write_en_1,
   input wire  [3:0]  write_addr_2,
   input wire  [31:0] write_data_2,
   input wire         write_en_2,
   input wire  [3:0]  read_addr_1,
   output wire [31:0] read_data_1,
   input wire  [3:0]  read_addr_2,
   output wire [31:0] read_data_2
);

   /****************************************************************************
    * Signals
    ***************************************************************************/

   reg [31:0] mem_array [15:0];

   /****************************************************************************
    * Continuous Assignments
    ***************************************************************************/

   assign read_data_1 = mem_array[read_addr_1];
   assign read_data_2 = mem_array[read_addr_2];

   /****************************************************************************
    * Synchronous Logic
    ***************************************************************************/

   always @(posedge clk) begin

      if (write_en_1 == 1'b1) begin
         mem_array[write_addr_1] <= write_data_1;
      end

      if (write_en_2 == 1'b1) begin
         mem_array[write_addr_2] <= write_data_2;
      end

   end

endmodule
