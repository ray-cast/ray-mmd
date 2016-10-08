shared texture OutdoorMap : OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for OutdoorFloor";
    string Format = "A16B16G16R16F";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0.5 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect = 
        "*controller.pmx = hide;"
        "skybox*.*=shader/OutdoorFloor/OutdoorSkybox.fx;"
        "*.pmd = shader/OutdoorFloor/OutdoorObject.fx;"
        "*.pmx = shader/OutdoorFloor/OutdoorObject.fx;"
        "* = hide;" ;
>;
shared texture OutdoorDepthMap : OFFSCREENRENDERTARGET <
    string Description = "OffScreen RenderTarget for OutdoorFloor";
    string Format = "A16B16G16R16F";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0.0 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect = 
        "*controller.pmx = hide;"
        "skybox*.*=shader/OutdoorFloor/OutdoorSkyboxDepth.fx;"
        "*.pmd = shader/OutdoorFloor/OutdoorDepth.fx;"
        "*.pmx = shader/OutdoorFloor/OutdoorDepth.fx;"
        "* = hide;" ;
>;
shared texture OutdoorShadingMap: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;
sampler OutdoorMapSamp = sampler_state 
{
    texture = <OutdoorMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU = CLAMP; AddressV = CLAMP;
};
sampler OutdoorDepthMapSamp = sampler_state 
{
    texture = <OutdoorDepthMap>;
    MinFilter = NONE; MagFilter = NONE; MipFilter = NONE;
    AddressU = CLAMP; AddressV = CLAMP;
};
sampler OutdoorShadingMapSamp = sampler_state {
    texture = <OutdoorShadingMap>;
    MinFilter = LINEAR;   MagFilter = LINEAR; MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

static float3 MirrorPos = float3(0.0, 0.0, 0.0);
static float3 MirrorNormal = float3(0.0, 1.0, 0.0);
static float3 WorldMirrorPos = MirrorPos;
static float3 WorldMirrorNormal = MirrorNormal;

float IsFace(float4 Pos)
{
    return min(dot(Pos.xyz - WorldMirrorPos, WorldMirrorNormal), dot(CameraPosition-WorldMirrorPos, WorldMirrorNormal));
}

float4 TransMirrorPos(float4 Pos)
{
    Pos.xyz -= WorldMirrorNormal * 2.0f * dot(WorldMirrorNormal, Pos.xyz - WorldMirrorPos);
    return Pos;
}

float3 DecodePack2Normal(float2 enc)
{
    float2 fenc = enc.xy * 4 - 2;
    float f = dot(fenc,fenc);
    float g = sqrt(1-f/4);
    float3 n;
    n.xy = fenc*g;
    n.z = 1-f/2;
    return n;
}

void DecodeGbuffer(sampler source, float2 coord, float4 screenPosition, float2 offset, out float3 color, out float3 normal)
{
    float4 packed = tex2D(source, coord);
    
    float4 env2 = tex2D(source, coord + float2(offset.x, 0.0));
    float4 env3 = tex2D(source, coord - float2(offset.x, 0.0));
    float4 env4 = tex2D(source, coord + float2(0.0, offset.y));
    float4 env5 = tex2D(source, coord - float2(0.0, offset.y));
    
    env2.rg = (env2.rg + env3.rg + env4.rg + env5.rg) * 0.25;
    env2.ba = (env2.ba + env3.ba + env4.ba + env5.ba) * 0.25;

    bool pattern = (fmod(screenPosition.x, 2.0) == fmod(screenPosition.y, 2.0));
    
    color = (pattern) ? float3(packed.ba, env2.a) : float3(packed.b, env2.a, packed.a);
    color = ycbcr2rgb(color);
    
    normal = DecodePack2Normal(packed.xy);
}

void OutdoorFloorVS(
    in float4 Position : POSITION, 
    out float4 oTexcoord : TEXCOORD0,
    out float3 oViewdir  : TEXCOORD1,
    out float4 oPosition : POSITION)
{
    oViewdir = normalize(CameraPosition.rgb - Position.rgb);
    oTexcoord = oPosition = Position;
}

float4 OutdoorFloorPS(
    in float4 texcoord : TEXCOORD0,
    in float3 viewdir  : TEXCOORD1,
    in float4 screenPosition : SV_Position) : COLOR
{
    float2 mirror = -texcoord.xy / texcoord.w;
    mirror = (mirror * 0.5 + 0.5);
    mirror += ViewportOffset;
    
    float2 screen = texcoord.xy / texcoord.w;
    screen = PosToCoord(screen);
    screen += ViewportOffset;
    
    float3 V = normalize(viewdir);
    float3 L = mul(-LightDirection, (float3x3)matView);

    float4 MRT0 = tex2D(Gbuffer1Map, screen);
    float4 MRT1 = tex2D(Gbuffer2Map, screen);
    float4 MRT2 = tex2D(Gbuffer3Map, screen);
    float4 MRT3 = tex2D(Gbuffer4Map, screen);

    MaterialParam material;
    DecodeGbuffer(MRT0, MRT1, MRT2, MRT3, material);

    float roughness = saturate(SmoothnessToRoughness(0));
    
    float2 coord = screen * ViewportSize.xy / 256;

    float4 wpos0 = mul(float4(V * material.linearDepth / V.z, 1), matViewInverse);
    float4 wpos1 = tex2D(OutdoorDepthMapSamp, mirror);

    wpos0.xyz += normalize(wpos1.xyz - wpos0.xyz) * distance(wpos0.xyz, wpos1.xyz);

    float4 PPos2 = mul(TransMirrorPos(wpos0), matViewProject);
    float2 texCoord = ((-PPos2.xy / PPos2.w) * 0.5 + 0.5) + ViewportOffset;
    
    float3 normal;
    float3 albedo;
    DecodeGbuffer(OutdoorMapSamp, texCoord, screenPosition, ViewportOffset2, albedo, normal);
    
    MaterialParam outdoorMaterial;
    outdoorMaterial.albedo = albedo;
    outdoorMaterial.normal = normal;
    outdoorMaterial.specular = 0.04;
    outdoorMaterial.transmittance = 0;
    outdoorMaterial.emissiveIntensity = 0;
    outdoorMaterial.emissive = 0;
    outdoorMaterial.smoothness = 0.2;
    
    float3 direction = saturate(dot(normal, L));
    direction *= outdoorMaterial.albedo * LightSpecular;
    direction *= (1 + mDirectLightP * 10 - mDirectLightM);
        
    float3 lighting = 0;
    lighting += direction;
    lighting *= step(0.9, dot(material.normal, mul(float3(0, 1, 0), (float3x3)matView)));
        
    return float4(lighting, -1.0);
}