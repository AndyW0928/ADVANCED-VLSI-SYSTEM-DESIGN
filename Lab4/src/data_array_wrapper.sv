module data_array_wrapper (
  input CK,
  input CS, 
  input OE,
  input [15:0] WEB,
  input [5:0] A,
  input [127:0] DI,
  output [127:0] DO
);

  logic [63:0] DO1_1, DO1_2, DO2_1, DO2_2;
  logic WEB1, WEB2;
  logic [127:0] BWEB_128bit_1, BWEB_128bit_2;
  logic [15:0] BWEB1, BWEB2;
  logic [127:0] DO1, DO2;

  assign DO1 = {DO1_1, DO1_2};
  assign DO2 = {DO2_1, DO2_2};

  assign DO = (A[5] == 1'b1)? DO2 : (A[5] == 1'b0)? DO1 : 22'b0;

  assign WEB1 = (BWEB1 == 16'b0)? 1'b1 : 1'b0;
  assign WEB2 = (BWEB2 == 16'b0)? 1'b1 : 1'b0;

  assign BWEB1 = (A[5] == 1'b0)? WEB : 16'b0;
  assign BWEB2 = (A[5] == 1'b1)? WEB : 16'b0;

  assign BWEB_128bit_1 = (WEB1)? 128'b0 : (~{{8{BWEB1[15:12]}},{8{BWEB1[11:8]}},{8{BWEB1[7:4]}},{8{BWEB1[3:0]}}});
  assign BWEB_128bit_2 = (WEB2)? 128'b0 : (~{{8{BWEB2[15:12]}},{8{BWEB2[11:8]}},{8{BWEB2[7:4]}},{8{BWEB2[3:0]}}});


  TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array1_1 (
    .CLK        (CK),
    .A          (A[4:0]),
    .CEB        (~CS),  // chip enable, active LOW
    .WEB        (WEB1),  // write:LOW, read:HIGH
    .BWEB       (BWEB_128bit_1[127:64]),  // bitwise write enable write:LOW
    .D          (DI[127:64]),  // Data into RAM
    .Q          (DO1_1),  // Data out of RAM
    .RTSEL      (),
    .WTSEL      (),
    .SLP        (),
    .DSLP       (),
    .SD         (),
    .PUDELAY    ()
  );
  
  
    TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array1_2 (
    .CLK        (CK),
    .A          (A[4:0]),
    .CEB        (~CS),  // chip enable, active LOW
    .WEB        (WEB1),  // write:LOW, read:HIGH
    .BWEB       (BWEB_128bit_1[63:0]),  // bitwise write enable write:LOW
    .D          (DI[63:0]),  // Data into RAM
    .Q          (DO1_2),  // Data out of RAM
    .RTSEL      (),
    .WTSEL      (),
    .SLP        (),
    .DSLP       (),
    .SD         (),
    .PUDELAY    ()
  );

  TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array2_1 (
    .CLK        (CK),
    .A          (A[4:0]),
    .CEB        (~CS),  // chip enable, active LOW
    .WEB        (WEB2),  // write:LOW, read:HIGH
    .BWEB       (BWEB_128bit_2[127:64]),  // bitwise write enable write:LOW
    .D          (DI[127:64]),  // Data into RAM
    .Q          (DO2_1),  // Data out of RAM
    .RTSEL      (),
    .WTSEL      (),
    .SLP        (),
    .DSLP       (),
    .SD         (),
    .PUDELAY    ()
  );
  
  TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array2_2 (
    .CLK        (CK),
    .A          (A[4:0]),
    .CEB        (~CS),  // chip enable, active LOW
    .WEB        (WEB2),  // write:LOW, read:HIGH
    .BWEB       (BWEB_128bit_2[63:0]),  // bitwise write enable write:LOW
    .D          (DI[63:0]),  // Data into RAM
    .Q          (DO2_2),  // Data out of RAM
    .RTSEL      (),
    .WTSEL      (),
    .SLP        (),
    .DSLP       (),
    .SD         (),
    .PUDELAY    ()
  );


endmodule
