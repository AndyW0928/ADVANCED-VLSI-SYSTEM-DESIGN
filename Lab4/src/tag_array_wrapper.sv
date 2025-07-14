module tag_array_wrapper (
 input CK,
  input CS,
  input OE,
  input WEB,
  input [5:0] A,
  input [21:0] DI,
  output [21:0] DO
);

  logic [31:0] DO1, DO2;

  assign DO = (A[5] == 1'b1)? DO2[22:0] : (A[5] == 1'b0)? DO1[22:0] : 22'b0;

  assign WEB1 = (A[5] == 1'b0)? WEB : 1'b0;
  assign WEB2 = (A[5] == 1'b1)? WEB : 1'b0;

  TS1N16ADFPCLLLVTA128X64M4SWSHOD_tag_array i_tag_array1 (
    .CLK        (CK),
    .A          (A[4:0]),
    .CEB        (~CS),  // chip enable, active LOW
    .WEB        (~WEB1),  // write:LOW, read:HIGH
    .BWEB       ({{10{1'b1}},{22{1'b0}}}),  // bitwise write enable write:LOW
    .D          ({{10{1'b0}},DI}),  // Data into RAM
    .Q          (DO1),  // Data out of RAM
    .RTSEL      (),
    .WTSEL      (),
    .SLP        (),
    .DSLP       (),
    .SD         (),
    .PUDELAY    ()
  );

  TS1N16ADFPCLLLVTA128X64M4SWSHOD_tag_array i_tag_array2 (
    .CLK        (CK),
    .A          (A[4:0]),
    .CEB        (~CS),  // chip enable, active LOW
    .WEB        (~WEB2),  // write:LOW, read:HIGH
    .BWEB       ({{10{1'b1}},{22{1'b0}}}),  // bitwise write enable write:LOW
    .D          ({{10{1'b0}},DI}),  // Data into RAM
    .Q          (DO2),  // Data out of RAM
    .RTSEL      (),
    .WTSEL      (),
    .SLP        (),
    .DSLP       (),
    .SD         (),
    .PUDELAY    ()
  );

endmodule
