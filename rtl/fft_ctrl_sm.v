
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name: Fast Fourier Transform (16-point) 
// Module Name:  fft_ctrl_sm
// Project Name: Fast Fourier Transform (16-point)
////////////////////////////////////////////////////////////////////////////////

module fft_ctrl_sm (
   input wire        clk,
   input wire        reset,

   input wire        in_push,
   input wire [15:0] in_real,
   input wire [15:0] in_imag,
   output reg        in_stall_F, // equivalent to hold_in

   output reg [3:0]  read_addr_1_F,
   output reg [3:0]  read_addr_2_F,
   output reg [2:0]  W_addr_F,

   output reg [3:0]  write_addr_1_F,
   output reg [31:0] write_data_1_F,
   output reg        write_en_1_F,
   output reg [3:0]  write_addr_2_F,
   output reg        write_en_2_F,
   output reg        write_back_F,

   output reg        out_push_F,
   input wire        out_stall
);

   /****************************************************************************
    * Localparams
    ***************************************************************************/

   localparam RX_ONLY        = 5'b00001;
   localparam RX_AND_READ    = 5'b00010;
   localparam READ_AND_STORE = 5'b00100;
   localparam TX_AND_STORE   = 5'b01000;
   localparam TX_ONLY        = 5'b10000;

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg  [4:0]  current_state_F;
   reg  [4:0]  next_state;

   reg         in_stall;

   reg  [3:0]  read_addr_1;
   reg  [3:0]  read_addr_2;
   wire [2:0]  W_addr;

   reg  [3:0]  write_addr_1;
   reg  [31:0] write_data_1;
   reg         write_en_1;
   reg  [3:0]  write_addr_2;
   reg         write_en_2;
   reg         write_back;

   reg  [3:0]  counter_F;
   reg  [3:0]  counter;

   reg  [1:0]  stage_F;
   reg  [1:0]  stage;

   reg  [2:0]  butterfly_F;
   reg  [2:0]  butterfly;

   reg         skip_F;
   reg         skip_Fd2;
   reg         skip_Fd3;
   reg         skip_Fd4;
   reg         skip;

   wire [3:0]  A_addr;
   reg  [3:0]  A_addr_F;
   reg  [3:0]  A_addr_Fd2;
   reg  [3:0]  A_addr_Fd3;
   reg  [3:0]  A_addr_Fd4;
   wire [3:0]  B_addr;
   reg  [3:0]  B_addr_F;
   reg  [3:0]  B_addr_Fd2;
   reg  [3:0]  B_addr_Fd3;
   reg  [3:0]  B_addr_Fd4;

   reg         out_push;

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

   read_addr_lut read_addr_lut_0 (
      .stage     (stage_F),
      .butterfly (butterfly_F),
      .A_addr    (A_addr),
      .B_addr    (B_addr),
      .W_addr    (W_addr)
   );

   /****************************************************************************
    * Update Outputs and Next State
    ***************************************************************************/

   always @(*) begin

      // Default value for next state.
      next_state = current_state_F;

      // Default values for output signals.
      in_stall = 1'b1;

      read_addr_1 = read_addr_1_F;
      read_addr_2 = read_addr_2_F;

      write_addr_1 = write_addr_1_F;
      write_data_1 = write_data_1_F;
      write_en_1 = 1'b0;
      write_addr_2 = write_addr_2_F;
      write_en_2 = 1'b0;
      write_back = 1'b0;

      out_push = 1'b0;

      // Default values for internal signals.
      counter = counter_F;
      stage = stage_F;
      butterfly = butterfly_F;
      skip = 1'b0;

      // Update signal values and next state.
      case (current_state_F)

         RX_ONLY: begin

            // Indicate to the sender to transmit data.
            in_stall = 1'b0;

            // If hold is low and push is high...
            if (in_stall_F == 1'b0 && in_push == 1'b1) begin

               // Save the input data to memory.
               write_addr_1 = counter_F;
               write_data_1 = {in_real, in_imag};
               write_en_1 = 1'b1;

               // Increment the counter.
               counter = counter_F + 1;

            end

            // If the counter is at 11...
            if (counter_F == 11) begin

               // Proceed to the RX_AND_READ state.
               next_state = RX_AND_READ;

            end

         end // case: RX_ONLY


         RX_AND_READ: begin

            // Indicate to the sender to transmit data.
            in_stall = 1'b0;

            // If hold is low and push is high...
            if (in_stall_F == 1'b0 && in_push == 1'b1) begin

               // Save the input data to memory.
               write_addr_1 = counter_F;
               write_data_1 = {in_real, in_imag};
               write_en_1 = 1'b1;

               // Increment the counter.
               counter = counter_F + 1;

               read_addr_1 = A_addr;
               read_addr_2 = B_addr;

               // Read the next two inputs to the butterfly from memory.
               butterfly = butterfly_F + 1;

            end

            // If the counter is at 15...
            if (counter_F == 15) begin

               // Indicate to the sender to stop transmitting data.
               in_stall = 1'b1;

               // Proceed to the READ_AND_STORE state.
               next_state = READ_AND_STORE;

            end

         end // case: RX_AND_READ


         READ_AND_STORE: begin

            read_addr_1 = A_addr;
            read_addr_2 = B_addr;

            // Read the next two inputs to the butterfly from memory.
            butterfly = butterfly_F + 1;

            // Write the two outputs from the butterfly back to memory.
            write_addr_1 = A_addr_Fd4;
            write_addr_2 = B_addr_Fd4;

            if (skip_Fd4 == 1'b0) begin
               write_en_1 = 1'b1;
               write_en_2 = 1'b1;
            end

            write_back = 1'b1;

            if (butterfly_F == 0) begin

               if (stage_F == 3) begin

                  // If the skip flag is not already set...
                  if (skip_F == 1'b0) begin

                     // Assert the skip flag.
                     skip = 1'b1;

                     // Reset the butterfly and stage values.
                     butterfly = butterfly_F;
                     stage = stage_F;

                  end

               end

            end

            // If all of the butterflies in this stage have been completed...
            if (butterfly_F == 7) begin

               // Update the stage.
               stage = stage_F + 1;

               // If this is also the final stage...
               if (stage_F == 3) begin

                  // Proceed to the TX_AND_STORE state.
                  next_state = TX_AND_STORE;

               end

            end

         end // case: READ_AND_STORE


         TX_AND_STORE: begin

            // Write the two outputs from the butterfly back to memory.
            write_addr_1 = A_addr_Fd4;
            write_en_1 = 1'b1;

            write_addr_2 = B_addr_Fd4;
            write_en_2 = 1'b1;

            write_back = 1'b1;

            // Assert the output push signal.
            out_push = 1'b1;

            read_addr_1 = {counter_F[0], counter_F[1], counter_F[2], counter_F[3]};

            // Increment the counter.
            counter = counter_F + 1;

            // If the counter is at 3...
            if (counter_F == 3) begin

               // Proceed to the TX_ONLY state.
               next_state = TX_ONLY;

            end

         end // case: TX_AND_STORE


         TX_ONLY: begin

            // Assert the output push signal.
            out_push = 1'b1;

            read_addr_1 = {counter_F[0], counter_F[1], counter_F[2], counter_F[3]};

            // Increment the counter.
            counter = counter_F + 1;

            // If the counter is at 15...
            if (counter_F == 15) begin

               // Return to the RX_ONLY state.
               next_state = RX_ONLY;

            end

         end // case: TX_ONLY

      endcase

   end


   always @(posedge clk) begin

      if (reset == 1'b1) begin

         current_state_F <= RX_ONLY;

         in_stall_F <= 1'b1;

         read_addr_1_F <= 0;
         read_addr_2_F <= 0;
         W_addr_F <= 0;

         write_addr_1_F <= 0;
         write_data_1_F <= 0;
         write_en_1_F <= 1'b0;
         write_addr_2_F <= 0;
         write_en_2_F <= 1'b0;
         write_back_F <= 1'b0;

         out_push_F <= 1'b0;

         counter_F <= 0;
         stage_F <= 0;
         butterfly_F <= 0;
         skip_F <= 1'b0;
         skip_Fd2 <= 1'b0;
         skip_Fd3 <= 1'b0;
         skip_Fd4 <= 1'b0;

      end

      else begin

         current_state_F <= next_state;

         in_stall_F <= in_stall;

         read_addr_1_F <= read_addr_1;
         read_addr_2_F <= read_addr_2;
         W_addr_F <= W_addr;

         write_addr_1_F <= write_addr_1;
         write_data_1_F <= write_data_1;
         write_en_1_F <= write_en_1;
         write_addr_2_F <= write_addr_2;
         write_en_2_F <= write_en_2;
         write_back_F <= write_back;

         out_push_F <= out_push;

         counter_F <= counter;
         stage_F <= stage;
         butterfly_F <= butterfly;
         skip_F <= skip;
         skip_Fd2 <= skip_F;
         skip_Fd3 <= skip_Fd2;
         skip_Fd4 <= skip_Fd3;

         A_addr_F <= A_addr;
         A_addr_Fd2 <= A_addr_F;
         A_addr_Fd3 <= A_addr_Fd2;
         A_addr_Fd4 <= A_addr_Fd3;

         B_addr_F <= B_addr;
         B_addr_Fd2 <= B_addr_F;
         B_addr_Fd3 <= B_addr_Fd2;
         B_addr_Fd4 <= B_addr_Fd3;

      end

   end

endmodule
