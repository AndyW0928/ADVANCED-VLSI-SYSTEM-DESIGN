
module inv_44(
	input wire clk,rst_n,
	input wire signed [23:0] a11,a12,a13,a14,a21,a22,a23,a24,a31,a32,a33,a34,a41,a42,a43,a44,
	output reg signed [23:0] b11,b12,b13,b14,b21,b22,b23,b24,b31,b32,b33,b34,b41,b42,b43,b44
);

reg signed [23:0] e11,e12,e21,e22;
wire signed [23:0] f11,f12,f21,f22;
wire signed [23:0] h11,h12,h21,h22;

wire signed [23:0] g11,g12,g21,g22;

wire signed [23:0] B11,B12,B21,B22;

wire signed [23:0] A11,A12,A21,A22;
reg signed [23:0] C11,C12,C21,C22;
reg signed [23:0] D11,D12,D21,D22;
reg signed [23:0] F11,F12,F21,F22;

wire signed [23:0] i11,i12,i21,i22;
wire signed [23:0] j11,j12,j21,j22;
reg signed [23:0] I11,I12,I21,I22;
reg signed [23:0] J11,J12,J21,J22;

inv_22 inv_22_u1(
    .a(a33),.b(a34),.c(a43),.d(a44),
    .b11(B11),.b12(B12),.b21(B21),.b22(B22)
    );
always @(clk or ~rst_n ) 
begin
    C11=B11;
    C12=B12;
    C21=B21;
    C22=B22;
end  

ml_22 ml_22_u1(
    .a(a13),.b(a14),.c(a23),.d(a24),
    .a1(C11),.b1(C12),.c1(C21),.d1(C22),
    .b11(f11),.b12(f12),.b21(f21),.b22(f22)
    );

always @(clk or ~rst_n )
begin
    F11=f11;
    F12=f12;
    F21=f21;
    F22=f22;
end  

ml_22 ml_22_u2(
    .a(F11),.b(F12),.c(F21),.d(F22),
    .a1(a31),.b1(a32),.c1(a41),.d1(a42),
    .b11(g11),.b12(g12),.b21(g21),.b22(g22)
    );
    
always @(clk or ~rst_n ) 
begin
    e11=a11-g11;
    e12=a12-g12;
    e21=a21-g21;
    e22=a22-g22;
end 

inv_22 inv_22_u2(
    .a(e11),.b(e12),.c(e21),.d(e22),
    .b11(h11),.b12(h12),.b21(h21),.b22(h22)
    );
    
always @(clk or ~rst_n ) 
begin
    b11=h11;
    b12=h12;
    b21=h21;
    b22=h22;
end 

ml_22 ml_22_u3(
    .a(b11),.b(b12),.c(b21),.d(b22),
    .a1(a13),.b1(a14),.c1(a23),.d1(a24),
    .b11(i11),.b12(i12),.b21(i21),.b22(i22)
    );
    
always @(clk or ~rst_n ) 
begin
    I11=i11;
    I12=i12;
    I21=i21;
    I22=i22;
end 

ml_22 ml_22_u4(
    .a(I11),.b(I12),.c(I21),.d(I22),
    .a1(C11),.b1(C12),.c1(C21),.d1(C22),
    .b11(j11),.b12(j12),.b21(j21),.b22(j22)
    );
        
always @(clk or ~rst_n ) 
begin
    b13=-j11;
    b14=-j12;
    b23=-j21;
    b24=-j22;
end 

wire signed [23:0] k11,k12,k21,k22;
wire signed [23:0] l11,l12,l21,l22;
reg signed [23:0] K11,K12,K21,K22;
reg signed [23:0] L11,L12,L21,L22;

ml_22 ml_22_u5(
    .a(C11),.b(C12),.c(C21),.d(C22),
    .a1(a31),.b1(a32),.c1(a41),.d1(a42),
    .b11(k11),.b12(k12),.b21(k21),.b22(k22)
    );
    
always @(clk or ~rst_n ) 
begin
    K11=k11;
    K12=k12;
    K21=k21;
    K22=k22;
end  
    
    
ml_22 ml_22_u6(
    .a(K11),.b(K12),.c(K21),.d(K22),
    .a1(b11),.b1(b12),.c1(b21),.d1(b22),
    .b11(A11),.b12(A12),.b21(A21),.b22(A22)
    );
        
always @(clk or ~rst_n ) 
begin
    b31=-A11;
    b32=-A12;
    b41=-A21;
    b42=-A22;
end 

ml_22 ml_22_u7(
    .a(C11),.b(C12),.c(C21),.d(C22),
    .a1(a31),.b1(a32),.c1(a41),.d1(a42),
    .b11(l11),.b12(l12),.b21(l21),.b22(l22)
    );
    
always @(clk or ~rst_n ) 
begin
    L11=l11;
    L12=l12;
    L21=l21;
    L22=l22;
end  

wire signed [23:0] m11,m12,m21,m22;
wire signed [23:0] n11,n12,n21,n22;
reg signed [23:0] M11,M12,M21,M22;
reg signed [23:0] N11,N12,N21,N22;
wire signed [23:0] q11,q12,q21,q22;
reg signed [23:0] Q11,Q12,Q21,Q22;

ml_22 ml_22_u8(
    .a(L11),.b(L12),.c(L21),.d(L22),
    .a1(b11),.b1(b12),.c1(b21),.d1(b22),
    .b11(m11),.b12(m12),.b21(m21),.b22(m22)
    );
    
always @(clk or ~rst_n ) 
begin
    M11=m11;
    M12=m12;
    M21=m21;
    M22=m22;
end  
    ml_22 ml_22_u9(
    .a(M11),.b(M12),.c(M21),.d(M22),
    .a1(a13),.b1(a14),.c1(a23),.d1(a24),
    .b11(n11),.b12(n12),.b21(n21),.b22(n22)
    );
    
always @(clk or ~rst_n ) 
begin
    N11=n11;
    N12=n12;
    N21=n21;
    N22=n22;
end  
    
ml_22 ml_22_u10(
    .a(N11),.b(N12),.c(N21),.d(N22),
    .a1(B11),.b1(B12),.c1(B21),.d1(B22),
    .b11(q11),.b12(q12),.b21(q21),.b22(q22)
    );
    
always @(clk or ~rst_n ) 
begin
    b33=C11+q11;
    b34=C12+q12;
    b43=C21+q21;
    b44=C22+q22;
end 

endmodule