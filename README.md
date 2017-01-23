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

#### Tutroial:
* [中文文档](https://github.com/ray-cast/ray-mmd/wiki/教程)

#### Update :
##### 2017-1-20 ver 1.2.0
* 改进LED

##### 2017-1-12 ver 1.2.0
* 修复 NORMAL_MAP_SUB_IN_SPHEREMAP 无效的 bug
* 修复 NORMAL_MAP_SUB_IS_COMPRESSED 无效的 bug

##### 2017-1-4 ver 1.2.0 (8:51 GMT+8)
* 修复Issue #16

##### 2017-1-1 ver 1.2.0 (22:13 GMT+8)
* 修复了ShadingMaterialID中Subsurface的bug

##### 2017-1-1 ver 1.2.0
* 添加了ColorTemperature用于WhiteBalance

##### 2016-12-31 ver 1.2.0
* 添加了SMAA抗锯齿
* 添加了SSDO，现在只有主光源有效
* 添加了skybox_blur.fx, 用于模糊天空球背景 [(预览)](https://github.com/ray-cast/images/raw/master/skyblur_120.jpg)
* 改进了CMFT的过滤工具 [(预览)](https://github.com/ray-cast/images/raw/master/cmft_120.png)
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
* [Convert Temperature to RGB](https://github.com/davidf2281/ColorTempToRGB)