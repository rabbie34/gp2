float4x4 matWorld:WORLD<string UIWidget="None";>;
float4x4 matView:VIEW<string UIWidget="None";>;
float4x4 matProjection:PROJECTION<string UIWidget="None";>;
float4 ambientMaterial
<
	string UIName="Ambient Material";
	string UIWidget="Color";
>;
float4 ambientLightColour
<
	string UIName="Ambient Light Colour";
	string UIWidget="Color";
>;
float4 lightDirection:DIRECTION<string Object = "DirectionalLight";string UIWidget="None";>;
float4 diffuseMaterial
<
	string UIName="Diffuse Material";
	string UIWidget="Color";
>;
float4 diffuseLightColour:DIFFUSE<string Object = "DiffuseLight";string UIWidget="None";>;

struct VS_INPUT
{
	float4 pos:POSITION;
	float4 colour:COLOR;
	float3 normal:NORMAL;
};

struct PS_INPUT
{
	float4 pos:SV_POSITION;
	float4 colour:COLOR;
	float3 normal:NORMAL;
};

PS_INPUT VS(VS_INPUT input)
{
	PS_INPUT output=(PS_INPUT)0;
	
	float4x4 matViewProjection=mul(matView,matProjection);
	float4x4 matWorldViewProjection=mul(matWorld,matViewProjection);
	
	output.pos=mul(input.pos,matWorldViewProjection);
	output.colour = input.colour;
	output.normal = mul(input.normal,matWorld);
	return output;
}

float4 PS(PS_INPUT input):SV_TARGET
{
	//return float4(1.0f,1.0f,1.0f,1.0f);
	//return input.colour;
	float3 normal = normalize(input.normal);
	float4 lightDir = -normalize(lightDirection);
	float diffuse=saturate(dot(normal,lightDir));
	return (ambientMaterial*ambientLightColour)+(diffuseMaterial*diffuseLightColour*diffuse);
}

RasterizerState DisableCulling
{
    CullMode = NONE;
};

technique10 Render
{
	pass P0
	{
		SetVertexShader(CompileShader(vs_4_0, VS() ) );
		SetGeometryShader( NULL );
		SetPixelShader( CompileShader( ps_4_0,  PS() ) );
		SetRasterizerState(DisableCulling); 
	}
}