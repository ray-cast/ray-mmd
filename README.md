Ray-MMD
========
### 基于物理的MikuMikuDance渲染库 ###
　　Ray渲是一个基于物理的渲染库，采用了UE4的IBL曲面拟合以及CE5光照模型(BRDF GGX),
以更贴合物理的方式渲染MMD，该渲染需求MMD版本为926（低于926版本无法正确计算IBL),
以及MME版本037，并且关闭MMD自带的抗锯齿。
#### Screenshot :
[![link text](https://github.com/ray-cast/images/raw/master/bloom_small.jpg)](https://github.com/ray-cast/images/raw/master/bloom.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/hou_small.jpg)](https://github.com/ray-cast/images/raw/master/hou.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/skin_small.jpg)](https://github.com/ray-cast/images/raw/master/skin.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/lights_small.jpg)](https://github.com/ray-cast/images/raw/master/lights.png)

#### License :
```
    http://www.linfo.org/mitlicense.html
```

#### HDRI :
* [sIBL Archive](http://www.hdrlabs.com/sibl/archive.html)
* [++skies;](https://aokcub.net/cg/incskies/)
* [USC Institute](http://gl.ict.usc.edu/Data/HighResProbes)

#### 更新内容 :
##### 2016-XX-XX ver 1.1.0
* 改进了NormalMap
* 改进了ParallaxMap [(预览)](https://github.com/ray-cast/images/raw/master/ParallaxMap.jpg)
* SSAO改为只作用于IBL
* 纹理LOD采样方式改为各向异性

#### 项目主页 :
* [Github](https://github.com/ray-cast/ray-mmd)
* [Coding](https://coding.net/u/raycast/p/ray-mmd)

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
颜色最大只有255的并不是HDR(High-dynamic-range).  
　　因此IBL的图片最好使用支持颜色大于255的文件(dds, hdr)，以及HDR那篇教程来制作，这样光照效果会显得更亮，画面也不会灰(以下是没有使用HDR效果):  
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
* Lighting : 光源/环境光(IBL)相关特效
* Main : 添加物体基本的光照
* Materials : 用于指定物体材质 (如皮肤，金属，天空盒....)
* Shadow : 用于渲染物体阴影的特效
* Skybox : 基本的天空盒特效和纹理
* Tools : 制作天空盒需要用到的文件
* ray.conf : 配置文件(可自行修改)
* ray.x : 渲染主文件
* ray_controller.pmx : 调整光强，SSAO，泛光..等效果

##### 3.0 载入模型 :
* 将ray.x载入到MMD中, 并且关闭MMD自带的抗锯齿
* 添加Skybox/skybox.pmx,检查MaterialMap中是否挂载了material_skybox.fx  
[![link text](https://github.com/ray-cast/images/raw/master/2.2.png)](https://github.com/ray-cast/images/raw/master/2.2.png)
* 在EnvLightMap板块中对skybox.pmx赋予天空球目录中的skylighting_hdr.fx
[![link text](https://github.com/ray-cast/images/raw/master/2.3.png)](https://github.com/ray-cast/images/raw/master/2.3.png)
* 添加任意模型到MMD，并在Main板块选择Main.fx
* 在MaterialMap板块中，对刚载入的模型在Materials文件夹中选择对应的材质
* 最后将天空盒渲染顺序调至第一位,分配完后效果图 [(流程图)](https://raw.githubusercontent.com/ray-cast/ray-mmd/master/Tutorial/00-Hello%20World/README.jpg) :  
[![link text](https://github.com/ray-cast/images/raw/master/2.5_small.png)](https://github.com/ray-cast/images/raw/master/2.5.png)  

##### 4.0 材质介绍 :
　　因为考虑跨地区，文本统一使用了UTF8的编码，所以使用系统自带的修改保存会导致出错，需要下载文本编辑器(notepad++, sublime text3)这类编辑器来修改

* Albedo(反照率，物体的贴图色)
    * Albedo是描述光线与材质的反照率，与贴图(DiffuseMap)区别在Albedo没有类似头发的高光，它属于光滑度/金属产生的效果
    * 编写自己的材质时需要将USE_CUSTOM_MATERIAL设置成 1
    * 默认albedo是启用贴图的,且贴图来至PMX模型的纹理  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_0.png)](https://github.com/ray-cast/images/raw/master/albedo_0.png)
    * 指定自定义纹理需要将ALBEDO_MAP_IN_TEXTURE设置成0
    * 然后修改ALBEDO_MAP_FILE的路径，路径可以使用相对/绝对路径 (不要带有中文)  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_1.jpg)](https://github.com/ray-cast/images/raw/master/albedo_1.jpg)
    * 如果该图片是一个GIF/APNG需要将ALBEDO_MAP_ANIMATION_ENABLE设置成1 (播放时图片才会动)
    * 此外ALBEDO_MAP_ANIMATION_SPEED可以控制播放的速度，但最小倍率为1倍速  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_2.jpg)](https://github.com/ray-cast/images/raw/master/albedo_2.jpg)
    * ALBEDO_MAP_APPLY_COLOR设置1可以将自定义颜色乘到贴图上，ALBEDO_MAP_APPLY_DIFFUSE 则是PMX文件里的扩散色  
    [![link text](https://github.com/ray-cast/images/raw/master/albedo_apply_color.png)](https://github.com/ray-cast/images/raw/master/albedo_apply_color.png)
* NormalMap(法线贴图)
    * 添加物体的法线贴图和添加albedo一样同理
    * 将NORMAL_MAP_ENABLE设置1，以及指定NORMAL_MAP_FILE的文件路径  
    [![link text](https://github.com/ray-cast/images/raw/master/normal_0.jpg)](https://github.com/ray-cast/images/raw/master/normal_0.jpg)  
    [![link text](https://github.com/ray-cast/images/raw/master/normal_1.png)](https://github.com/ray-cast/images/raw/master/normal_1.png)
    * 法线的强度可以修改normalMapSubScale数值，修改成5以后的效果  
    [![link text](https://github.com/ray-cast/images/raw/master/normal_2.png)](https://github.com/ray-cast/images/raw/master/normal_2.png)
    * 修改贴图的密度，可以使用albedo/normal/MapSubLoopNum等，修改成2的效果
    [![link text](https://github.com/ray-cast/images/raw/master/normal_3.png)](https://github.com/ray-cast/images/raw/master/normal_3.png)
* SubNormalMap(多层法线材质)
    * 子法线是在主法线或没有法线的基础上添加一些噪音法线贴图，类似给皮肤加粗糙毛孔
    * 使用方法和法线贴图一致，同样可以调节迭代次数，以及强弱
* Smoothness(光滑度)  
    [![link text](https://github.com/ray-cast/images/raw/master/smoothness.jpg)](https://github.com/ray-cast/images/raw/master/smoothness.jpg)
    * 用于描述物体在微观表面的光滑程度，取值范围0 ~ 1，0最粗糙，1最光滑 (贴图方式和以上同理)  
    * 如果需要使用粗糙度而不是光滑度，指定SMOOTHNESS_MAP_IS_ROUGHNESS为1
* Metalness(金属程度)  
    [![link text](https://github.com/ray-cast/images/raw/master/metalness.jpg)](https://github.com/ray-cast/images/raw/master/metalness.jpg)
    * metalness是一个在绝缘体，半导体，和导体的插值，取值范围在0 ~ 1，0为绝缘体，1表示导体(金属) (贴图方式和以上同理)  
    * metalnessBaseSpecular指定物体最小的反射系数，添加这个值可以增加金属性，0.0时物体不反射IBL的specular
    * 不同金属材质的反射系数，可以使用如下颜色指定Albedo (RGB中的颜色除以255)，然后metalness指定为1
    [![link text](https://github.com/ray-cast/images/raw/master/metal.png)](https://github.com/ray-cast/images/raw/master/metal.png)  
    [![link text](https://github.com/ray-cast/images/raw/master/dielectric.png)](https://github.com/ray-cast/images/raw/master/dielectric.png)
* SSS(次表面散射)  
    [![link text](https://github.com/ray-cast/images/raw/master/SSS.png)](https://github.com/ray-cast/images/raw/master/SSS.png)
    * SSS用于渲染皮肤，玉器使用的
    * 使用需要将SSS_ENABLE开启，贴图方式和以上同理
    * transmittance用于制定内部的散射色，皮肤可以使用例如float3 transmittance = float3(0.1, 0.0, 0.0);
    * transmittanceStrength用于指定SSS的强度，0 ~ 0.9999 代表玉器，1.0 ~ 1.999代表皮肤
* Melanin(黑色素)
    * 黑色素可以使丝袜，皮肤，头发，这些物体渲染的更黝黑一些,显得不那么白，取值范围0 ~ 1
    * SSS中的截图就调节了Melain的系数, 所以会看起来像鸡蛋

##### 5.0 自定义天空盒
* 解压Tools目录中的cmft.rar
* 选择一张hdr文件, 并改名为skybox.hdr, 然后拖拽到exe上  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_drag.png)](https://github.com/ray-cast/images/raw/master/IBL_drag.png)
* 如果文件格式是正确的将会进行处理，效果如下  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_cmd.png)](https://github.com/ray-cast/images/raw/master/IBL_cmd.png)
* 程序运行完后会多出skydiff_hdr.dds和skyspec_hdr.dds  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_output.png)](https://github.com/ray-cast/images/raw/master/IBL_output.png)
* 最后在Skybox目录，复制出任意一个天空球,将skybox.hdr, skydiff_hdr.dds, skyspec_hdr.dds 覆盖到新目录中的texture目录  
[![link text](https://github.com/ray-cast/images/raw/master/IBL_final.png)](https://github.com/ray-cast/images/raw/master/IBL_final.png)

##### 6.0 多光源
* 内置的光源有点光源、聚光灯、球形光源、方形区域光 以及 管状光源，但目前不会产生阴影
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
* 需要更多的光源只需要将PointLight.pmx复制一份即可，其它光源同理  
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