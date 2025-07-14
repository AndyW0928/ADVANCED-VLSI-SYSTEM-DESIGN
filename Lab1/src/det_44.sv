module det_44(
    input wire clk,rst_n,
	input wire signed [23:0] a11,a12,a13,a14,a21,a22,a23,a24,a31,a32,a33,a34,a41,a42,a43,a44,
	//output reg vld_out=1'b0,
	output reg [23:0] b


    );
    wire signed [23:0] c1,c2,c3,c4;
    reg signed [23:0] C1,C2,C3,C4;
    
    reg signed [47:0] D1,D2,D3,D4,D,c;
    det_33 det_33_u1(
     .a11(a22),.a12(a23),.a13(a24),.a21(a32),.a22(a33),.a23(a34),.a31(a42),.a32(a43),.a33(a44), 
     .b(c1)
    );
    
    det_33 det_33_u2(
     .a11(a12),.a12(a13),.a13(a14),.a21(a32),.a22(a33),.a23(a34),.a31(a42),.a32(a43),.a33(a44), 
     .b(c2)
    );
    
    det_33 det_33_u3(
     .a11(a12),.a12(a13),.a13(a14),.a21(a22),.a22(a23),.a23(a24),.a31(a42),.a32(a43),.a33(a44), 
     .b(c3)
    );
    
    det_33 det_33_u4(
     .a11(a12),.a12(a13),.a13(a14),.a21(a22),.a22(a23),.a23(a24),.a31(a32),.a32(a33),.a33(34), 
     .b(c4)
    );    
    
    always @(clk or ~rst_n ) 
    begin
        D1=a11*c1;
        D2=a21*c2;
        D3=a31*c3;
        D4=a41*c4;
        D=D1-D2+D3-D4;
        c={{15{D[47]}},D[47:15]};
        b=c[23:0];
    
    end  
        
    
endmodule