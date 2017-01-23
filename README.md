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
* [Texture repetition](http://www.iquilezles.org/www/articles/texturerepetition/texturerepetition.htm)