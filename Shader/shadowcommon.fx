#if SHADOW_QUALITY == 1
#   define SHADOW_MAP_SIZE 1024
#elif SHADOW_QUALITY == 2
#   define SHADOW_MAP_SIZE 2048
#elif SHADOW_QUALITY == 3
#   define SHADOW_MAP_SIZE 4096
#elif SHADOW_QUALITY == 4
#   define SHADOW_MAP_SIZE 8192
#endif

#define WARP_RANGE 8
#define SHADOW_MAP_OFFSET  (1.0 / SHADOW_MAP_SIZE)
#define SELFSHADOW_COS_MAX 0.00872653549837393496488821397358 //cos 89.5 degree

const float CascadeZMax = 2000;
const float CascadeZMin = 5;

const float LightZMax = 4000.0;
const float LightZMin = 1;
const float LightDistance = 1000;

const float CascadeScale = 0.5;

const float LightPlaneNear = 0.1;
const float LightPlaneFar = 500.0;

float4x4 GetLightViewMatrix(float3 forward, float3 LightPosition)
{
   float3 right = cross(float3(0.0f, 1.0f, 0.0f), forward);
   float3 up;

   if (any(right))
   {
       right = normalize(right);
       up = cross(forward, right);
   }
   else
   {
       right = float3(1.0f, 0.0f, 0.0f);
       up = float3(0.0f, 0.0f, -sign(forward.y));
   }

   float3x3 rotation = { right.x, up.x, forward.x,
                         right.y, up.y, forward.y,
                         right.z, up.z, forward.z };

   return float4x4(rotation[0], 0,
                   rotation[1], 0,
                   rotation[2], 0,
                   mul(-LightPosition, rotation), 1);
};

float4 CalcLightProjPos(float fov, float znear, float zfar, float4 P)
{
    float h = 1.0 / tan(fov);
    float zp = zfar * (P.z - znear) / (zfar - znear);
    return float4(h * P.x, h * P.y, zp, P.z);
}

float4x4 CreateLightViewMatrix(float3 forward)
{
    const float3 up1 = float3(0, 0, 1);
    const float3 up2 = float3(1, 0, 0);

    float3 right = cross(CameraDirection, forward);
    right = !any(right) ? cross(up1, forward) : right;
    right = !any(right) ? cross(up2, forward) : right;
    right = normalize(right);

    float3 up = cross(forward, right);
    
    float3x3 rotation = { right.x, up.x, forward.x,
                          right.y, up.y, forward.y,
                          right.z, up.z, forward.z };

    float3 pos = floor(CameraPosition) - forward * LightDistance;

    return float4x4(rotation[0], 0,
                    rotation[1], 0,
                    rotation[2], 0,
                    mul(-pos, rotation), 1);
}

static float4x4 matLightProject = {
    1,  0,  0,  0,
    0,  1,  0,  0,
    0,  0,  1.0 / LightZMax,    0,
    0,  0,  0,  1
};

float CalculateSplitPosition(float i)
{
    float p0 = CascadeZMin + ((CascadeZMax - CascadeZMin) / CascadeZMin) * (i / 4.0);
    float p1 = CascadeZMin * pow(CascadeZMax / CascadeZMin, i / 4.0);
    return p0 * (1.0 - CascadeScale) + p1 * CascadeScale;
}

float4 CreateFrustumFromProjection()
{
    float4 r = mul(float4( 1, 0, 1, 1), matProjectInverse);
    float4 l = mul(float4(-1, 0, 1, 1), matProjectInverse);
    float4 t = mul(float4( 0, 1, 1, 1), matProjectInverse);
    float4 b = mul(float4( 0,-1, 1, 1), matProjectInverse);
    return float4(r.x / r.z, l.x / l.z, t.y / t.z, b.y / b.z);
}

float4 CreateLightProjParameter(float4x4 matLightProjectionToCameraView, float4 frustumInfo, float near, float far)
{
    float4 znear = float4(near.xxx, 1);
    float4 zfar = float4(far.xxx, 1);

    float4 rtn = float4(frustumInfo.xz, 1, 1) * znear;
    float4 rtf = float4(frustumInfo.xz, 1, 1) * zfar;
    float4 lbn = float4(frustumInfo.yw, 1, 1) * znear;
    float4 lbf = float4(frustumInfo.yw, 1, 1) * zfar;

    float4 rbn = float4(rtn.x, lbn.yzw), rbf = float4(rtf.x, lbf.yzw);
    float4 ltn = float4(lbn.x, rtn.yzw), ltf = float4(lbf.x, rtf.yzw);

    float4 orthographicBB = float4(9999, 9999, -9999,-9999);

    float2 vpos;
    #define CalcMinMax(inV) \
        vpos = mul(inV, matLightProjectionToCameraView).xy; \
        orthographicBB.xy = min(orthographicBB.xy, vpos); \
        orthographicBB.zw = max(orthographicBB.zw, vpos);
    CalcMinMax(rtn);    CalcMinMax(rtf);    CalcMinMax(lbn);    CalcMinMax(lbf);
    CalcMinMax(rbn);    CalcMinMax(rbf);    CalcMinMax(ltn);    CalcMinMax(ltf);

    const float normalizeByBufferSize = 2.0 / SHADOW_MAP_SIZE;
    const float scaleDuetoBlureAMT = (WARP_RANGE * 2.0 + 1) * normalizeByBufferSize * 0.5;

    orthographicBB += (orthographicBB.xyzw - orthographicBB.zwxy) * scaleDuetoBlureAMT;
    float4 unit = (orthographicBB.zwzw - orthographicBB.xyxy) * normalizeByBufferSize;
    orthographicBB = floor(orthographicBB / unit) * unit;

    float2 invBB = 1.0 / (orthographicBB.zw - orthographicBB.xy);
    float2 endPos = -(orthographicBB.xy + orthographicBB.zw);
    return float4(2.0, 2.0, endPos.xy) * invBB.xyxy;
}

float4x4 CreateLightProjParameters(float4x4 matLightProjectionToCameraView)
{
    float4 frustumInfo = CreateFrustumFromProjection();

    float z0 = CascadeZMin;
    float z1 = CalculateSplitPosition(1.0);
    float z2 = CalculateSplitPosition(2.0);
    float z3 = CalculateSplitPosition(3.0);
    float z4 = CascadeZMax;

    return float4x4(
        CreateLightProjParameter(matLightProjectionToCameraView, frustumInfo, z0, z1),
        CreateLightProjParameter(matLightProjectionToCameraView, frustumInfo, z1, z2),
        CreateLightProjParameter(matLightProjectionToCameraView, frustumInfo, z2, z3),
        CreateLightProjParameter(matLightProjectionToCameraView, frustumInfo, z3, z4));
}

float ShadowSlopeScaledBias(float depth)
{
    float dx = abs(ddx(depth));
    float dy = abs(ddy(depth));
    float depthSlope = max(dx, dy);
    return depthSlope;
}

float2 ComputeMoments(float depth)
{
    float dx = ddx(depth);
    float dy = ddy(depth);
    
    float2 moments;
    moments.x = depth;
    moments.y = depth * depth + 0.25 * (dx * dx + dy * dy);
    
    return moments;
}

float2 GetEVSMExponents()
{
    const float positiveExponent = 1.0;
    const float negativeExponent = 0.5;
    const float maxExponent = 5.54f;
    float2 lightSpaceExponents = float2(positiveExponent, negativeExponent);
    return min(lightSpaceExponents, maxExponent);
}

float2 WarpDepth(float depth, float2 exponents)
{
    depth = 2.0f * depth - 1.0f;
    float pos =  exp( exponents.x * depth);
    float neg = -exp(-exponents.y * depth);
    return float2(pos, neg);
}

float Linstep(float a, float b, float v)
{
    return saturate((v - a) / (b - a));
}

float ReduceLightBleeding(float max, float amount)
{
    return Linstep(amount, 1.0f, max);
}

float ChebyshevUpperBound(float2 moments, float depth, float minVariance, float lightBleedingReduction)
{
    float variance = moments.y - (moments.x * moments.x);
    variance = max(variance, minVariance);

    float d = depth - moments.x;
    float pMax = variance / (variance + (d * d));

    pMax = ReduceLightBleeding(pMax, lightBleedingReduction);
    return (depth <= moments.x ? 1.0f : pMax);
}