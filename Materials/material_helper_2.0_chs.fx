// 本文假定在一定程度上能够了解或者熟悉物理的材质的各种含义，有关更详细的基于物理的材质描述你可以查看UE4的文档来入手
// https://docs.unrealengine.com/latest/CHN/Engine/Rendering/Materials/PhysicallyBased/index.html

// 如果需要替换模型的贴图，可以通过设置不同的数值到ALBEDO_MAP_FROM，从而指定模型的的单一色或者纹理贴图,该选项默认时从PMX模型中的纹理插槽获取基本颜色
// 提示1: ALBEDO是描述物体在消除了非金属材质的镜面反射后的基本颜色，在UE4或者其它引擎中同样也被称为底色或者固有色
// 提示2: HDR图片是工作在高动态的线性色彩空间中，所以不要将一个HDR文件用作ALBEDO，否则会丢失数据产生一些问题
// 提示3: 一些图片(bmp, png, jpg, tga, dds, gif, apng)可能不是工作在sRGB的色域中的会产生一些问题，不过大部分图片都是工作在sRGB
// 提示4：GIF和APNG是占用CPU的开销
// 设置 0 到 ALBEDO_MAP_FROM 时 : 可以设置一个RGB的颜色到下方的“const float3 albedo = 1.0”来设置模型的颜色
// 设置 1 到 ALBEDO_MAP_FROM 时 : 模型的基本颜色将使用来至ALBEDO_MAP_FILE的相对或者绝对的(bmp, png, jpg, tga, dds, gif, apng)图片路径
// 设置 2 到 ALBEDO_MAP_FROM 时 : 模型的基本颜色将使用来至ALBEDO_MAP_FILE的相对或者绝对的GIF/APNG的路径
// 设置 3 到 ALBEDO_MAP_FROM 时 : 模型的基本颜色将使用来至PMX模型中的纹理插槽的图片
// 设置 4 到 ALBEDO_MAP_FROM 时 : 模型的基本颜色将使用来至PMX模型中的镜面插槽的图片
// 设置 5 到 ALBEDO_MAP_FROM 时 : 模型的基本颜色将使用来至PMX模型中的Toon插槽的图片
// 设置 6 到 ALBEDO_MAP_FROM 时 : 可以将AVI视频或者渲染后的结果当作模型的贴图纹理，不过需要先放置Extension/DummyScreen/中的x文件
// 设置 7 到 ALBEDO_MAP_FROM 时 : 将PMX中的环境色用于替换模型的颜色
// 设置 8 到 ALBEDO_MAP_FROM 时 : 将PMX中的镜面色用于替换模型的颜色
// 设置 9 到 ALBEDO_MAP_FROM 时 : 将PMX中的光泽度用于替换模型的颜色. // 该选择只能被光滑度使用
#define ALBEDO_MAP_FROM 3

// 该选项用于图片没有和UV对其时水平或者垂直翻转纹理坐标
// 1 : 以X轴水平翻转图片
// 2 : 以Y轴垂直翻转图片
// 3 : 同时翻转X轴和Y轴
#define ALBEDO_MAP_UV_FLIP 0

// 如果设置了ALBEDO来至纹理并且想要修改纹理的颜色时可以设置以下数值
// 1 : 将const float3 albedo = 1.0;中的颜色和被使用中的贴图的的颜色进行相乘
// 2 : 将const float3 albedo = 1.0;中的颜色和被使用中的贴图的的颜色进行指数相乘
#define ALBEDO_MAP_APPLY_SCALE 0

#define ALBEDO_MAP_APPLY_DIFFUSE 1		// 从PMX模型中的扩散色乘算到贴图上
#define ALBEDO_MAP_APPLY_MORPH_COLOR 0	// 如果表情中有(R+/G+/B+)控制器，则可以用来乘算到贴图上改变颜色

// 如果设置了1或者2到ALBEDO_MAP_FROM,则需要将一个相对或者绝对的图片的路径输入到这里
// 提示:上一级目录可以使用"../"来代替，并且图片中的所有路径分割需要将"\"改为"/"
// 例 : 
// 如果xxx.png图片和material_2.0.fx是在同一个目录
// 则可以直接将xxx.png输入到ALBEDO_MAP_FILE 既: #define ALBEDO_MAP_FILE "xxx.png"
// 如果xxx.png图片是在material_2.0.fx的上一级目录
// 则需要添加一个"../"来描述图片是在material_2.0.fx的上一级目录 既: #define ALBEDO_MAP_FILE "../xxx.png"
// 如果xxx.png图片是在material_2.0.fx的上一级目录的其它目录中国
// 则需要添加一个"../其它目录名"来描述图片是在material_2.0.fx的上一级目录中的其他目录 既: #define ALBEDO_MAP_FILE "../其他目录名/xxx.png"
// 如果图片是来至其它的磁盘
// 则只需要将相对路径复制并替换所有的\成/  既: #define ALBEDO_MAP_FILE "C:/Users/User Name/Desktop/xxx.png"
#define ALBEDO_MAP_FILE "albedo.png"

// 当ALBEDO_MAP_FROM为0时，或者ALBEDO_MAP_APPLY_SCALE为1时, 你需要设置一个RGB的颜色到albedo，并且色彩范围是在0 ~ 1之间
// 例:
// 如果红色是一个归一化后的数值, 则可以设置到albedo 为: const float3 albedo = float3(1.0, 0.0, 0.0);
// 如果红色是一个没有归一化的数值, 则需要手动归一化颜色 为: const float3 albedo = float3(255.0, 0.0, 0.0) / 255.0;
// 因为显示器的颜色是工作在sRGB空间，所有颜色的数值如果是提取来至PC显示器中的，需要对颜色转换成线性空间通过 : color ^ gamma
// 转换一个归一化后的颜色到线性的色彩空间 为: const float3 albedo = pow(float3(r, g, b), 2.2);
// 转换一个未归一化的颜色到线性的色彩空间 为: const float3 albedo = pow(float3(r, g, b) / 255.0, 2.2);
// 提示:
// 目前大部分显示器的Gamma数值近似为2.2,但可能一些其它的老式显示器工作在其它数值上的gamma, 有关sRGB和Gamma的更多信息可以看NVIDIA或者wiki来深入了解
// https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch24.html
// https://en.wikipedia.org/wiki/SRGB
const float3 albedo = 1.0;

// 修改这里的颜色可以将图片以瓷砖的形式增加纹理的迭代次数
const float2 albedoMapLoopNum = 1.0; // 默认数值是 1 即 1x1 的瓷砖贴图

// 通过将不同数值设置到ALBEDO_SUB_ENABLE，可以进一步修改第一组albedo的颜色
// 0 : None
// 1 : albedo * albedoSub
// 2 : albedo ^ albedoSub
// 3 : albedo + albedoSub
// 4 : melanin
// 5 : Alpha Blend
#define ALBEDO_SUB_ENABLE 0
#define ALBEDO_SUB_MAP_FROM 0 	 		 // 参考ALBEDO_MAP_FROM
#define ALBEDO_SUB_MAP_UV_FLIP 0 		 // 参考ALBEDO_MAP_UV_FLIP
#define ALBEDO_SUB_MAP_APPLY_SCALE 0  	 // 参考ALBEDO_MAP_APPLY_SCALE
#define ALBEDO_SUB_MAP_FILE "albedo.png" // 参考ALBEDO_MAP_FILE

const float3 albedoSub = 1.0;			// 色彩范围在0 ~ 1之间
const float2 albedoSubMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// 该选项对不透明物体无效.
#define ALPHA_MAP_FROM 3	 		// 参考ALBEDO_MAP_FROM
#define ALPHA_MAP_UV_FLIP 0	 		// 参考ALBEDO_MAP_UV_FLIP

// 输入不同的数值用于从纹理中不同的频道提取参数需要的数据. (R = 0, G = 1, B = 2, A = 3)
#define ALPHA_MAP_SWIZZLE 3
#define ALPHA_MAP_FILE "alpha.png"	// 参考ALBEDO_MAP_FILE

const float alpha = 1.0;			// 色彩范围在0 ~ 1之间
const float alphaMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// 提示: 法线贴图，以及环境光遮蔽等需要模型都具有非空的法线坐标否则人物模型或者场景模型上会产生一些奇怪的比白边问题
// 如果一些镜头产生了一些奇怪的白边效果，可以试着将场景模型放入PMXEditor，并且检查是否所有的法线的XYZ数值都不为0
#define NORMAL_MAP_FROM 0  // 参考ALBEDO_MAP_FROM

// 由于历史的原因法线贴图有很多的变种，则可以通过设置这里来指定
// 关于 PerturbNormalLQ 和 PerturbNormalHQ 的算法可以参考UE4的文档.
// https://docs.unrealengine.com/latest/CHN/Engine/Rendering/LightingAndShadows/BumpMappingWithoutTangentSpace/index.html
// 0 : 将具有RGB的切线空间的法线贴图用于模型的法线
// 0 : 将只有RG的压缩后的切线空间的法线贴图用于模型的法线
// 2 : 以PerturbNormalLQ的方式计算凹凸贴图用作模型的法线
// 2 : 以PerturbNormalHQ的方式计算凹凸贴图用作模型的法线
#define NORMAL_MAP_TYPE 0
#define NORMAL_MAP_UV_FLIP 0		 // 参考ALBEDO_MAP_APPLY_SCALE
#define NORMAL_MAP_FILE "normal.png" // 参考ALBEDO_MAP_FILE

const float normalMapScale = 1.0;	// 数值必须要大于等于0
const float normalMapLoopNum = 1.0;	// 参考albedoMapLoopNum

#define NORMAL_SUB_MAP_FROM 0			 // 参考ALBEDO_MAP_FROM
#define NORMAL_SUB_MAP_TYPE 0	 		 // 参考NORMAL_MAP_TYPE
#define NORMAL_SUB_MAP_UV_FLIP 0		 // 参考ALBEDO_MAP_APPLY_SCALE
#define NORMAL_SUB_MAP_FILE "normal.png" // 参考ALBEDO_MAP_FILE

const float normalSubMapScale = 1.0;	// 数值必须要大于等于0
const float normalSubMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// 默认时,参数将从模型中的光泽度转换为光滑度来使用
#define SMOOTHNESS_MAP_FROM 9			// 参考ALBEDO_MAP_FROM

// 描述光滑度贴图是使用光滑度还是粗糙度，以及如何转换粗糙度为光滑度
// 0 : Smoothness (from Frostbite / CE5 textures)
// 1 : Calculate smoothness from roughness by 1.0 - Roughness ^ 0.5 (from UE4/GGX/SubstancePainter2 textures)
// 2 : Calculate smoothness from roughness by 1.0 - Roughness		(from UE4/GGX/SubstancePainter2 with roughness linear roughness)
#define SMOOTHNESS_MAP_TYPE 0
#define SMOOTHNESS_MAP_UV_FLIP 0		// 参考ALBEDO_MAP_UV_FLIP
#define SMOOTHNESS_MAP_SWIZZLE 0		// 参考ALPHA_MAP_SWIZZLE
#define SMOOTHNESS_MAP_APPLY_SCALE 0	// 参考ALBEDO_MAP_APPLY_SCALE
#define SMOOTHNESS_MAP_FILE "smoothness.png" // 参考ALBEDO_MAP_FILE

const float smoothness = 0.0;			// 色彩范围在0 ~ 1之间
const float smoothnessMapLoopNum = 1.0;	// 参考albedoMapLoopNum

#define METALNESS_MAP_FROM 0				// 参考ALBEDO_MAP_FROM
#define METALNESS_MAP_UV_FLIP 0				// 参考ALBEDO_MAP_UV_FLIP
#define METALNESS_MAP_SWIZZLE 0				// 参考ALPHA_MAP_SWIZZLE
#define METALNESS_MAP_APPLY_SCALE 0			// 参考ALBEDO_MAP_APPLY_SCALE
#define METALNESS_MAP_FILE "metalness.png"	// 参考ALBEDO_MAP_FILE

const float metalness = 0.0;			// 色彩范围在0 ~ 1之间
const float metalnessMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// 该选项对CUSTOM_ENABLE和金属性大于零时无效
// 高光贴图并不是环境贴图，它仅仅只是修改了模型基本反射率,使用为了改变环境反射的颜色，并且当漫反射的光强大于环境反射时该参数的贡献很小
// 如果你不期望你的模型反射天空的颜色你可以设置const float3 specular = 0.0;为0让模型不具有镜面反射
#define SPECULAR_MAP_FROM 0 // 参考ALBEDO_MAP_FROM

// 描述镜面色如何转换成反射率
// 0 : Calculate reflection coefficient from specular color by F(x) = 0.08*(x  ) (from UE4 textures)
// 1 : Calculate reflection coefficient from specular color by F(x) = 0.16*(x^2) (from Frostbite textures)
// 2 : Calculate reflection coefficient from specular grays by F(x) = 0.08*(x  ) (from UE4 textures)
// 3 : Calculate reflection coefficient from specular grays by F(x) = 0.16*(x^2) (from Frostbite textures)
// 4 : Using reflection coefficient (0.04) instead of specular value (0.5), Available when SPECULAR_MAP_FROM at 0
#define SPECULAR_MAP_TYPE 0
#define SPECULAR_MAP_UV_FLIP 0			 // 参考ALBEDO_MAP_UV_FLIP
#define SPECULAR_MAP_SWIZZLE 0			 // 参考ALPHA_MAP_SWIZZLE
#define SPECULAR_MAP_APPLY_SCALE 0  	 // 参考ALBEDO_MAP_APPLY_SCALE
#define SPECULAR_MAP_FILE "specular.png" // 参考ALBEDO_MAP_FILE

// 默认数值为0.5
// 注 : 任何物质在物理中其反射率都不可能小于2%, 考虑一个入射光在折射率为1.5的透明介质上的传播，其反射率的计算公式为 F(x) = (x - 1)^2 / (x + 1)^2
// 反射率则是 (1.5 - 1)^2 / (1.5 + 1)^2 = 0.04 (or 4%), 将镜面数值转换成反射率其方程由SPECULAR_MAP_TYPE决定
// 如果镜面色转换成反射率其方程为 F(x) = 0.08*x, 为了使反射率等于0.04,解得x必须等于0.5
// 所以默认值将使用0.5的数值代替0.04的反射率系数
const float3 specular = 0.5; 			// 色彩范围在0 ~ 1之间
const float2 specularMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// 由于天顶光源是由无数方向发射的光线,无法实时的计算出环境光的遮蔽，所以取而带至的则是使用SSAO或者环境光遮蔽贴图，
// 因为SSAO只能模拟小范围的闭塞，所以可以离线烘培出环境光遮蔽贴图，并且该贴图是一种非常近视的手法用于模拟环境光的大范围闭塞
// 并且如果你不希望某个物体反射天空中的漫反射以及镜面反射,你可以将该参数设置为0
#define OCCLUSION_MAP_FROM 0		// 参考ALBEDO_MAP_FROM

// 用于描述烘培后的贴图是使用的sRGB色域还是线性的色彩空间
// 0 : 从sRGB的色彩空间中提取环境光遮蔽
// 1 : 从线性的色彩空间中提取环境光遮蔽
// 2 : 从sRGB的色彩空间以及使用模型的第二组UV提取环境光遮蔽
// 3 : 从线性的色彩空间以及使用模型的第二组UV提取环境光遮蔽
#define OCCLUSION_MAP_TYPE 0
#define OCCLUSION_MAP_UV_FLIP 0		// 参考ALBEDO_MAP_UV_FLIP
#define OCCLUSION_MAP_SWIZZLE 0		// 参考ALPHA_MAP_SWIZZLE
#define OCCLUSION_MAP_APPLY_SCALE 0 // 参考ALBEDO_MAP_APPLY_SCALE

const float occlusion = 1.0;			// 色彩范围在0 ~ 1之间
const float occlusionMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// 在DX9中, 视差贴图无法和顶点位移同时工作
#define PARALLAX_MAP_FROM 0	// 参考ALBEDO_MAP_FROM

// Other parameter types for parallax
// 0 : calculate without transparency
// 1 : calculate parallax occlusion with transparency and best SSDO
#define PARALLAX_MAP_TYPE 0
#define PARALLAX_MAP_UV_FLIP 0			// 参考ALBEDO_MAP_UV_FLIP
#define PARALLAX_MAP_SWIZZLE 0			// 参考ALPHA_MAP_SWIZZLE
#define PARALLAX_MAP_FILE "height.png"	// 参考ALBEDO_MAP_FILE

const float parallaxMapScale = 1.0;		// 数值必须要大于等于0
const float parallaxMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// 提示 : 你可以添加一个光源到场景并且绑定该光源到自发光的材质骨骼，用于制造自发光的照明
#define EMISSIVE_ENABLE 0
#define EMISSIVE_MAP_FROM 0						// 参考ALBEDO_MAP_FROM
#define EMISSIVE_MAP_UV_FLIP 0					// 参考ALBEDO_MAP_UV_FLIP
#define EMISSIVE_MAP_APPLY_SCALE 0				// 参考ALBEDO_MAP_APPLY_SCALE
#define EMISSIVE_MAP_APPLY_MORPH_COLOR 0		// 参考ALBEDO_MAP_APPLY_MORPH_COLOR
#define EMISSIVE_MAP_APPLY_MORPH_INTENSITY 0	// Texture colors to multiply with intensity from morph controller (Intensity+/-).

// 该参数用于设置不同的数值，可以使材质产生自发光闪烁的效果
// 1 : colors to multiply with frequency from emissiveBlink. like : const float3 emissiveBlink = float3(1.0, 2.0, 3.0);
// 2 : colors to multiply with frequency from morph controller, see Blink morph inside PointLight.pmx
#define EMISSIVE_MAP_APPLY_BLINK 0
#define EMISSIVE_MAP_FILE "emissive.png"		// 参考ALBEDO_MAP_FILE

const float3 emissive = 1.0;			// 色彩范围在0 ~ 1之间
const float3 emissiveBlink = 1.0; 		// 色彩范围在0 ~ 10之间
const float  emissiveIntensity = 1.0; 	// 色彩范围在0 ~ 100之间或者更高
const float2 emissiveMapLoopNum = 1.0;	// 参考albedoMapLoopNum

// Shading Material ID
// The curvature also called "opacity"
// You can see the UE4 docs for more information
// https://docs.unrealengine.com/latest/CHN/Engine/Rendering/Materials/LightingModels/SubSurfaceProfile/index.html

// 0 : Default				// customA = invalid,    customB = invalid
// 1 : 皮肤					// customA = curvature,  customB = transmittance color;
// 2 : Unlit placeholder	// customA = invalid,    customB = invalid
// 3 : 各向异性				// customA = segment,    customB = shadow color

// 为了时透明材质正确工作必须将模型的透明度数值设置小于0.999
// 4 : 玻璃					// customA = curvature   customB = transmittance color
// 5 : 布料					// customA = sheen,      customB = Fuzz Color
// 6 : 清漆					// customA = smoothness, customB = invalid;
// 7 : 次表面散射				// customA = curvature,  customB = transmittance color;
// 8 : Cel Shading        	// customA = threshold,  customB = shadow color;
// 9 : ToonBased Shading  	// customA = haredness,  customB = shadow color;
#define CUSTOM_ENABLE 0

#define CUSTOM_A_MAP_FROM 0	// 参考ALBEDO_MAP_FROM
#define CUSTOM_A_MAP_UV_FLIP 0
#define CUSTOM_A_MAP_COLOR_FLIP 0
#define CUSTOM_A_MAP_SWIZZLE 0
#define CUSTOM_A_MAP_APPLY_SCALE 0
#define CUSTOM_A_MAP_FILE "custom.png"

const float customA = 0.0;			 	// working in linear color-space, 所有的色彩范围在0 ~ 1之间
const float customAMapLoopNum = 1.0;	// 参考albedoMapLoopNum

#define CUSTOM_B_MAP_FROM 0	// 参考ALBEDO_MAP_FROM
#define CUSTOM_B_MAP_UV_FLIP 0
#define CUSTOM_B_MAP_COLOR_FLIP 0
#define CUSTOM_B_MAP_APPLY_SCALE 0
#define CUSTOM_B_MAP_FILE "custom.png"

const float3 customB = 0.0;				// working in sRGB color-space, 所有的色彩范围在0 ~ 1之间
const float2 customBMapLoopNum = 1.0;	// 参考albedoMapLoopNum

#include "material_common_2.0.fxsub"