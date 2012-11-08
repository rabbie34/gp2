float4x4 matView:VIEW;
float4x4 matProjection:PROJECTION;
float4 cameraPosition:POSITION<
	string object = "PerspectiveCamera";
>;

TextureCube envMap;
bool useEnvTexture
<
string UIName="Use Environment Texture";
> = false;

SamplerState wrapSampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};

struct VS_INPUT
{
	float4 pos:POSITION;
};

struct PS_INPUT
{
	float4 pos:SV_POSITION;
	float3 texCoord:TEXCOORD0;
};

PS_INPUT VS(VS_INPUT input)
{
	PS_INPUT output=(PS_INPUT)0;
	
	float4x4 matViewProjection=mul(matView,matProjection);
	
	
	output.pos= mul(input.pos + cameraPosition , matViewProjection);
	output.texCoord = normalize(input.pos.xyz);
	return output;
}

float4 PS(PS_INPUT input):SV_TARGET
{
	return envMap.Sample(wrapSampler,input.texCoord);
}

RasterizerState DisableCulling
{
    CullMode = NONE;
	//FillMode=WIREFRAME;
};

DepthStencilState DisableZBuffering
{
	DepthEnable = FALSE;
};

technique10 Render
{
	pass P0
	{
		SetVertexShader(CompileShader(vs_4_0, VS() ) );
		SetGeometryShader( NULL );
		SetPixelShader( CompileShader( ps_4_0,  PS() ) );
		SetRasterizerState(DisableCulling); 
		SetDepthStencilState(DisableZBuffering,0);
	}
}