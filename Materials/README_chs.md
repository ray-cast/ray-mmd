材质
========
改文档主要用于快速说明材质作用以方便查询

ALBEDO:
------
　　`Albedo` 也被称为 `基本色`, 定义了材质的整体颜色并且取值范围在`0.0` ~ `1.0`

* ##### ALBEDO_MAP_FROM  
    通过以下数值设置到`ALBEDO_MAP_FROM`,可以将一个 `线性的颜色` 或者 `纹理` 用于修改模型中的颜色.

    `0` . 从`const float3 albedo = 1.0`提取颜色(线性颜色)用于模型. 
    `1` . 模型的基本颜色将使用来至`ALBEDO_MAP_FILE`的相对或者绝对的(bmp, png, jpg, tga, dds, gif, apng)图片路径.  
    `2` . 模型的基本颜色将使用来至`ALBEDO_MAP_FILE`的相对或者绝对的GIF/APNG的路径.  
    `3` . 模型的基本颜色将使用来至`PMX`模型中的`纹理`插槽的图片.  
    `4` . 模型的基本颜色将使用来至`PMX`模型中的`镜面`插槽的图片.  
    `5` . 模型的基本颜色将使用来至`PMX`模型中的`Toon`插槽的图片.  
    `6` . 可以将`AVI`视频或者渲染后的图像用于模型的贴图纹理，需要先放置Extension/DummyScreen/中的x文件.  
    `7` . 将PMX中的`环境色`用于替换模型的颜色.  
    `8` . 将PMX中的`镜面色`用于替换模型的颜色.  
    `9` . 将PMX中的`光泽度`用于替换模型的颜色. // 该选择只能被光滑度使用  

* ##### ALBEDO_MAP_UV_FLIP
    通过以下数值设置到`ALBEDO_MAP_UV_FLIP`可以`水平`或者`垂直`翻转纹理坐标

    `1` . `X`轴水平翻转
    `2` . `Y`轴垂直翻转
    `3` . `X`和`Y`轴同时翻转

* ##### ALBEDO_MAP_APPLY_SCALE  
    如果`ALBEDO_MAP_FROM`使用的是纹理，并且想要修改纹理的颜色时可以设置以下数值

    `1` . 将const float3 albedo = 1.0;中的颜色和被使用中的贴图的的颜色进行相乘
    `2` . 将const float3 albedo = 1.0;中的颜色和被使用中的贴图的的颜色进行指数运算

* ##### ALBEDO_MAP_APPLY_DIFFUSE  
    从`PMX`模型中的扩散色乘算到贴图上.

* ##### ALBEDO_MAP_APPLY_MORPH_COLOR  
    如果表情中有(R+/G+/B+)控制器，则可以用来乘算到贴图上修改模型颜色

* ##### ALBEDO_MAP_FILE  
    如果设置了1或者2到`ALBEDO_MAP_FROM`时,需要将一个相对或者绝对的图片的路径输入到这里

    ##### 例如 :
    ###### 1. 如果xxx.png图片和material_2.0.fx是在同一个目录
    * `可以将xxx.png输入到ALBEDO_MAP_FILE 例: #define ALBEDO_MAP_FILE "xxx.png"`
    ###### 2. 如果xxx.png图片是在material_2.0.fx的上一级目录
    * `需要添加一个"../"来描述图片是在material_2.0.fx的上一级目录 例: #define ALBEDO_MAP_FILE "../xxx.png"`
    ###### 3. 如果xxx.png图片是在material_2.0.fx的上一级目录的其它目录中
    * `需要添加一个"../其它目录名"来描述图片是在material_2.0.fx的上一级目录中的其他目录 例: #define ALBEDO_MAP_FILE "../其他目录名/xxx.png"`
    ###### 4. 如果图片是来至其它的磁盘
    * `需要将相对路径复制并替换所有的\为/  例: #define ALBEDO_MAP_FILE "C:/Users/User Name/Desktop/xxx.png"`

    ##### Tips:
    * 可以使用 "../" 代替上一级目录
    * 替换所有的 "\\" 为 "/".

* ##### const float3 albedo = 1.0;
    当`ALBEDO_MAP_FROM`为`0`时，或者`ALBEDO_MAP_APPLY_SCALE`为`1`时, 你需要设置一个颜色到albedo，并且色彩范围是在0 ~ 1之间
    
    ##### 例:
    ###### 1. 如果红色是一个[归一化](https://en.wikipedia.org/wiki/Unit_vector)后的数值, 则可以设置到albedo为:
    * `const float3 albedo = float3(1.0, 0.0, 0.0);`
    ###### 2. 如果红色是一个[非归一化](https://en.wikipedia.org/wiki/Unit_vector)后的数值, 则可以设置到albedo为:
    * `const float3 albedo = float3(255, 0.0, 0.0) / 255.0;`
    ###### 3. 如果颜色是从显示器中提取的, 则需要将 [sRGB](https://en.wikipedia.org/wiki/SRGB) 转换到 [linear color-space](https://en.wikipedia.org/wiki/SRGB) 通过 `color ^ gamma`
    * 转换一个归一化后的颜色到线性的色彩空间 为:
      * `const float3 albedo = pow(float3(r, g, b), 2.2);`
    * 转换一个未归一化的颜色到线性的色彩空间 为:
      * `const float3 albedo = pow(float3(r, g, b) / 255.0, 2.2);`

* #### albedoMapLoopNum
    修改这里的数值可以将图片以瓷砖的形式增加纹理的迭代次数, 默认数值是 1 即 1x1 的瓷砖贴图
    ##### 例如:
    ###### 1. 如果 `X` 和 `Y` 时相同数值时则可以简单的设置同一个数值为:
    * `const flaot2 albedoMapLoopNum = 2;`
    ###### 2. 否者, 左边的数值2代表X轴，右边的数值3代表Y轴
    * `const flaot2 albedoMapLoopNum = float2(2, 3);`

SubAlbedo:
--------------
* ##### ALBEDO_SUB_ENABLE
    通过将不同数值设置到`ALBEDO_SUB_ENABLE`，可以进一步修改模型的颜色

    `0` . None  
    `1` . albedo * albedoSub  
    `2` . albedo ^ albedoSub  
    `3` . albedo + albedoSub  
    `4` . 黑色素  
    `5` . 透明贴图混合  

* ##### ALBEDO_SUB_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### ALBEDO_SUB_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### ALBEDO_SUB_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### ALBEDO_SUB_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))
* ##### const float3 albedoSub = 0.0 ~ 1.0;
* ##### const float2 albedoSubMapLoopNum = 0.0 ~ inf; (see [albedoMapLoopNum](#albedoMapLoopNum))

Alpha:
----------------
　　该选项对透明物体无效.

* ##### ALPHA_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### ALPHA_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### ALPHA_MAP_SWIZZLE
    输入不同的数值用于从纹理中不同的通道提取参数需要的数据.

    `0` . 从 `R` 通道中提取数据    
    `1` . 从 `G` 通道中提取数据    
    `2` . 从 `B` 通道中提取数据    
    `3` . 从 `A` 通道中提取数据    

* ##### ALPHA_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))
* ##### const float alpha = 0.0 ~ 1.0;
* ##### const float2 alphaMapLoopNum = 0.0 ~ inf; (see [albedoMapLoopNum](#albedoMapLoopNum))

Normal:
-------------
　　法线贴图，以及环境光遮蔽等需要模型都具有非空的法线坐标否则人物模型或者场景模型上会产生一些奇怪的白边问题
所以如果一些镜头产生了一些白边效果，可以试着将场景模型放入PMXEditor，并且检查是否所有的法线的XYZ数值是否都不为0

* ##### NORMAL_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### NORMAL_MAP_TYPE
    由于历史的原因法线贴图有很多的变种，可以通过设置这里来指定, see UE4 [docs](https://docs.unrealengine.com/latest/INT/Engine/Rendering/LightingAndShadows/BumpMappingWithoutTangentSpace/index.html) for `PerturbNormalLQ` and `PerturbNormalHQ`.
    
    `0` . 将具有RGB的切线空间的法线贴图用于模型的法线.  
    `1` . 将只有RG的压缩后的切线空间的法线贴图用于模型的法线.  
    `2` . 以PerturbNormalLQ的方式计算凹凸贴图用作模型的法线. 在小的物体上工作的可能不是很好.  
    `3` . 以PerturbNormalHQ的方式计算凹凸贴图用作模型的法线 (High Quality).  
    `4` . 将RGB的世界空间的法线贴图用于模型的法线.  

* ##### NORMAL_MAP_UV_FLIP (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### NORMAL_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))
* ##### const float normalMapScale = 0 ~ inf;
* ##### const float normalMapLoopNum = 0 ~ inf; (see [albedoMapLoopNum](#albedoMapLoopNum))

SubNormal
-------------
* ##### NORMAL_SUB_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### NORMAL_SUB_MAP_TYPE (see [NORMAL_MAP_TYPE](#NORMAL_MAP_TYPE))
* ##### NORMAL_SUB_MAP_UV_FLIP (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### NORMAL_SUB_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))
* ##### const float normalSubMapScale = 0.0 ~ inf;
* ##### const float normalSubMapLoopNum = 0.0 ~ inf; (see [albedoMapLoopNum](#albedoMapLoopNum))

Smoothness
-------------
　　默认时,将从`PMX`模型中的光泽度转换为光滑度来使用.

* ##### SMOOTHNESS_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))

* ##### SMOOTHNESS_MAP_TYPE
    描述光滑度贴图是使用光滑度还是粗糙度，以及如何转换粗糙度为光滑度

    `0` . `光滑度` (from Frostbite / CE5 textures)  
    `1` . 计算 `光滑度` 通过 `1.0 - 粗糙度 ^ 0.5` (from UE4/GGX/SubstancePainter2)  
    `2` . 计算 `光滑度` 通过 `1.0 - 粗糙度`       (from UE4/GGX/SubstancePainter2 with linear roughness)  

* ##### SMOOTHNESS_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### SMOOTHNESS_MAP_SWIZZLE (see [ALPHA_MAP_SWIZZLE](#ALPHA_MAP_SWIZZLE))
* ##### SMOOTHNESS_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### SMOOTHNESS_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))

* ##### const float smoothness = 0.0 ~1.0;
* ##### const float smoothnessMapLoopNum = 1.0; (see [albedoMapLoopNum](#albedoMapLoopNum))

Metalness:
-------------
　　金属性仅仅只是修改模型的反射率，用于替代老式的渲染管线

* ##### METALNESS_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### METALNESS_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### METALNESS_MAP_SWIZZLE (see [ALPHA_MAP_SWIZZLE](#ALPHA_MAP_SWIZZLE))
* ##### METALNESS_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### METALNESS_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))

* ##### const float metalness = 0.0 ~ 1.0;
* ##### const float metalnessMapLoopNum = 1.0; (see [albedoMapLoopNum](#albedoMapLoopNum))

Specular:
-------------
　　该选项对CUSTOM_ENABLE和Metalness大于零时无效, 并且该选项不是MMD的高光贴图, 只是用于修改模型基本反射率
用于改变环境反射的颜色,所以如果你不想渲染镜面反色射可以设置数值0.0到`const float3 specular = 0.0;`

* ##### SPECULAR_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### SPECULAR_MAP_TYPE
    描述镜面色如何转换成反射率

    `0` . 通过`F(x) = 0.08*(x  )`将彩色的镜面贴图转换成反色系数 (from UE4 textures)  
    `1` . 通过`F(x) = 0.16*(x^2)`将彩色的镜面贴图转换成反色系数 (from Frostbite textures)  
    `2` . 通过`F(x) = 0.08*(x  )`将灰度的镜面贴图转换成反色系数 (from UE4 textures)  
    `3` . 通过`F(x) = 0.16*(x^2)`将灰度的镜面贴图转换成反色系数 (from Frostbite textures)  
    `4` . 使用反射率 (`0.04`) 代替镜面色 (`0.5`), 当`SPECULAR_MAP_FROM`数值为`0`时有效  

* ##### SPECULAR_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### SPECULAR_MAP_SWIZZLE (see [ALPHA_MAP_SWIZZLE](#ALPHA_MAP_SWIZZLE))
* ##### SPECULAR_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### SPECULAR_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))
* ##### const float3 specular = 0.5;
    默认值将使用0.5的数值代替0.04的反射率系数

* ##### const float2 specularMapLoopNum = 1.0; (see [albedoMapLoopNum](#albedoMapLoopNum))

Occlusion
-------------
　　由于天顶光源是由无数方向发射的光线,无法实时的计算出环境光的遮蔽，取而带至的则是使用`SSAO`或者`环境光遮蔽贴图`
因为`SSAO`只能模拟小范围的闭塞，所以可以离线烘培出`环境光遮蔽贴图`，并且使用此贴图是一种非常近视的手法用于模拟环境光的大范围闭塞
产生更真实的效果,并且如果你不希望某个物体反射天空中的漫反射以及镜面反射,你可以将该参数设置为0

* ##### OCCLUSION_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))

* ##### OCCLUSION_MAP_TYPE
    用于描述烘培后的贴图是使用的sRGB色域还是线性的色彩空间

    `0` . 从sRGB的色彩空间中提取环境光遮蔽  
    `1` . 从线性的色彩空间中提取环境光遮蔽  
    `2` . 从sRGB的色彩空间以及使用模型的第二组UV提取环境光遮蔽  
    `3` . 从线性的色彩空间以及使用模型的第二组UV提取环境光遮蔽  

* ##### OCCLUSION_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### OCCLUSION_MAP_SWIZZLE (see [ALPHA_MAP_SWIZZLE](#ALBEDO_MAP_UV_FLIP))
* ##### OCCLUSION_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))

* ##### const float occlusion = 0.0 ~ 1.0;
* ##### const float occlusionMapLoopNum = 0.0 ~ inf; (see [albedoMapLoopNum](#albedoMapLoopNum))

Parallax:
-------------
　　你可以将高度贴图用于此处, 但在DX9中视差贴图无法和顶点位移同时工作

* ##### PARALLAX_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))

* ##### PARALLAX_MAP_TYPE
    设置视察贴图的类型

    `0` . 忽略透明度  
    `1` . 不忽略透明度  

* ##### PARALLAX_MAP_UV_FLIP  (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### PARALLAX_MAP_SWIZZLE  (see [ALPHA_MAP_SWIZZLE](#ALPHA_MAP_SWIZZLE))
* ##### PARALLAX_MAP_FILE (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))

* ##### const float parallaxMapScale = 0.0 ~ inf;
* ##### const float parallaxMapLoopNum = 0.0 ~ inf; (see [albedoMapLoopNum](#albedoMapLoopNum))

Emissive
-------------
　　你可以添加一个光源到场景并且绑定该光源到自发光的材质骨骼，用于制造自发光的照明

* ##### EMISSIVE_ENABLE
* ##### EMISSIVE_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### EMISSIVE_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### EMISSIVE_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### EMISSIVE_MAP_APPLY_MORPH_COLOR (see [ALBEDO_MAP_APPLY_MORPH_COLOR](#ALBEDO_MAP_APPLY_MORPH_COLOR))

* ##### EMISSIVE_MAP_APPLY_MORPH_INTENSITY
   将多光源中的(Intensity+/-)表情用于材质.
* ##### EMISSIVE_MAP_APPLY_BLINK
   设置以下的数值，可以使材质产生自发光闪烁的效果.

   `1` . colors to multiply with frequency from `emissiveBlink`. like : const float3 emissiveBlink = float3(1.0, 2.0, 3.0);  
   `2` . colors to multiply with frequency from `morph controller`, For PointLight.pmx...

* ##### EMISSIVE_MAP_FILE ([ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))

* ##### const float3 emissive = 0.0 ~ 1.0;
* ##### const float3 emissiveBlink = 0.0 ~ 10.0;
* ##### const float  emissiveIntensity = 0 ~ 100 and above
* ##### const float2 emissiveMapLoopNum = 0.0 ~ inf; (see [albedoMapLoopNum](#albedoMapLoopNum))

Shading Model ID
-------------
* ##### CUSTOM_ENABLE
    | ID | Material          | CustomA   | CustomB |
    | :- |:------------------|:----------|:--------|
    | 0  | 默认 | 无效 | 无效 |
    | 1  | 皮肤 | 曲率 | 散射色 |
    | 2  | 自发光 | 无效 | 无效 |
    | 3  | 各向异性 | 各项异性成都 | 切线扰动 |
    | 4  | 玻璃 | 曲率 | 散射色 |
    | 5  | 布料 | 光泽度 | 绒毛颜色 |
    | 6  | 清漆 | 光滑度 | 无效 |
    | 7  | 次表面 | 曲率 | 散射色 |
    | 8  | 卡通着色 | 阴影阈值  | 阴影色 |
    | 9  | ToonBased Shading | 阴影阈值  | 阴影色 |

    ##### Tips:  
    `Subsurface` : The `curvature` also called `opacity`, see the UE4 [docs](https://docs.unrealengine.com/latest/INT/Engine/Rendering/Materials/LightingModels/SubSurfaceProfile/index.html) for more information  
    `Glass` : In order to make refraction work, you must set alpha value of the pmx to less then `0.999`  
    `Cloth` : `Sheen` is interpolation between `GGX` and `InvGGX`, see [paper](http://blog.selfshadow.com/publications/s2017-shading-course/imageworks/s2017_pbs_imageworks_sheen.pdf) for cloth information  
    `Cloth` : `Fuzz Color` is f0 of fresnel params in sRGB color-space  
    `Toon`  : see [paper](https://zhuanlan.zhihu.com/p/26409746) for more information, but chinese  

* ##### CUSTOM_A_MAP_FROM  (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### CUSTOM_A_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### CUSTOM_A_MAP_COLOR_FLIP
* ##### CUSTOM_A_MAP_SWIZZLE (see [ALPHA_MAP_SWIZZLE](#ALPHA_MAP_SWIZZLE))
* ##### CUSTOM_A_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### CUSTOM_A_MAP_FILE "custom.png" (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))

* ##### const float customA = 0.0 ~ 1.0; (linear-space)
* ##### const float customAMapLoopNum = 1.0; (see [albedoMapLoopNum](#albedoMapLoopNum))

* ##### CUSTOM_B_MAP_FROM (see [ALBEDO_MAP_FROM](#ALBEDO_MAP_FROM))
* ##### CUSTOM_B_MAP_UV_FLIP (see [ALBEDO_MAP_UV_FLIP](#ALBEDO_MAP_UV_FLIP))
* ##### CUSTOM_B_MAP_COLOR_FLIP
* ##### CUSTOM_B_MAP_APPLY_SCALE (see [ALBEDO_MAP_APPLY_SCALE](#ALBEDO_MAP_APPLY_SCALE))
* ##### CUSTOM_B_MAP_FILE "custom.png" (see [ALBEDO_MAP_FILE](#ALBEDO_MAP_FILE))

* ##### const float3 customB = 0.0 ~ 1.0; (sRGB color-space)
* ##### const float2 customBMapLoopNum = 1.0; (see [albedoMapLoopNum](#albedoMapLoopNum))

FAQ:
--------------------
* What is sRGB-color and Gamma
    * The Gamma is near 2.2 used most of time, About sRGB and Gamma, You can see docs for more information  
    * `https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch24.html`  
    * `https://en.wikipedia.org/wiki/SRGB`  

* What is gloss map
    * Gloss map is a `smoothness map`

* How to use roughness map
    * Enter the path to the `SMOOTHNESS_MAP_FILE` and set `SMOOTHNESS_MAP_TYPE` to 1

* Where melanin
    * It has moved into `ALBEDO_SUB_ENABLE`, see `ALBEDO_SUB_ENABLE` for more information

* Why increase number of parallaxMapLoopNum will increase the loop number of albedo, normals, etc  
    * Bacause parallax coordinates can be calculated from `height map`,that are then used to access textures with `albedo`, `normals`, `smoothness`, `metalness`, etc, In other words like fetched data (`albedo`, `normals`, etc) from parallax coordinates * `parallaxMapLoopNum` * `albedo`/`normal`/MapLoopNum