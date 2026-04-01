module kogge_stone_adder32(
input logic [31:0] a,
input logic [31:0] b,
output logic [31:0] out);

logic [31:0] p;
logic [31:0] g;
logic [30:0] p_layer1;
logic [30:0] g_layer1;
logic [29:0] p_layer2;
logic [29:0] g_layer2;
logic [27:0] p_layer3;
logic [27:0] g_layer3;
logic [23:0] p_layer4;
logic [23:0] g_layer4;
logic [15:0] p_layer5;
logic [15:0] g_layer5;
logic [31:0] c;

//pre processing stage
generate
for(genvar i=0; i<32; i++) begin
assign p[i] = a[i] ^ b[i];
assign g[i] = a[i] & b[i];
end
endgenerate

assign c[0] = g[0];
assign out[0] = p[0];
//assign out[0] = g[0] | (p[0] & c[0]);

//layer 1
generate
for(genvar i=0; i <31; i++) begin
assign p_layer1[i] = p[i+1] & p[i];
assign g_layer1[i] = (p[i+1] & g[i]) | g[i+1];
end
endgenerate




//layer 2
assign p_layer2[0] = p[0] & p_layer1[1];
assign g_layer2[0] = g_layer1[1] | (p_layer1[1] & g[0]);

generate
for(genvar i=1; i <30; i++) begin
assign p_layer2[i] = p_layer1[i+1] & p_layer1[i-1];
assign g_layer2[i] = (p_layer1[i+1] & g_layer1[i-1]) | g_layer1[i+1];
end
endgenerate



//layer 3
assign p_layer3[0] = p[0] & p_layer2[2];
assign g_layer3[0] = g_layer2[2] | (p_layer2[2] & g[0]);
assign p_layer3[1] = p_layer1[0] & p_layer2[3];
assign g_layer3[1] = g_layer2[3] | (p_layer2[3] & g_layer1[0]);

generate
for(genvar i=2; i <28; i++) begin
assign p_layer3[i] = p_layer2[i+2] & p_layer2[i-2];
assign g_layer3[i] = (p_layer2[i+2] & g_layer2[i-2]) | g_layer2[i+2];
end
endgenerate

//layer 4
assign p_layer4[0] = p[0] & p_layer3[4];
assign g_layer4[0] = g_layer3[4] | (p_layer3[4] & g[0]);
assign p_layer4[1] = p_layer1[0] & p_layer3[5];
assign g_layer4[1] = g_layer3[5] | (p_layer3[5] & g_layer1[0]);
assign p_layer4[2] = p_layer2[0] & p_layer3[6];
assign g_layer4[2] = g_layer3[6] | (p_layer3[6] & g_layer2[0]);
assign p_layer4[3] = p_layer2[1] & p_layer3[7];
assign g_layer4[3] = g_layer3[7] | (p_layer3[7] & g_layer2[1]);

generate
for(genvar i=4; i <24; i++) begin
assign p_layer4[i] = p_layer3[i+4] & p_layer3[i-4];
assign g_layer4[i] = (p_layer3[i+4] & g_layer3[i-4]) | g_layer3[i+4];
end
endgenerate

//layer 5
assign p_layer5[0] = p[0] & p_layer4[8];
assign g_layer5[0] = g_layer4[8] | (p_layer4[8] & g[0]);
assign p_layer5[1] = p_layer1[0] & p_layer4[9];
assign g_layer5[1] = g_layer4[9] | (p_layer4[9] & g_layer1[0]);
assign p_layer5[2] = p_layer2[0] & p_layer4[10];
assign g_layer5[2] = g_layer4[10] | (p_layer4[10] & g_layer2[0]);
assign p_layer5[3] = p_layer2[1] & p_layer4[11];
assign g_layer5[3] = g_layer4[11] | (p_layer4[11] & g_layer2[1]);
assign p_layer5[4] = p_layer3[0] & p_layer4[12];
assign g_layer5[4] = g_layer4[12] | (p_layer4[12] & g_layer3[0]);
assign p_layer5[5] = p_layer3[1] & p_layer4[13];
assign g_layer5[5] = g_layer4[13] | (p_layer4[13] & g_layer3[1]);
assign p_layer5[6] = p_layer3[2] & p_layer4[14];
assign g_layer5[6] = g_layer4[14] | (p_layer4[14] & g_layer3[2]);
assign p_layer5[7] = p_layer3[3] & p_layer4[15];
assign g_layer5[7] = g_layer4[15] | (p_layer4[15] & g_layer3[3]);

generate
for(genvar i=8; i <16; i++) begin
assign p_layer5[i] = p_layer4[i+8] & p_layer4[i-8];
assign g_layer5[i] = (p_layer4[i+8] & g_layer4[i-8]) | g_layer4[i+8];
end
endgenerate

//c layer
generate
for(genvar i=16; i <32; i++) begin
//Ci – 1 = (Pi and Cin) or Gi
assign c[i] = g_layer5[i-16];
end
endgenerate

generate
for(genvar i=8; i <16; i++) begin
assign c[i] = g_layer4[i-8];
end
endgenerate

generate
for(genvar i=4; i <8; i++) begin
assign c[i] = g_layer3[i-4];
end
endgenerate

generate
for(genvar i=2; i <4; i++) begin
assign c[i] = g_layer2[i-2];
end
endgenerate

assign c[1] = g_layer1[0];




//sum layer
generate
for(genvar i=1; i <32; i++) begin
assign out[i] = p[i] ^ c[i-1];
end
endgenerate


endmodule