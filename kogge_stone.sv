module kogge_stone_adder32(
input logic [31:0] a,
input logic [31:0] b,
output logic [31:0] out,
output logic [31:0] c_out,
output logic [31:0] p_out,
output logic [31:0] g_out);

logic [31:0] p;
logic [31:0] g;
logic [30:0] p_layer1;
logic [30:0] g_layer1;
logic [29:0] p_layer2;
logic [29:0] g_layer2;
logic [27:0] p_layer3;
logic [27:0] g_layer3;
logic [31:0] c;


generate
for(genvar i=0; i<32; i++) begin
assign p[i] = a[i] | b[i];
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

assign c[1] = g_layer1[0] | (c[0] & p_layer1[0]);
//assign out[1] = g[1] | (p[1] & c[1]);

//layer 2
assign p_layer2[0] = p[0] & p_layer1[1];
assign g_layer2[0] = g_layer1[1] | (p_layer1[1] & g[0]);

generate
for(genvar i=1; i <30; i++) begin
assign p_layer2[i] = p_layer1[i+1] & p_layer1[i-1];
assign g_layer2[i] = (p_layer1[i+1] & g_layer1[i-1]) | g_layer1[i+1];
end
endgenerate

assign c[2] = g_layer2[0] | (c[1] & p_layer2[0]);
assign c[3] = g_layer2[1] | (c[1] & p_layer2[0]);

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
//c layer
generate
for(genvar i=4; i <32; i++) begin
assign c[i] = g_layer3[i] | (c[i-1] & p_layer3[i]);
end
endgenerate

//sum layer
generate
for(genvar i=1; i <32; i++) begin
assign out[i] = p[i] ^ c[i-1];
end
endgenerate

generate
for(genvar i=1; i <32; i++) begin
assign c_out[i] = c[i];
assign p_out[i] = p[i];
assign g_out[i] = g[i];
end
endgenerate

endmodule