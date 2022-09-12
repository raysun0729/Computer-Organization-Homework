`timescale 1ns / 1ps

module compare(
               less,       //1 bit less     (input)
               equal,      //1 bit equal    (input)
               comp,       //comparison     (input)
               cmp_result, //1 bit compare result(output)
               );

input       less;
input       equal;
input [2:0] comp;
output      cmp_result;

reg cmp_result;

always @ ( * ) begin
  case (comp)
    3'b000: // less than
      cmp_result = less;
    3'b001: // greater than
      cmp_result = ~(less | equal);
    3'b010: // less than or equal
      cmp_result = less | equal;
    3'b011: // greater than or equal
      cmp_result = ~less;
    3'b110: // equal
      cmp_result = equal;
    3'b100: // not equal
      cmp_result = ~equal;
    default: cmp_result = less; // assume less than
  endcase
end

endmodule