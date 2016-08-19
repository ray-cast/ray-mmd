#ifndef _H_COMMON_H_
#define _H_COMMON_H_

float time : TIME;
float elapsed : ELAPSEDTIME;

float2 MousePositionn : MOUSEPOSITION;

float4x4 matWorld                 : WORLD;
float4x4 matWorldView             : WORLDVIEW;
float4x4 matWorldViewProject      : WORLDVIEWPROJECTION;
float4x4 matView                  : VIEW;
float4x4 matViewInverse           : VIEWINVERSE;
float4x4 matProject               : PROJECTION;
float4x4 matProjectInverse        : PROJECTIONINVERSE;
float4x4 matViewProject           : VIEWPROJECTION;
float4x4 matViewProjectInverse    : VIEWPROJECTIONINVERSE;
//float4x4 matLightWorldViewProject : WORLDVIEWPROJECTION < string Object = "Light"; >;

float3 CameraPosition  : POSITION  < string Object = "Camera"; >;
float3 CameraDirection : DIRECTION < string Object = "Camera"; >;

float3  LightDiffuse    : DIFFUSE   < string Object = "Light"; >;
float3  LightSpecular   : SPECULAR  < string Object = "Light"; >;
float3  LightDirection  : DIRECTION < string Object = "Light"; >;

float4  MaterialDiffuse     : DIFFUSE  < string Object = "Geometry"; >;
float3  MaterialAmbient     : AMBIENT  < string Object = "Geometry"; >;
float3  MaterialEmissive    : EMISSIVE < string Object = "Geometry"; >;
float3  MaterialSpecular    : SPECULAR < string Object = "Geometry"; >;
float3  MaterialToon        : TOONCOLOR;
float   MaterialPower       : SPECULARPOWER < string Object = "Geometry"; >;

float4  TextureAddValue   : ADDINGTEXTURE;
float4  TextureMulValue   : MULTIPLYINGTEXTURE;
float4  SphereAddValue    : ADDINGSPHERETEXTURE;
float4  SphereMulValue    : MULTIPLYINGSPHERETEXTURE;

float2 ViewportSize : VIEWPORTPIXELSIZE;

static float2 ViewportOffset  = (float2(0.5,0.5) / ViewportSize);
static float2 ViewportOffset2 = (float2(1.0,1.0) / ViewportSize);
static float2 ViewportAspect  = float2(1, ViewportSize.x / ViewportSize.y);

uniform bool use_texture;
uniform bool use_subtexture;
uniform bool use_spheremap;
uniform bool use_toon;

uniform bool opadd;

#endif