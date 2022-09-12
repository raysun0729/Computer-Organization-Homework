`timescale 1ns / 1ps

module alu_bottom(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               equal,      //1 bit equal    (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               comp,       //comparison     (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               overflow,   //1 bit overflow (output)
               cmp_result, //1 bit compare result(output)
               equal_out,  //1 bit equal out(output)
               );

input         src1;
input         src2;
input         less;
input         equal;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;
input [3-1:0] comp;

output        result;
output        overflow;
output        cout;
output        cmp_result;
output        equal_out;

reg           result;
reg           cout, overflow;
wire real_A, real_B;
assign real_A = src1 ^ A_invert; // it's A_invert ? ~src1 : src1
assign real_B = src2 ^ B_invert; // it's B_invert ? ~src2 : src2

reg less_reg;

// calculate the compare function
compare COMP(
  .less(less_reg),
  .equal(equal),
  .comp(comp),
  .cmp_result(cmp_result)
);

always@( * )
begin
  case (operation)
    0: result = real_A & real_B;
    1: result = real_A | real_B;
    2: result = real_A ^ real_B ^ cin;
    3: result = less;
  endcase
  cout = real_A & real_B | (real_A | real_B) & cin;
  less_reg = ~(src1 ^ src2) & ~cin | (src1 & ~src2);
  overflow = ~(real_A ^ real_B) & (real_A ^ result) & (operation[1] & ~operation[0]);
end

assign equal_out = ~(src1 ^ src2); // which means src1 == src2

endmodule