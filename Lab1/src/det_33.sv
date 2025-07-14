module det_33(

	input wire signed [23:0] a11,a12,a13,a21,a22,a23,a31,a32,a33,

	output reg signed [23:0] b

    );
    
    reg signed [71:0] c1,c2,c3,c4,c5,c6,c,d;
    
    always @(*) 
    begin
        c1=a11*a22*a33;
        c2=a12*a23*a31;
        c3=a13*a21*a32;
        c4=a13*a22*a31;
        c5=a12*a21*a33;
        c6=a11*a23*a32;
        c=c1+c2+c3-c4-c5-c6;
     
        d={{30{c[71]}},c[71:30]};
        b=d[23:0];
    end
    
endmodule
