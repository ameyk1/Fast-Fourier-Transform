//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name: Fast Fourier Transform (16-point) 
// Module Name: read_addr_lut
// Project Name: Fast Fourier Transform (16-point)
///////////////////////////////////////////////////////////////////////////
module read_addr_lut (
   input wire [1:0] stage,
   input wire [2:0] butterfly,
   output reg [3:0] A_addr,
   output reg [3:0] B_addr,
   output reg [2:0] W_addr
);

   always @(*) begin

      case (stage)

         0: begin
            case (butterfly)

               0: begin
                  A_addr = 0;
                  B_addr = 8;
                  W_addr = 0;
               end

               1: begin
                  A_addr = 4;
                  B_addr = 12;
                  W_addr = 0;
               end

               2: begin
                  A_addr = 2;
                  B_addr = 10;
                  W_addr = 0;
               end

               3: begin
                  A_addr = 6;
                  B_addr = 14;
                  W_addr = 0;
               end

               4: begin
                  A_addr = 1;
                  B_addr = 9;
                  W_addr = 0;
               end

               5: begin
                  A_addr = 5;
                  B_addr = 13;
                  W_addr = 0;
               end

               6: begin
                  A_addr = 3;
                  B_addr = 11;
                  W_addr = 0;
               end

               7: begin
                  A_addr = 7;
                  B_addr = 15;
                  W_addr = 0;
               end

            endcase
         end // case: 0

         1: begin
            case (butterfly)

               0: begin
                  A_addr = 0;
                  B_addr = 4;
                  W_addr = 0;
               end

               1: begin
                  A_addr = 8;
                  B_addr = 12;
                  W_addr = 4;
               end

               2: begin
                  A_addr = 2;
                  B_addr = 6;
                  W_addr = 0;
               end

               3: begin
                  A_addr = 10;
                  B_addr = 14;
                  W_addr = 4;
               end

               4: begin
                  A_addr = 1;
                  B_addr = 5;
                  W_addr = 0;
               end

               5: begin
                  A_addr = 9;
                  B_addr = 13;
                  W_addr = 4;
               end

               6: begin
                  A_addr = 3;
                  B_addr = 7;
                  W_addr = 0;
               end

               7: begin
                  A_addr = 11;
                  B_addr = 15;
                  W_addr = 4;
               end

            endcase
         end // case: 1

         2: begin
            case (butterfly)

               0: begin
                  A_addr = 0;
                  B_addr = 2;
                  W_addr = 0;
               end

               1: begin
                  A_addr = 8;
                  B_addr = 10;
                  W_addr = 2;
               end

               2: begin
                  A_addr = 4;
                  B_addr = 6;
                  W_addr = 4;
               end

               3: begin
                  A_addr = 12;
                  B_addr = 14;
                  W_addr = 6;
               end

               4: begin
                  A_addr = 1;
                  B_addr = 3;
                  W_addr = 0;
               end

               5: begin
                  A_addr = 9;
                  B_addr = 11;
                  W_addr = 2;
               end

               6: begin
                  A_addr = 5;
                  B_addr = 7;
                  W_addr = 4;
               end

               7: begin
                  A_addr = 13;
                  B_addr = 15;
                  W_addr = 6;
               end

            endcase
         end // case: 2

         3: begin
            case (butterfly)

               0: begin
                  A_addr = 0;
                  B_addr = 1;
                  W_addr = 0;
               end

               1: begin
                  A_addr = 8;
                  B_addr = 9;
                  W_addr = 1;
               end

               2: begin
                  A_addr = 4;
                  B_addr = 5;
                  W_addr = 2;
               end

               3: begin
                  A_addr = 12;
                  B_addr = 13;
                  W_addr = 3;
               end

               4: begin
                  A_addr = 2;
                  B_addr = 3;
                  W_addr = 4;
               end

               5: begin
                  A_addr = 10;
                  B_addr = 11;
                  W_addr = 5;
               end

               6: begin
                  A_addr = 6;
                  B_addr = 7;
                  W_addr = 6;
               end

               7: begin
                  A_addr = 14;
                  B_addr = 15;
                  W_addr = 7;
               end

            endcase
         end // case: 3

      endcase

   end

endmodule
