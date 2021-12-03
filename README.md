Ray-MMD
========
###### [English](https://github.com/ray-cast/ray-mmd/blob/master/README.md) &nbsp; [中文文档](https://github.com/ray-cast/ray-mmd/blob/master/README_chs.md)
### Physically-Based Rendering ###
　　<img style="vertical-align: top;" src="./Shader/screenshots/logo.png" alt="logo" height="48px">

　　Ray-MMD is a free, powerful library and an extension pack of [mikumikudance](https://sites.google.com/view/vpvp/), offering an easy way of adding physically-based rendering with high-freedom of operation. it is written in hlsl lang with DX9 env and based on [mikumikueffect](https://bowlroll.net/file/35012). 

Screenshots:
------------
[![link text](./Shader/screenshots/screen1_small.jpg)](https://raw.githubusercontent.com/ray-cast/ray-mmd/master/Shader/screenshots/screen1.jpg)
[![link text](./Shader/screenshots/screen2_small.png)](https://raw.githubusercontent.com/ray-cast/ray-mmd/master/Shader/screenshots/screen2.png)
[![link text](./Shader/screenshots/screen5_small.jpg)](https://raw.githubusercontent.com/ray-cast/ray-mmd/master/Shader/screenshots/screen5.png)
[![link text](./Shader/screenshots/screen6_small.jpg)](https://raw.githubusercontent.com/ray-cast/ray-mmd/master/Shader/screenshots/screen6.png)

Download:
------------
　[![img](https://img.shields.io/badge/version-1.3.1v2-brightgreen.svg)](https://github.com/ray-cast/ray-mmd/archive/1.3.1v2.zip)
　[![img](https://img.shields.io/badge/version-1.4.0beta3-brightgreen.svg)](https://github.com/ray-cast/ray-mmd/archive/140beta3.zip)

* [Ray-MMD - 1.3.1v2 (zip)](https://github.com/ray-cast/ray-mmd/archive/1.3.1v2.zip)  (updated: 27. Apr 2017)
* [Ray-MMD - 1.3.1v2 (tar.gz)](https://github.com/ray-cast/ray-mmd/archive/1.3.1v2.tar.gz)  (updated: 27. Apr 2017)
* [Ray-MMD - 1.4.0beta v2 (zip)](https://github.com/ray-cast/ray-mmd/archive/140beta2.zip) (updated: 30. Jul 2017)
* [Ray-MMD - 1.4.0beta v2 (tar.gz)](https://github.com/ray-cast/ray-mmd/archive/140beta2.tar.gz) (updated: 30. Jul 2017)
- Extension
	- [ColorGrading - v1.0.0 (zip)](https://github.com/MikuMikuShaders/ColorGrading/archive/v1.0.0.zip) (updated: 2. Dec 2017, \[[Github](https://github.com/MikuMikuShaders/ColorGrading)\])
	- [FilmGrain - v1.0.0 (zip)](https://github.com/MikuMikuShaders/FilmGrain/archive/v1.0.0.zip) (updated: 2. Dec 2017, \[[Github](https://github.com/MikuMikuShaders/FilmGrain)\])
	- [FXAA - v1.0.0 (zip)](https://github.com/MikuMikuShaders/FXAA/archive/v1.0.0.zip) (updated: 2. Dec 2017, \[[Github](https://github.com/MikuMikuShaders/FXAA)\])
	- [LightBloom - v1.1.1 (zip)](https://github.com/MikuMikuShaders/LightBloom/archive/v1.1.1.zip) (updated: 2. Dec 2017, \[[Github](https://github.com/MikuMikuShaders/LightBloom)\])
	- [SMAA - v1.0.0 (zip)](https://github.com/MikuMikuShaders/SMAA/archive/v1.0.0.zip) (updated: 2. Dec 2017, \[[Github](https://github.com/MikuMikuShaders/SMAA)\])
	- [Spectrum - v1.4.0 (zip)](https://github.com/MikuMikuShaders/Spectrum/archive/v1.4.0.zip) (updated: 2. Dec 2017, \[[Github](https://github.com/MikuMikuShaders/Spectrum)\])
	- [StereoImage - v1.0.0 (zip)](https://github.com/MikuMikuShaders/StereoImage/archive/v1.0.0.zip) (updated: 2. Dec 2017, \[[Github](https://github.com/MikuMikuShaders/StereoImage)\])

Requirement:
------------
* [MikuMikuDance](https://sites.google.com/view/vpvp/) - 926ver (x64) (Without Anti-Aliasing)
* [MikuMikuEffect](https://bowlroll.net/file/35012) - 037ver (x64)
* Direct3D 9 With Shader Model 3.0 (ps_3_0)

Features:
------------
* Physically-Based Material: albedo, metallic, smoothness/roughness, specular/reflectance, emissive, etc
* Clear coat material with absorption to simulate a second layer
* Cloth material with cloth-DFG to simulate a specular reflection
* Anisotropic material to simulate a specular reflection
* Special-Case Materials Wetness
* Approximation subsurface scattering materials
* Cook-Torrance microfacet specular BRDF (GGX) and burley diffuse BRDF
* Physical light units
* Multiple light sources (Point, spot, sun, reactangle, disk, sphere, tube, ies)
* IES light profiles (point and spot light support)
* Soft shadow (PCF, VSM, PSSM)
* Omni light shadow based on dual-paraboloid projection
* Percentage Closer Soft Shadow
* HDR linear lighting
* Volumetric light (point, spot and ies light source support)
* Volumetric fog (cube and sphere fog support)
* Light shaft effect
* Approximation atmospheric fog and sky scattering
* Ground fog effect
* Skybox based on RGBT encode
* Image-based lighting based on RGBT encode
* Screen Space Ambient Occlusition (HBAO)
* Screen Space Reflection
* Screen Space Contact Shadow
* Screen Space Subsurface Scattering
* Post-Process Bokeh - Depth Of Field
* Post-Process Bloom
* Post-Process Eye adaptation
* Post-Process Tone-mapping (ACES-like,Reinhard,Hable,Hejl2015,NaughtyDog support)
* Post-Process Color Balance
* Post-Process FXAA
* Post-Process SMAA

Resources:
------------
- HDRi
	- sIBL Archive - Hdrlabs.com \[[link](http://www.hdrlabs.com/sibl/archive.html)\].
	- ++skies; - **[aokcub](https://twitter.com/aokcub_cg)** \[[link](https://aokcub.net/cg/incskies/)\].
	- USC Institute \[[link](http://gl.ict.usc.edu/Data/HighResProbes)\].
- Text editor
	- Notepad++ \[[link](https://notepad-plus-plus.org)\].
	- Visual studio code \[[link](http://code.visualstudio.com/Download)\].

Credits:
-------------
Financially supported on [Patreon](http://www.patreon.com/cubizer):  

#### Platinum supporters:
* Penti_mmd

##### Gold supporters:
* Sarashina - 更科
* Birdway

##### Bronze supporters:
* urara在処
* rin kari
* MMD-Seraph

`Thanks! and other supporters! (If you would like to be added or remove from this list Please contact me)`

Contact:
------------
　　If you are a developer using this as part of your love and considering contacting me, you can submit code by `Pull requests` or Feel free to contact me via `twitter` and `issues`, i'll add your profile to team members, Thanks.

* Reach me via Twitter: [@Rui](https://twitter.com/Rui_cg).

[License (MIT)](https://raw.githubusercontent.com/ray-cast/ray-mmd/master/LICENSE.txt)
-------------------------------------------------------------------------------
	Copyright (C) 2016-2017 Ray-MMD Developers. All rights reserved.

	https://github.com/ray-cast/ray-mmd

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
	BRIAN PAUL BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
	AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

References:
--------
* Moving to the Next Generation - The Rendering Technology of Ryse \[[link](http://www.crytek.com/download/2014_03_25_CRYENGINE_GDC_Schultz.pdf)\].
* ACES Filmic Tone Mapping Curve \[[link](https://knarkowicz.wordpress.com/2016/08/31/hdr-display-first-steps/)\].
* Compact Normal Storage for small G-Buffers \[[link](http://aras-p.info/texts/CompactNormalStorage.html)\].
* Convert Blinn-Phong to Beckmann distribution \[[link](http://simonstechblog.blogspot.de/2011/12/microfacet-brdf.html)\].
* Spherical Gaussian approximation for Blinn-Phong, Phong and Fresnel \[[link](https://seblagarde.wordpress.com/2012/06/03/spherical-gaussien-approximation-for-blinn-phong-phong-and-fresnel/)\].
* Physically Based Area Lights \[[link](http://www.frostbite.com/wp-content/uploads/2014/11/course_notes_moving_frostbite_to_pbr.pdf)\].
* Physics and Math of Shading \[[link](http://blog.selfshadow.com/publications/s2015-shading-course/hoffman/s2015_pbs_physics_math_slides.pdf)\].
* Compact YCoCg Frame Buffer for small IBL-Buffer \[[link](http://jcgt.org/published/0001/01/02/)\].
* RGBM color encoding \[[link](http://graphicrants.blogspot.com/2009/04/rgbm-color-encoding.html)\].
* Horizon Occlusion for IBL \[[link](http://marmosetco.tumblr.com/post/81245981087)\].
* Screen space glossy reflections \[[link](http://roar11.com/2015/07/screen-space-glossy-reflections/)\].
* Parallax Occlusion Map \[[link](http://sunandblackcat.com/tipFullView.php?topicid=28)\].
* Convert Temperature to RGB \[[link](https://github.com/davidf2281/ColorTempToRGB)\].
* Texture repetition \[[link](http://www.iquilezles.org/www/articles/texturerepetition/texturerepetition.htm)\].
* Pre-Integrated Skin Shading \[[link](http://simonstechblog.blogspot.com/2015/02/pre-integrated-skin-shading.html)\]
* Normal Blending in Detail \[[link](http://blog.selfshadow.com/publications/blending-in-detail/)\]
* An Approximation to the Chapman Grazing-Incidence Function for Atmospheric Scattering \[[link](http://www.gameenginegems.net/gemsdb/article.php?id=1133)\]
* Bump map to normal \[[link](https://docs.unrealengine.com/latest/attachments/Engine/Rendering/LightingAndShadows/BumpMappingWithoutTangentSpace/mm_sfgrad_bump.pdf)\]
* Special-Case Materials Wetness \[[link](http://advances.realtimerendering.com/other/2016/naughty_dog/NaughtyDog_TechArt_Final.pdf)\]
* Mip Fog \[[link](http://advances.realtimerendering.com/other/2016/naughty_dog/NaughtyDog_TechArt_Final.pdf)\]
* Gaussian-kernel-calculator \[[link](http://dev.theomader.com/gaussian-kernel-calculator/)\]
* Ray Box Intersection on the GPU \[[link](https://github.com/hpicgs/cgsee/wiki/Ray-Box-Intersection-on-the-GPU)\]
* Hexagonal Bokeh Blur Revisited \[[link](https://colinbarrebrisebois.com/2017/04/18/hexagonal-bokeh-blur-revisited/)\]
* Practical Post-Process Depth of Field \[[link](https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch28.html)\]
* Approximation of the IBL’s DFG term for a cloth BRDF \[[link](https://gist.github.com/romainguy/52d0e7f070d9ed7b44a0327d735fe33e)\]
* Real-Time Polygonal-Light Shading with Linearly Transformed Cosines\[[link](https://eheitzresearch.wordpress.com/415-2/)\]
* Limb Darkening model \[[link](http://www.physics.hmc.edu/faculty/esin/a101/limbdarkening.pdf)\]
* Percentage-Closer Soft Shadows \[[link](http://developer.download.nvidia.com/shaderlibrary/docs/shadow_PCSS.pdf)\]
* Creating a Spherical Reflection/Environment Mapping shader \[[link](https://www.clicktorelease.com/blog/creating-spherical-environment-mapping-shader/)\]
* Geometric Specular Aliasing \[[link](http://media.steampowered.com/apps/valve/2015/Alex_Vlachos_Advanced_VR_Rendering_GDC2015.pdf)\]
