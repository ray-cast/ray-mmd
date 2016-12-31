Ray-MMD
========
### 基于物理的MikuMikuDance渲染库 ###
　　Ray渲是一个基于物理的渲染库，采用了UE4的IBL曲面拟合以及CE5光照模型(BRDF GGX),
以更贴合物理的方式渲染MMD，该渲染需求MMD版本为926（低于926版本无法正确计算IBL),
以及MME版本037，并且关闭MMD自带的抗锯齿。
#### Screenshot :
[![link text](https://github.com/ray-cast/images/raw/master/screen1_small.jpg)](https://github.com/ray-cast/images/raw/master/screen1.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/screen2_small.jpg)](https://github.com/ray-cast/images/raw/master/screen2.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/hou_small.jpg)](https://github.com/ray-cast/images/raw/master/hou.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/lights_small.jpg)](https://github.com/ray-cast/images/raw/master/lights.png)

#### License :
```
    http://www.linfo.org/mitlicense.html
```
#### HDRI :
* [sIBL Archive](http://www.hdrlabs.com/sibl/archive.html)
* [++skies;](https://aokcub.net/cg/incskies/)
* [USC Institute](http://gl.ict.usc.edu/Data/HighResProbes)

#### Text editor:
* [Notepad++](https://notepad-plus-plus.org/)
* [Visual studio code](http://code.visualstudio.com/Download)

#### Home :
* [Github](https://github.com/ray-cast/ray-mmd)
* [Coding](https://coding.net/u/raycast/p/ray-mmd)

#### 更新内容 :
##### 2016-12-31 ver 1.2.0
* 添加了SMAA抗锯齿
* 添加了SSDO，现在只有主光源有效
* 添加了skybox_blur.fx, 用于模糊天空球背景 [(预览)](https://github.com/ray-cast/images/raw/master/skyblur_120.jpg)
* 改进了CMFT的过滤工具,
* 改进了GbufferFillter, 用于减少一些头发产生的锯齿
* 修复了错误的SSS光照计算

##### 2016-12-27 ver 1.2.0beta
* 修复了纯黑物体specular计算出错
* 修复了启用自发光材质时CustomID无效

##### 2016-12-25 ver 1.2.0beta
* 修复了SSS的bug

##### 2016-12-23 ver 1.2.0beta
* 优化Skylighting载入速度
* 修复了自发光材质被透明物体遮挡时不发光的bug
* 修复了Skylighting计算SSS的bug

##### 2016-12-20 ver 1.2.0beta
* __注:新版本需要替换以前的 material_common.fxsub__
* 添加了ShadingMaterialID，用于模拟更多的布料 [(预览)](https://github.com/ray-cast/images/raw/master/ID_120beta.png)
* 添加了教程 Tutorial/06-Fake Transmittance [(预览)](https://github.com/ray-cast/ray-mmd/raw/master/Tutorial/06-Fake Transmittance/README.png)
* 添加了PNG贴图的自发光支持
* 添加了Skybox的垂直翻转
* 添加了Skybox的ColorBalance [(预览)](https://github.com/ray-cast/images/raw/master/balance_120beta.png)
* 改进了SSSS的计算方式 [(预览1)](https://github.com/ray-cast/images/raw/master/skin_120beta.png) [(预览2)](https://github.com/ray-cast/images/raw/master/dragon_120beta.png)
* 改进了SSAO近处出现白色边缘 [(预览)](https://github.com/ray-cast/images/raw/master/ssao_120beta.png)
* 改进了主光源阴影近处出现白色边缘
* 修复部分模型IBL specular的计算bug

#### 教程 :
##### 1.0 简介 :
　　IBL(Image-based-lighting)基于图片的光,需要对图片做一些处理,使其能够让天空球作为一个大
的光源，因此不同的天空球光照效果也是不一样的,也自然会产生出不同的色调(如下图):  
<a target="_Blank" href="https://github.com/ray-cast/images/raw/master/IBL1.jpg">
    <img src="https://github.com/ray-cast/images/raw/master/IBL1_small.png" width = "33%" height = "16.5%" align=center/>
</a>
<a target="_Blank" href="https://github.com/ray-cast/images/raw/master/IBL2.jpg">
    <img src="https://github.com/ray-cast/images/raw/master/IBL2_small.png" width = "33%" height = "16.5%" align=center/>
</a>
<a target="_Blank" href="https://github.com/ray-cast/images/raw/master/IBL.png">
    <img src="https://github.com/ray-cast/images/raw/master/IBL3_small.png" width = "33%" height = "16.5%" align=center/>
</a>   
　　假设白炽灯，远光灯，太阳，都是白色的，但很明显虽然都是白色，太阳是最刺眼的，其次远光灯
这样只用RGB来描述光的颜色是远远不够的，需要一个光强来描述颜色的强度，对此jpg,png,tga这类
颜色最大只有255(整数时是 0 ~ 255, 浮点时是0.0 ~ 1.0)的并不是HDR(High-dynamic-range).  
　　因此IBL的图片最好使用支持颜色大于255的文件(dds, hdr)，这样光照效果会显得更亮，立体感更强，
画面也不会灰,越亮的区域产生的bloom也会越大(以下是没有使用HDR效果):  
<a target="_Blank" href="https://github.com/ray-cast/images/raw/master/IBL2_nohdr.jpg">
    <img src="https://github.com/ray-cast/images/raw/master/IBL2_nohdr_s.png" width = "33%" height = "16.5%" align=center/>
</a>
<a target="_Blank" href="https://github.com/ray-cast/images/raw/master/IBL_nohdr.jpg">
    <img src="https://github.com/ray-cast/images/raw/master/IBL_nohdr_s.png" width = "33%" height = "16.5%" align=center/>
</a>
<a target="_Blank" href="https://github.com/ray-cast/images/raw/master/IBL3_nohdr.jpg">
    <img src="https://github.com/ray-cast/images/raw/master/IBL3_nohdr_s.png" width = "33%" height = "16.5%" align=center/>
</a>    

##### 2.0 文件夹介绍 :
* Extension : 添加一些额外的
* Lighting : 多光源相关特效
* Main : 添加物体基本的光照
* Materials : 用于指定物体材质 (如皮肤，金属，天空盒....)
* Shader : ray.x所需要的代码(不要挂载里面的文件)
* Shadow : 用于渲染物体阴影的特效(注:取消AO可以在DepthMap板块挂depth_nossao.fx)
* Skybox : 基本的天空盒特效和纹理
* Tools : 制作天空盒需要用到的工具
* Tutorial : 一些比较进阶的教程
* ray.conf : 配置文件(可自行修改)
* ray.x : 渲染主文件
* ray_controller.pmx : 调整光强，SSAO，泛光..等效果

##### 3.0 载入模型 :
* 将ray.x拖拽到MMD中, 并且关闭MMD自带的抗锯齿
* 添加Skybox/skybox.pmx,检查MaterialMap中是否挂载了material_skybox.fx  
[![link text](https://github.com/ray-cast/images/raw/master/2.2.png)](https://github.com/ray-cast/images/raw/master/2.2.png)
* 在EnvLightMap板块中对skybox.pmx赋予天空球目录中的skylighting_hdr.fx
[![link text](https://github.com/ray-cast/images/raw/master/2.3.png)](https://github.com/ray-cast/images/raw/master/2.3.png)
* 添加任意模型到MMD，并在Main板块选择Main.fx
* 在MaterialMap板块中，对刚载入的模型在Materials文件夹中选择对应的材质
* 最后将天空盒渲染顺序调至第一位,分配完后效果图 [(流程图)](https://raw.githubusercontent.com/ray-cast/ray-mmd/master/Tutorial/00-Hello%20World/README.jpg) :  
[![link text](https://github.com/ray-cast/images/raw/master/2.5_small.png)](https://github.com/ray-cast/images/raw/master/2.5.png)  

##### 4.0 材质介绍 :
　　因为考虑跨地区，文本统一使用了UTF8的编码，使用系统自带记事本的修改保存会导致出错，
建议下载文本编辑器(notepad++, visual studio code, sublime text3) 编辑器来修改
* Albedo(物体的贴图色)
    * Albedo是描述光线与材质的反照率，与DiffuseMap区别在于没有高光和环境光遮蔽
    * 编写自定义材质时需要将USE_CUSTOM_MATERIAL设置成 1
    * 默认时材质是启用贴图的,贴图使用PMX中模型的纹理  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_0.png)](https://github.com/ray-cast/images/raw/master/albedo_0.png)
    * 指定自定义纹理需要将ALBEDO_MAP_IN_TEXTURE设置成0(既不使用PMX模型中的贴图)
    * 然后修改ALBEDO_MAP_FILE的路径，路径可以使用相对/绝对路径 (不要带有中文, 路径分割"\"改为"/")  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_1.jpg)](https://github.com/ray-cast/images/raw/master/albedo_1.jpg)
    * 使用GIF/APNG做为纹理需要将ALBEDO_MAP_ANIMATION_ENABLE设置成1 (播放时图片才会动)
    * ALBEDO_MAP_ANIMATION_SPEED可以控制播放的速度，但最小播放速度为1倍速  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_2.jpg)](https://github.com/ray-cast/images/raw/master/albedo_2.jpg)
    * ALBEDO_MAP_APPLY_COLOR设置1可以将自定义颜色乘到贴图上, ALBEDO_MAP_APPLY_DIFFUSE则是PMX文件中的扩散色  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_apply_color.png)](https://github.com/ray-cast/images/raw/master/albedo_apply_color.png)
    * ALBEDO_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * const albedoLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
* NormalMap(法线贴图)
    * 添加物体的法线贴图和添加albedo同理
    * NORMAL_MAP_ENABLE 设置1时，启用法线贴图
    * NORMAL_MAP_IN_SPHEREMAP 设置1时，使用PMX中的sph贴图
    * NORMAL_MAP_IS_COMPRESSED 设置1时，代表法线贴图是RG颜色的压缩法线
    * NORMAL_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * 使用时设置 NORMAL_MAP_ENABLE = 1，然后指定NORMAL_MAP_FILE的文件路径 (不要带有中文, 路径分割"\"改为"/")  
    [![link text](https://github.com/ray-cast/images/raw/master/normal_0.jpg)](https://github.com/ray-cast/images/raw/master/normal_0.jpg)  
    [![link text](https://github.com/ray-cast/images/raw/master/normal_1.png)](https://github.com/ray-cast/images/raw/master/normal_1.png)
    * const float normalMapSubScale = 1.0; 法线的强度，修改成5以后的效果(贴图凸凹颠时可以设置成 -1.0)  
    [![link text](https://github.com/ray-cast/images/raw/master/normal_2.png)](https://github.com/ray-cast/images/raw/master/normal_2.png)
    * const float normal/normalSub/MapLoopNum = 1.0; 用于修改贴图的密度，修改成2的效果
    [![link text](https://github.com/ray-cast/images/raw/master/normal_3.png)](https://github.com/ray-cast/images/raw/master/normal_3.png)
* SubNormalMap(多层法线材质)
    * 用于在主法线或没有法线的基础上添加一些噪音法线贴图，类似给皮肤加粗糙毛孔, 使用方法和法线贴图一致
    * NORMAL_MAP_SUB_ENABLE 设置1时启用贴图
    * NORMAL_MAP_SUB_UV_FLIP 设置1时水平翻转纹理坐标
    * NORMAL_MAP_SUB_FILE 启用贴图时使用的贴图路径
    * const float normalMapSubScale = 1.0; 法线的强度(贴图凸凹颠时可以设置成 -1.0)
    * const float normalMapSubLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
* Smoothness(光滑度)  
    [![link text](https://github.com/ray-cast/images/raw/master/smoothness.jpg)](https://github.com/ray-cast/images/raw/master/smoothness.jpg)
    * 描述物体在微观表面的光滑程度
    * SMOOTHNESS_MAP_ENABLE 设置1时启用贴图
    * SMOOTHNESS_MAP_IN_TOONMAP 设置1时使用PMX中的Toon贴图 (需要先启用SMOOTHNESS_MAP_ENABLE)
    * SMOOTHNESS_MAP_IS_ROUGHNESS 设置1时贴图是粗糙度而不是光滑度
    * SMOOTHNESS_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * SMOOTHNESS_MAP_SWIZZLE 指定贴图使用的颜色通道 (R = 0, G = 1, B = 2, A = 3, 灰度图不需要指定)
    * SMOOTHNESS_MAP_FILE 启用贴图时使用的贴图路径
    * const float smoothness = 0.0; 取值范围0 ~ 1 (0 = 粗糙，1 = 光滑)
    * const float smoothnessMapLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)    
* Metalness(金属程度)  
    [![link text](https://github.com/ray-cast/images/raw/master/metalness.jpg)](https://github.com/ray-cast/images/raw/master/metalness.jpg)
    * 描述物体的金属程度是一个在绝缘体，半导体，和导体的插值
    * METALNESS_MAP_ENABLE 设置1时启用贴图
    * METALNESS_MAP_IN_TOONMAP 设置1时使用PMX中的Toon贴图 (需要先启用METALNESS_MAP_ENABLE)
    * METALNESS_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * METALNESS_MAP_SWIZZLE 指定贴图使用的颜色通道 (R = 0, G = 1, B = 2, A = 3, 灰度图不需要指定)
    * METALNESS_MAP_FILE 启用贴图时使用的贴图路径
    * const float metalness = 1.0 取值范围在0 ~ 1，0为绝缘体，1表示导体(金属)
    * const float metalnessMapLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
    * const float metalnessBaseSpecular = 0.04; 指定物体反射系数 (添加这个值可以增加金属性，0.0时物体不反射IBL的specular)
* Surface Scattering(表面散射色)  
    [![link text](https://github.com/ray-cast/images/raw/master/SSS.png)](https://github.com/ray-cast/images/raw/master/SSS.png)
    * 描述物体散射色，用于渲染皮肤，玉器时使用的, 皮肤必须设置const float curvature = 1.0f;
    * SSS_ENABLE 设置1时启用次表面散射
    * SSS_MAP_ENABLE 设置1时启用贴图
    * SSS_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * SSS_MAP_IS_THICKNESS 设置1时贴图是一个灰度的厚度贴图
    * SSS_MAP_APPLY_COLOR 设置1时将const float3 transmittance = 0.0;的颜色乘算到贴图色上
    * SSS_MAP_FILE 启用贴图时使用的贴图路径
    * const float3 transmittance = 0.0; 散射色,皮肤可以使用例如 float3 transmittance = float3(0.1, 0.0, 0.0);
    * const float transmittanceMapLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
* Surface Curvature (表面曲率)
    * 描述物体的弯曲程度，用于渲染更真实的皮肤使用, 皮肤必须设置const float curvature = 1.0f;
    * CURVATURE_MAP_ENABLE 设置1时启用贴图
    * CURVATURE_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * CURVATURE_MAP_FILE 启用贴图时使用的贴图路径
    * const float curvature = 0.0f; 用于指定曲率弯曲强度 (0 ~ 0.9999 代表玉器，1.0 ~ 1.999代表皮肤)
    * const float curvatureMapLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
* Melanin(黑色素)
    * 可以使物体渲染的更黝黑一些,显得不那么白,SSS中的截图因为使用了Melain, 所以会看起来像鸡蛋
    * MELANIN_MAP_ENABLE 设置1时启用贴图
    * MELANIN_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * MELANIN_MAP_SWIZZLE 指定贴图使用的颜色通道 (R = 0, G = 1, B = 2, A = 3, 灰度图不需要指定)
    * MELANIN_MAP_FILE 启用贴图时使用的贴图路径
    * const float melanin = 0.0; 取值范围0 ~ inf (如果贴图色很白时产生的黑色素会越少)
    * const float melaninMapLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
* Emissive(自发光贴图)
    * 自发光贴图需要把要发光的那部分做成和UV对应的贴图
    * EMISSIVE_ENABLE 设置1时启用自发光,使用时必须先启用这个
    * EMISSIVE_USE_ALBEDO 设置1时使用Albedo的参数代替自发光参数,但可以使用EMISSIVE_APPLY_COLOR 和 EMISSIVE_APPLY_MORPH_COLOR
    * EMISSIVE_MAP_ENABLE 设置1时启用贴图
    * EMISSIVE_MAP_IN_TEXTURE 设置1时使用PMX模型中的贴图
    * EMISSIVE_MAP_IN_SCREEN_MAP 使用MMD中的屏幕贴图/AVI贴图，需要先载入扩展目录中的DummyScreen.x
    * EMISSIVE_MAP_ANIMATION_ENABLE 设置1时贴图是一个GIF/APNG图片
    * EMISSIVE_MAP_ANIMATION_SPEED GIF/APNG的播放速度,最小为1倍速
    * EMISSIVE_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * EMISSIVE_APPLY_COLOR 设置1时将const float3 emissive = 1.0;乘算到贴图色,用于修改贴图色
    * EMISSIVE_APPLY_MORPH_COLOR 表情中的颜色(多光源需要用到的参数)
    * EMISSIVE_APPLY_MORPH_INTENSITY 表情中的颜色强度(多光源需要用到的参数)
    * EMISSIVE_MAP_FILE 启用贴图时使用的贴图路径
    * const float3 emissive = 1.0; 自发光的颜色，可以改为 float3 emissive = float3(0.1, 0.0, 0.0);
    * const float emissiveIntensity = 1.0; 自发光的强度，强度越大Bloom越大
    * const float emissiveMapLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
* Parallax(视差贴图)
    * 视差贴图可以使物体具备更好的凹凸感
    * PARALLAX_MAP_ENABLE 设置1时启用贴图
    * PARALLAX_MAP_UV_FLIP 设置1时水平翻转纹理坐标
    * PARALLAX_MAP_SUPPORT_ALPHA 设置1时对Alpha贴图有效
    * PARALLAX_MAP_FILE 启用贴图时使用的贴图路径
    * const float parallaxMapScale = 0.01; 高度的缩放强度
    * const float parallaxMapLoopNum = 1.0; 贴图的迭代次数 (参见法线贴图)
    
##### 5.0 自定义天空盒
* 解压Tools目录中的cmft.rar
* 选择一张hdr文件, 并改名为skybox.hdr, 然后拖拽到exe上  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_drag.png)](https://github.com/ray-cast/images/raw/master/IBL_drag.png)
* 如果文件格式是正确的将会进行处理，效果如下  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_cmd.png)](https://github.com/ray-cast/images/raw/master/IBL_cmd.png)
* 程序运行完后会多出skydiff_hdr.dds和skyspec_hdr.dds文件  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_output.png)](https://github.com/ray-cast/images/raw/master/IBL_output.png)
* 最后在Skybox目录，复制出任意一个天空球,将skybox.hdr, skydiff_hdr.dds, skyspec_hdr.dds 覆盖到新目录中的texture目录  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_final.png)](https://github.com/ray-cast/images/raw/master/IBL_final.png)

##### 6.0 多光源
* 内置的光源有点光源、聚光灯、球形光源、方形区域光 以及 管状光源
* 以最基本的点光源介绍，首先载入ray、skybox，以及一个地面模型  
[![link text](https://github.com/ray-cast/images/raw/master/floor.png)](https://github.com/ray-cast/images/raw/master/floor.png)
* 在Lighting目录中拖拽一个PointLight.pmx至窗口中  
[![link text](https://github.com/ray-cast/images/raw/master/point_light.png)](https://github.com/ray-cast/images/raw/master/point_light.png)
* 检查MME面板中，LightingMap板块是否有挂在point_lighting.fx (如果没有，挂载上去)
* 然后修改表情中的RGB+和Radius+调到最大，效果如图  
[![link text](https://github.com/ray-cast/images/raw/master/point_light2.png)](https://github.com/ray-cast/images/raw/master/point_light2.png)
* 光源需要阴影可以在LightMap中选择point_lighting_s0.fx(s代表阴影，0代表质量)
* 其它光源操作方式和点光源差不多，一些宽度、高度、范围、半径、都在表情右下角
* 光源自发光，可以在MME的MaterialMap选择一个material_lighting.fx 给 PointLight.pmx
* 需要更多的光源可以将PointLight.pmx复制一份，或者重复载入，其它光源同理  
[![link text](https://github.com/ray-cast/images/raw/master/point_light3_small.png)](https://github.com/ray-cast/images/raw/master/point_light3.png)
* 接着说下如何使用纹理的方形区域光
* 首先在Lighting目录中拖拽一个RectangleLight.pmx至窗口  
[![link text](https://github.com/ray-cast/images/raw/master/LED_0.png)](https://github.com/ray-cast/images/raw/master/LED_0.png)
* 检查MME面板中，LightingMap板块是否有挂在rectangle_lighting.fx (如果没有，挂载上去)
* 然后修改表情中的RGB+和Width/Height，以及将Range+调到最大，效果如图  
[![link text](https://github.com/ray-cast/images/raw/master/LED_1.png)](https://github.com/ray-cast/images/raw/master/LED_1.png)
* 修改rectangle_lighting.fx中的视频贴图，修改后保存 (可复制一份,复制的同时要挂载新的fx)
[![link text](https://github.com/ray-cast/images/raw/master/LED_2.png)](https://github.com/ray-cast/images/raw/master/LED_2.png)
* 复制一份material.fx改为material_xxxxx.fx
* 将USE_CUSTOM_MATERIAL改为 1，const float3 albedo = 1.0; 改为 0.0;
* 将发光贴图进行如下设置，修改后保存  
[![link text](https://github.com/ray-cast/images/raw/master/LED_3.png)](https://github.com/ray-cast/images/raw/master/LED_3.png)
* 最后在MME里MaterialMap将material_xxxxx.fx以及Main中main.fx赋予给RectangleLight.pmx效果如图  
[![link text](https://github.com/ray-cast/images/raw/master/LED_4.png)](https://github.com/ray-cast/images/raw/master/LED_4.png)
* 如果图片是GIF/APNG格式的纹理可以设置
* (VIDEO / ALBEDO / EMMISIVE) _MAP_ANIMATION_ENABLE 启用GIF/APNG动画
* (VIDEO / ALBEDO / EMMISIVE) _MAP_ANIMATION_SPEED  控制播放速度 (最小倍率为1)
* LED并且支持视频/屏幕纹理的播放
* 将Lighting目录中的DummyScreen.x 载入
* 在菜单->背景->加载AVI文件 (注 此为可选项，此外AVI文件可以使用MMBG插件载入非avi格式视频)
* 然后选择菜单->背景->(全画面/AVI背景)
* 最后将RectangleLight.pmx在LightMap板块选择LED.fx,在MaterialMap板块选择material_led.fx即可  
[![link text](https://github.com/ray-cast/images/raw/master/LED_5.png)](https://github.com/ray-cast/images/raw/master/LED_5.png)

##### 7.0 全局设置 (ray_controller.pmx):
* DirectLight+/-直接光照中整体光强
* SSAO+- 环境光遮蔽强度  
* SSAO Radius+- 环境光遮蔽的范围
* EnvDiffLight+-环境光的漫反射光强
* EnvSSSLight+-环境光的次表面散射光强
* EnvSpecLight+-环境光的镜面光强
* EnvRotateX/Y/Z 旋转天空盒的X/Y/Z轴
* EnvShadow 主光源阴影用于环境光阴影的强度
* BloomThreshold 提取最亮部分的阈值
* BloomRadius 产生泛光的大小
* BloomIntensity 泛光的整体强度
* BloomToneMapping 色调映射的模式 (为0时ACES709, 为1时线性映射)
* Vignette 窗口四周的暗角(虚角)
* Exposure 曝光强度
* Dispersion 相机色散的效果
* DispersionRadius 相机色散的区域大小
* ToneMapping 色调映射的模式 (为0时ACES709, 为1时线性映射)
* BalanceR/G/B 色彩平衡

#### 更新历史 :
##### 2016-11-26 ver 1.1.0
* __修改了cmft的输出编码，用于支持更大范围的亮度  [(预览)](https://github.com/ray-cast/images/raw/master/cmft_110.jpg)__
* 改进了SSR
* 添加压缩法线的支持 (RG Normal Map)
* 添加曲率贴图 (Curvature Map)
* 添加了Sphere Fog的Volumetric Shadow [(预览)](https://github.com/ray-cast/images/raw/master/volumetric_110.jpg)
* 添加了新的皮肤材质 [(预览)](https://github.com/ray-cast/images/raw/master/skin_110.jpg)

##### 2016-10-29 ver 1.0.9
* 添加了区域光的阴影 (点光源阴影的模拟)
* 添加了EMISSIVE_APPLY_MORPH_INTENSITY用于多光源强度的调节
* 还原Tonemapping
* 改进Bloom和自发光
* 改进光源的衰减 (更加贴合物理的衰减行为)
* 修复光源大于一定距离产生的bug
* 修复过暗的场景出现的颜色梯度

##### 2016-10-24 ver 1.0.9beta
* 改进Bloom
* 修复DirectionalLight+表情的Bug

##### 2016-10-23 ver 1.0.9beta
* 添加点光源的阴影
* 改进bloom的范围，使其产生更大的bloom [(预览1)](https://github.com/ray-cast/images/raw/master/bloomplus1.jpg)　[(预览2)](https://github.com/ray-cast/images/raw/master/bloomplus2.jpg)　[(预览3)](https://github.com/ray-cast/images/raw/master/bloomplus3.jpg)
* 改进SSAO近处出现布线
* 修复MMD输出png图片错误的透明通道问题
* 修复同时启用SSS和Emissive时Emissive无效
* 修复在Material.fx中Toon拼写为Tone的错误

##### 2016-10-16 ver 1.0.8
* 添加了新的cmft过滤工具，只支持hdr, dds, ktx, tga文件 [(使用方法1)](https://github.com/ray-cast/images/raw/master/IBL_filter.jpg) [(使用方法2)](https://github.com/ray-cast/images/raw/master/helloworld.jpg)
* 添加MultiLight+/-和EnvSSSLight+/-在表情中
* 添加Contrast+/-调节对比度在表情右下角中
* 添加简单的金属材质
* 添加多光源的透明物体支持
* 添加了更高的阴影质量4和5
* 改进主光源的阴影 

##### 2016-10-10 ver 1.0.8beta
* 修复多光源的Bug
* 添加了SSS可以计算内部散射 [(使用方法)](https://github.com/ray-cast/images/raw/master/1.0.8_sss.jpg)　[(皮肤测试)](https://github.com/ray-cast/images/raw/master/1.0.8_skin_sss.jpg)

##### 2016-10-9 ver 1.0.8beta
* 注1 : 此版本不可以和1.0.7覆盖,旧的PMM需要在DepthMap和PSSM里Skybox挂上对应的材质
* 注2 : 1.0.8版会出多光源的透明物体支持，正确的天空盒反射计算，以及代替cmftstudio的工具
* 添加了地板反射,修改ray.conf 的 OUTDOORFLOOR_QUALITY [(使用方法)](https://github.com/ray-cast/images/raw/master/1.0.8_wf.jpg)
* 添加了xxx_noalpha.fx用于优化不需要计算alpha的物体 [(使用方法)](https://github.com/ray-cast/images/raw/master/1.0.8_noalpha.jpg)
* 添加PMX中specular power大于200时自动发光,使用PMX中的specular color
* 添加BloomTonemapping表情
* 调整了IBL spec的曲线
* 调整了光源目录布局，添加了聚光灯的简单材质 [(使用方法)](https://github.com/ray-cast/images/raw/master/1.0.8_spot.jpg)
* 天空盒大小改为PMXEditor调整
* 材质中还原了自定义Alpha
* 材质添加EmissiveIntensity，指定发光强度
* 材质添加alphaThreshold大于以上阈值认为不是透明物体
* 独立出FilmGrain
* 改进了FXAA
* 改进了SSAO的强度曲线，且可以在DepthMap中指定不产生SSAO的物体 [(使用方法)](https://github.com/ray-cast/images/raw/master/1.0.8_nossao.jpg)
* 改进了主光源阴影
* 改进BokehBlur(暂时没用，改进中)
* 修复部分显卡使用带有阴影的SpotLight会编译错误
* 修复部分显卡使用RectangleLight会编译错误

##### Digging Deeper
* [Moving to the Next Generation - The Rendering Technology of Ryse](http://www.crytek.com/download/2014_03_25_CRYENGINE_GDC_Schultz.pdf)
* [ACES Filmic Tone Mapping Curve](https://knarkowicz.wordpress.com/2016/08/31/hdr-display-first-steps/)
* [Compact Normal Storage for small G-Buffers](http://aras-p.info/texts/CompactNormalStorage.html)
* [Convert Blinn-Phong to Beckmann distribution](http://simonstechblog.blogspot.de/2011/12/microfacet-brdf.html)
* [Spherical Gaussian approximation for Blinn-Phong, Phong and Fresnel](https://seblagarde.wordpress.com/2012/06/03/spherical-gaussien-approximation-for-blinn-phong-phong-and-fresnel/)
* [Physically Based Area Lights](http://www.frostbite.com/wp-content/uploads/2014/11/course_notes_moving_frostbite_to_pbr.pdf)
* [Physics and Math of Shading](http://blog.selfshadow.com/publications/s2015-shading-course/hoffman/s2015_pbs_physics_math_slides.pdf)
* [Compact YCoCg Frame Buffer for small IBL-Buffer](http://jcgt.org/published/0001/01/02/)
* [RGBM color encoding](http://graphicrants.blogspot.com/2009/04/rgbm-color-encoding.html)
* [Horizon Occlusion for IBL](http://marmosetco.tumblr.com/post/81245981087)
* [Screen space glossy reflections](http://roar11.com/2015/07/screen-space-glossy-reflections/)
* [Parallax Occlusion Map](http://sunandblackcat.com/tipFullView.php?topicid=28)