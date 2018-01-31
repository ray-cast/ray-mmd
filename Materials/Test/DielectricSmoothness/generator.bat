@echo off
for /l %%i in (1,1,10) do (
	call :generator_material material_%%i.fx %%i/10.0 0 0 0
)
exit /b

:generator_material
echo #define ALBEDO_MAP_FROM 3 >> %1
echo #define ALBEDO_MAP_UV_FLIP 0 >> %1
echo #define ALBEDO_MAP_APPLY_SCALE 0 >> %1
echo #define ALBEDO_MAP_APPLY_DIFFUSE 1 >> %1
echo #define ALBEDO_MAP_APPLY_MORPH_COLOR 0 >> %1
echo #define ALBEDO_MAP_FILE "albedo.png" >> %1
echo.>> %1
echo const float3 albedo = 1.0; >> %1
echo const float2 albedoMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define ALBEDO_SUB_ENABLE 0 >> %1
echo #define ALBEDO_SUB_MAP_FROM 0 >> %1
echo #define ALBEDO_SUB_MAP_UV_FLIP 0 >> %1
echo #define ALBEDO_SUB_MAP_APPLY_SCALE 0 >> %1
echo #define ALBEDO_SUB_MAP_FILE "albedo.png" >> %1
echo.>> %1
echo const float3 albedoSub = 1.0; >> %1
echo const float2 albedoSubMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define ALPHA_MAP_FROM 3 >> %1
echo #define ALPHA_MAP_UV_FLIP 0 >> %1
echo #define ALPHA_MAP_SWIZZLE 3 >> %1
echo #define ALPHA_MAP_FILE "alpha.png" >> %1
echo.>> %1
echo const float alpha = 1.0; >> %1
echo const float alphaMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define NORMAL_MAP_FROM 0 >> %1
echo #define NORMAL_MAP_TYPE 0 >> %1
echo #define NORMAL_MAP_UV_FLIP 0 >> %1
echo #define NORMAL_MAP_FILE "normal.png" >> %1
echo.>> %1
echo const float normalMapScale = 1.0; >> %1
echo const float normalMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define NORMAL_SUB_MAP_FROM 0 >> %1
echo #define NORMAL_SUB_MAP_TYPE 0 >> %1
echo #define NORMAL_SUB_MAP_UV_FLIP 0 >> %1
echo #define NORMAL_SUB_MAP_FILE "normal.png" >> %1
echo.>> %1
echo const float normalSubMapScale = 1.0; >> %1
echo const float normalSubMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define SMOOTHNESS_MAP_FROM 0 >> %1
echo #define SMOOTHNESS_MAP_TYPE 0 >> %1
echo #define SMOOTHNESS_MAP_UV_FLIP 0 >> %1
echo #define SMOOTHNESS_MAP_SWIZZLE 0 >> %1
echo #define SMOOTHNESS_MAP_APPLY_SCALE 0 >> %1
echo #define SMOOTHNESS_MAP_FILE "smoothness.png" >> %1
echo.>> %1
echo const float smoothness = %2; >> %1
echo const float smoothnessMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define METALNESS_MAP_FROM 0 >> %1
echo #define METALNESS_MAP_UV_FLIP 0 >> %1
echo #define METALNESS_MAP_SWIZZLE 0 >> %1
echo #define METALNESS_MAP_APPLY_SCALE 0 >> %1
echo #define METALNESS_MAP_FILE "metalness.png" >> %1
echo.>> %1
echo const float metalness = %3; >> %1
echo const float metalnessMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define SPECULAR_MAP_FROM 0 >> %1
echo #define SPECULAR_MAP_TYPE 0 >> %1
echo #define SPECULAR_MAP_UV_FLIP 0 >> %1
echo #define SPECULAR_MAP_SWIZZLE 0 >> %1
echo #define SPECULAR_MAP_APPLY_SCALE 0 >> %1
echo #define SPECULAR_MAP_FILE "specular.png" >> %1
echo.>> %1
echo const float3 specular = 0.5; >> %1
echo const float2 specularMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define OCCLUSION_MAP_FROM 0 >> %1
echo #define OCCLUSION_MAP_TYPE 0 >> %1
echo #define OCCLUSION_MAP_UV_FLIP 0 >> %1
echo #define OCCLUSION_MAP_SWIZZLE 0 >> %1
echo #define OCCLUSION_MAP_APPLY_SCALE 0  >> %1
echo #define OCCLUSION_MAP_FILE "occlusion.png" >> %1
echo.>> %1
echo const float occlusion = 1.0; >> %1
echo const float occlusionMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define PARALLAX_MAP_FROM 0 >> %1
echo #define PARALLAX_MAP_TYPE 0 >> %1
echo #define PARALLAX_MAP_UV_FLIP 0 >> %1
echo #define PARALLAX_MAP_SWIZZLE 0 >> %1
echo #define PARALLAX_MAP_FILE "height.png" >> %1
echo.>> %1
echo const float parallaxMapScale = 1.0; >> %1
echo const float parallaxMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define EMISSIVE_ENABLE 0 >> %1
echo #define EMISSIVE_MAP_FROM 0 >> %1
echo #define EMISSIVE_MAP_UV_FLIP 0 >> %1
echo #define EMISSIVE_MAP_APPLY_SCALE 0 >> %1
echo #define EMISSIVE_MAP_APPLY_MORPH_COLOR 0 >> %1
echo #define EMISSIVE_MAP_APPLY_MORPH_INTENSITY 0 >> %1
echo #define EMISSIVE_MAP_APPLY_BLINK 0 >> %1
echo #define EMISSIVE_MAP_FILE "emissive.png" >> %1
echo.>> %1
echo const float3 emissive = 1.0; >> %1
echo const float3 emissiveBlink = 1.0; >> %1
echo const float  emissiveIntensity = 1.0; >> %1
echo const float2 emissiveMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define CUSTOM_ENABLE 0 >> %1
echo.>> %1
echo #define CUSTOM_A_MAP_FROM 0 >> %1
echo #define CUSTOM_A_MAP_UV_FLIP 0 >> %1
echo #define CUSTOM_A_MAP_COLOR_FLIP 0 >> %1
echo #define CUSTOM_A_MAP_SWIZZLE 0 >> %1
echo #define CUSTOM_A_MAP_APPLY_SCALE 0 >> %1
echo #define CUSTOM_A_MAP_FILE "custom.png" >> %1
echo.>> %1
echo const float customA = %4; >> %1
echo const float customAMapLoopNum = 1.0; >> %1
echo.>> %1
echo #define CUSTOM_B_MAP_FROM 0 >> %1
echo #define CUSTOM_B_MAP_UV_FLIP 0 >> %1
echo #define CUSTOM_B_MAP_COLOR_FLIP 0 >> %1
echo #define CUSTOM_B_MAP_APPLY_SCALE 0 >> %1
echo #define CUSTOM_B_MAP_FILE "custom.png" >> %1
echo.>> %1
echo const float3 customB = %5; >> %1
echo const float2 customBMapLoopNum = 1.0; >> %1
echo.>> %1
echo #include "../../material_common_2.0.fxsub" >> %1
exit /b