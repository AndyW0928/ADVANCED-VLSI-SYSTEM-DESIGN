module cmat_inv(
	input wire clk,rst_n,vld_in,
	input wire [15:0] a11_re,a12_re,a13_re,a14_re,a21_re,a22_re,a23_re,a24_re,a31_re,a32_re,a33_re,a34_re,a41_re,a42_re,a43_re,a44_re,
	input wire [15:0] a11_im,a12_im,a13_im,a14_im,a21_im,a22_im,a23_im,a24_im,a31_im,a32_im,a33_im,a34_im,a41_im,a42_im,a43_im,a44_im,
	output reg vld_out=1'b0,
	output reg [23:0] b11_re,b12_re,b13_re,b14_re,b21_re,b22_re,b23_re,b24_re,b31_re,b32_re,b33_re,b34_re,b41_re,b42_re,b43_re,b44_re,
	output reg [23:0] b11_im,b12_im,b13_im,b14_im,b21_im,b22_im,b23_im,b24_im,b31_im,b32_im,b33_im,b34_im,b41_im,b42_im,b43_im,b44_im
    );
    
    reg signed [23:0] c11,c12,c13,c14,c21,c22,c23,c24,c31,c32,c33,c34,c41,c42,c43,c44;
    reg signed [23:0] d11,d12,d13,d14,d21,d22,d23,d24,d31,d32,d33,d34,d41,d42,d43,d44;
    
    always @(clk or ~rst_n ) 
    begin
        if(vld_in==1) begin
         c11= {{8{a11_re[15]}},a11_re};
         c12= {{8{a12_re[15]}},a12_re};
         c13= {{8{a13_re[15]}},a13_re};
         c14= {{8{a14_re[15]}},a14_re};
         c21= {{8{a21_re[15]}},a21_re};
         c22= {{8{a22_re[15]}},a22_re};
         c23= {{8{a23_re[15]}},a23_re};
         c24= {{8{a24_re[15]}},a24_re};
         c31= {{8{a31_re[15]}},a31_re};
         c32= {{8{a32_re[15]}},a32_re};
         c33= {{8{a33_re[15]}},a33_re};
         c34= {{8{a34_re[15]}},a34_re};
         c41= {{8{a41_re[15]}},a41_re};
         c42= {{8{a42_re[15]}},a42_re};
         c43= {{8{a43_re[15]}},a43_re};
         c44= {{8{a44_re[15]}},a44_re};
        
         d11= {{8{a11_im[15]}},a11_im};
         d12= {{8{a12_im[15]}},a12_im};
         d13= {{8{a13_im[15]}},a13_im};
         d14= {{8{a14_im[15]}},a14_im};
         d21= {{8{a21_im[15]}},a21_im};
         d22= {{8{a22_im[15]}},a22_im};
         d23= {{8{a23_im[15]}},a23_im};
         d24= {{8{a24_im[15]}},a24_im};
         d31= {{8{a31_im[15]}},a31_im};
         d32= {{8{a32_im[15]}},a32_im};
         d33= {{8{a33_im[15]}},a33_im};
         d34= {{8{a34_im[15]}},a34_im};
         d41= {{8{a41_im[15]}},a41_im};
         d42= {{8{a42_im[15]}},a42_im};
         d43= {{8{a43_im[15]}},a43_im};
         d44= {{8{a44_im[15]}},a44_im};
         vld_out=0;
        end
        else begin
            vld_out=1;
        end
    end
    
    wire signed [23:0] A,B;
    
det_44 det_44_u0(
                  .clk(clk),
                  .rst_n(rst_n),
                  .a11(c11),
                  .a12(c12),
                  .a13(c13),
                  .a14(c14),
                  .a21(c21),
                  .a22(c22),
                  .a23(c23),
                  .a24(c24),
                  .a31(c31),
                  .a32(c32),
                  .a33(c33),
                  .a34(c34),
                  .a41(c41),
                  .a42(c42),
                  .a43(c43),
                  .a44(c44),
                  .b(A)
);

det_44 det_44_u1(
                  .clk(clk),
                  .rst_n(rst_n),
                  .a11(d11),
                  .a12(d12),
                  .a13(d13),
                  .a14(d14),
                  .a21(d21),
                  .a22(d22),
                  .a23(d23),
                  .a24(d24),
                  .a31(d31),
                  .a32(d32),
                  .a33(d33),
                  .a34(d34),
                  .a41(d41),
                  .a42(d42),
                  .a43(d43),
                  .a44(d44),
                  .b(B)
);

wire signed [23:0] e11,e12,e13,e14,e21,e22,e23,e24,e31,e32,e33,e34,e41,e42,e43,e44;
reg signed [23:0] E11,E12,E13,E14,E21,E22,E23,E24,E31,E32,E33,E34,E41,E42,E43,E44;
wire signed [23:0] f11,f12,f13,f14,f21,f22,f23,f24,f31,f32,f33,f34,f41,f42,f43,f44;
reg signed [23:0] F11,F12,F13,F14,F21,F22,F23,F24,F31,F32,F33,F34,F41,F42,F43,F44;
wire signed [23:0] g11,g12,g13,g14,g21,g22,g23,g24,g31,g32,g33,g34,g41,g42,g43,g44;
reg signed [23:0] G11,G12,G13,G14,G21,G22,G23,G24,G31,G32,G33,G34,G41,G42,G43,G44;
wire signed [23:0] h11,h12,h13,h14,h21,h22,h23,h24,h31,h32,h33,h34,h41,h42,h43,h44;
reg signed [23:0] H11,H12,H13,H14,H21,H22,H23,H24,H31,H32,H33,H34,H41,H42,H43,H44;

inv_44 inv_44_u2(
                    .clk(clk),
                    .rst_n(rst_n),
                    .a11(c11),
                    .a12(c12),
                    .a13(c13),
                    .a14(c14),
                    .a21(c21),
                    .a22(c22),
                    .a23(c23),
                    .a24(c24),
                    .a31(c31),
                    .a32(c32),
                    .a33(c33),
                    .a34(c34),
                    .a41(c41),
                    .a42(c42),
                    .a43(c43),
                    .a44(c44),
                    .b11(e11),
                    .b12(e12),
                    .b13(e13),
                    .b14(e14),
                    .b21(e21),
                    .b22(e22),
                    .b23(e23),
                    .b24(e24),
                    .b31(e31),
                    .b32(e32),
                    .b33(e33),
                    .b34(e34),
                    .b41(e41),
                    .b42(e42),
                    .b43(e43),
                    .b44(e44)
);

always @(clk or ~rst_n ) 
begin
        E11=e11;
        E12=e12;
        E13=e13;
        E14=e14;
        E21=e21;
        E22=e22;
        E23=e23;
        E24=e24;
        E31=e31;
        E32=e32;
        E33=e33;
        E34=e34;
        E41=e41;
        E42=e42;
        E43=e43;
        E44=e44;
end  
    
ml_44 ml_44_u3(
    .clk(clk),.rst_n(rst_n),
    .a11(d11),.a12(d12),.a13(d13),.a14(d14),.a21(d21),.a22(d22),.a23(d23),.a24(d24),.a31(d31),.a32(d32),.a33(d33),.a34(d34),.a41(d41),.a42(d42),.a43(d43),.a44(d44),
    .b11(E11),.b12(E12),.b13(E13),.b14(E14),.b21(E21),.b22(E22),.b23(E23),.b24(E24),.b31(E31),.b32(E32),.b33(E33),.b34(E34),.b41(E41),.b42(E42),.b43(E43),.b44(E44),
    .c11(f11),.c12(f12),.c13(f13),.c14(f14),.c21(f21),.c22(f22),.c23(f23),.c24(f24),.c31(f31),.c32(f32),.c33(f33),.c34(f34),.c41(f41),.c42(f42),.c43(f43),.c44(f44)
  );  
    
always @(clk or ~rst_n ) 
begin
        F11=f11;
        F12=f12;
        F13=f13;
        F14=f14;
        F21=f21;
        F22=f22;
        F23=f23;
        F24=f24;
        F31=f31;
        F32=f32;
        F33=f33;
        F34=f34;
        F41=f41;
        F42=f42;
        F43=f43;
        F44=f44;
end  
    
 ml_44 ml_44_u4(
    .clk(clk),.rst_n(rst_n),
    .a11(F11),.a12(F12),.a13(F13),.a14(F14),.a21(F21),.a22(F22),.a23(F23),.a24(F24),.a31(F31),.a32(F32),.a33(F33),.a34(F34),.a41(F41),.a42(F42),.a43(F43),.a44(F44),
    .b11(d11),.b12(d12),.b13(d13),.b14(d14),.b21(d21),.b22(d22),.b23(d23),.b24(d24),.b31(d31),.b32(d32),.b33(d33),.b34(d34),.b41(d41),.b42(d42),.b43(d43),.b44(d44),
    .c11(g11),.c12(g12),.c13(g13),.c14(g14),.c21(g21),.c22(g22),.c23(g23),.c24(g24),.c31(g31),.c32(g32),.c33(g33),.c34(g34),.c41(g41),.c42(g42),.c43(g43),.c44(g44)
  );  
        
always @(clk or ~rst_n ) 
begin
        G11=g11;
        G12=g12;
        G13=g13;
        G14=g14;
        G21=g21;
        G22=g22;
        G23=g23;
        G24=g24;
        G31=g31;
        G32=g32;
        G33=g33;
        G34=g34;
        G41=g41;
        G42=g42;
        G43=g43;
        G44=g44;
end  

inv_44 inv_44_u5(
    .clk(clk),.rst_n(rst_n),
    .a11(c11+G11),.a12(c12+G12),.a13(c13+G13),.a14(c14+G14),.a21(c21+G21),.a22(c22+G22),.a23(c23+G23),.a24(c24+G24),
    .a31(c31+G31),.a32(c32+G32),.a33(c33+G33),.a34(c34+G34),.a41(c41+G41),.a42(c42+G42),.a43(c43+G43),.a44(c44+G44),
    .b11(h11),.b12(h12),.b13(h13),.b14(h14),.b21(h21),.b22(h22),.b23(h23),.b24(h24),.b31(h31),.b32(h32),.b33(h33),.b34(h34),.b41(h41),.b42(h42),.b43(h43),.b44(h44)
);   

always @(clk or ~rst_n ) 
begin
        H11=h11;
        H12=h12;
        H13=h13;
        H14=h14;
        H21=h21;
        H22=h22;
        H23=h23;
        H24=h24;
        H31=h31;
        H32=h32;
        H33=h33;
        H34=h34;
        H41=h41;
        H42=h42;
        H43=h43;
        H44=h44;
end  

wire signed [23:0] i11,i12,i13,i14,i21,i22,i23,i24,i31,i32,i33,i34,i41,i42,i43,i44;
reg signed [23:0] I11,I12,I13,I14,I21,I22,I23,I24,I31,I32,I33,I34,I41,I42,I43,I44;
wire signed [23:0] j11,j12,j13,j14,j21,j22,j23,j24,j31,j32,j33,j34,j41,j42,j43,j44;
reg signed [23:0] J11,J12,J13,J14,J21,J22,J23,J24,J31,J32,J33,J34,J41,J42,J43,J44;

ml_44 ml_44_u6(
      .clk(clk),.rst_n(rst_n),
    .a11(e11),.a12(e12),.a13(e13),.a14(e14),.a21(e21),.a22(e22),.a23(e23),.a24(e24),.a31(e31),.a32(e32),.a33(e33),.a34(e34),.a41(e41),.a42(e42),.a43(e43),.a44(e44),
    .b11(d11),.b12(d12),.b13(d13),.b14(d14),.b21(d21),.b22(d22),.b23(d23),.b24(d24),.b31(d31),.b32(d32),.b33(d33),.b34(d34),.b41(d41),.b42(d42),.b43(d43),.b44(d44),
    .c11(i11),.c12(i12),.c13(i13),.c14(i14),.c21(i21),.c22(i22),.c23(i23),.c24(i24),.c31(i31),.c32(i32),.c33(i33),.c34(i34),.c41(i41),.c42(i42),.c43(i43),.c44(i44)
  );  
        
always @(clk or ~rst_n ) 
begin
        I11=i11;
        I12=i12;
        I13=i13;
        I14=i14;
        I21=i21;
        I22=i22;
        I23=i23;
        I24=i24;
        I31=i31;
        I32=i32;
        I33=i33;
        I34=i34;
        I41=i41;
        I42=i42;
        I43=i43;
        I44=i44;
end  

ml_44 ml_44_u7(
    .clk(clk),.rst_n(rst_n),
    .a11(I11),.a12(I12),.a13(I13),.a14(I14),.a21(I21),.a22(I22),.a23(I23),.a24(I24),.a31(I31),.a32(I32),.a33(I33),.a34(I34),.a41(I41),.a42(I42),.a43(I43),.a44(I44),
    .b11(H11),.b12(H12),.b13(H13),.b14(H14),.b21(H21),.b22(H22),.b23(H23),.b24(H24),.b31(H31),.b32(H32),.b33(H33),.b34(H34),.b41(H41),.b42(H42),.b43(H43),.b44(H44),
    .c11(j11),.c12(j12),.c13(j13),.c14(j14),.c21(j21),.c22(j22),.c23(j23),.c24(j24),.c31(j31),.c32(j32),.c33(j33),.c34(j34),.c41(j41),.c42(j42),.c43(j43),.c44(j44)
  );  
        
always @(clk or ~rst_n ) 
begin
        J11=j11;
        J12=j12;
        J13=j13;
        J14=j14;
        J21=j21;
        J22=j22;
        J23=j23;
        J24=j24;
        J31=j31;
        J32=j32;
        J33=j33;
        J34=j34;
        J41=j41;
        J42=j42;
        J43=j43;
        J44=j44;
end  
    
    
always @(clk or ~rst_n )
begin
    if(vld_out==1) begin
        if ((A==0)||(B==0)) begin
            b11_im=0;
            b12_im=0;
            b13_im=0;
            b14_im=0;
            b21_im=0;
            b22_im=0;
            b23_im=0;
            b24_im=0;
            b31_im=0;
            b32_im=0;
            b33_im=0;
            b34_im=0;
            b41_im=0;
            b42_im=0;
            b43_im=0;
            b44_im=0;
            b11_re=0;
            b12_re=0;
            b13_re=0;
            b14_re=0;
            b21_re=0;
            b22_re=0;
            b23_re=0;
            b24_re=0;
            b31_re=0;
            b32_re=0;
            b33_re=0;
            b34_re=0;
            b41_re=0;
            b42_re=0;
            b43_re=0;
            b44_re=0;
        end
        else begin
            b11_re=h11;
            b12_re=h12;
            b13_re=h13;
            b14_re=h14;
            b21_re=h21;
            b22_re=h22;
            b23_re=h23;
            b24_re=h24;
            b31_re=h31;
            b32_re=h32;
            b33_re=h33;
            b34_re=h34;
            b41_re=h41;
            b42_re=h42;
            b43_re=h43;
            b44_re=h44;
            
            b11_im=-j11;
            b12_im=-j12;
            b13_im=-j13;
            b14_im=-j14;
            b21_im=-j21;
            b22_im=-j22;
            b23_im=-j23;
            b24_im=-j24;
            b31_im=-j31;
            b32_im=-j32;
            b33_im=-j33;
            b34_im=-j34;
            b41_im=-j41;
            b42_im=-j42;
            b43_im=-j43;
            b44_im=-j44;
        end
    end
end

endmodule


 

