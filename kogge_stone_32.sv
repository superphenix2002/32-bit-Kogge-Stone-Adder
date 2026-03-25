module kogge_stone_adder32(
input logic [31:0] a,
input logic [31:0] b,
output logic [31:0] out);

wire logic [31:0] p;
wire logic [31:0] g;
wire logic [30:0] p_layer1;
wire logic [30:0] g_layer1;
wire logic [29:0] p_layer2;
wire logic [29:0] g_layer2;
wire logic [27:0] p_layer3;
wire logic [27:0] g_layer3;
wire logic [31:0] c;

for(int i=0; i<32; i++) begin
assign p[i] = a[i] | b[i];
assign g[i] = a[i] & b[i];
end

assign c[0] = g[0];
assign out[0] = p[0];
//assign out[0] = g[0] | (p[0] & c[0]);

//layer 1
for(int i=0; i <31; i++)begin
assign p_layer1[i] = p[i+1] & p[i];
assign g_layer1[i] = (p[i+1] & g[i]) | g[i+1];
end

assign c[1] = g_layer1[0] | (c[0] & p_layer1[0]);
//assign out[1] = g[1] | (p[1] & c[1]);

//layer 2
assign p_layer2[0] = p[0] & p_layer1[1];
assign g_layer2[0] = g_layer1[1] | (p_layer1[1] & g[0]);

for(int i=1; i <30; i++)begin
assign p_layer2[i] = p_layer1[i+1] & p_layer1[i-1];
assign g_layer2[i] = (p_layer1[i+1] & g_layer1[i-1]) | g_layer1[i+1];
end

assign c[2] = g_layer2[0] | (c[1] & p_layer2[0]);
assign c[3] = g_layer2[1] | (c[1] & p_layer2[0]);

//layer 3
assign p_layer3[0] = p[0] & p_layer2[2];
assign g_layer3[0] = g_layer2[2] | (p_layer2[2] & g[0]);
assign p_layer3[1] = p_layer1[0] & p_layer2[3];
assign g_layer3[0] = g_layer2[3] | (p_layer2[3] & g_layer1[0]);

for(int i=2; i <28; i++)begin
assign p_layer3[i] = p_layer2[i+2] & p_layer2[i-2];
assign g_layer3[i] = (p_layer2[i+2] & g_layer2[i-2]) | g_layer2[i+2];
end

//c layer
for(int i=4; i <32; i++)begin
assign c[i] = g_layer3[i] | (c[i-1] & p_layer3[i]);
end

//sum layer
for(int i=1; i <32; i++)begin
assign out[i] = p[i] ^ c[i-1];
end

endmodule