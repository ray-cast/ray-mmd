Ray-MMD
========
### Physically-Based Rendering ###
　　The aim of the project is to create a physically-based rendering at MMD.

Screenshots :
------------
[![link text](https://github.com/ray-cast/images/raw/master/screen1_small.jpg)](https://github.com/ray-cast/images/raw/master/screen1.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/screen2_small.png)](https://github.com/ray-cast/images/raw/master/screen2.png)
[![link text](https://github.com/ray-cast/images/raw/master/hou_small.jpg)](https://github.com/ray-cast/images/raw/master/hou.jpg)
[![link text](https://github.com/ray-cast/images/raw/master/lights_small.jpg)](https://github.com/ray-cast/images/raw/master/lights.png)

Download :
------------
* [Ray-MMD alpha - Source code (zip)](https://github.com/ray-cast/ray-mmd/archive/alpha.zip)
- About alpha version :
	- Adding new features to the most recent version
	- Fewer Bugs in this version
- Latest changes - Major allocator changes:
	- Fix issue : that cause a FilmGrain cannot be used with others MME
	- Fix issue : that cause a LightBloom cannot be used with others MME

Requirement :
------------
* MikuMikuDance - 926ver and above (Without Anti-Aliasing)
* MikuMikuEffect - 037ver and above
* Direct3D 9 With Shader Model 3.0 (ps_3_0)

Resources
------------
- HDRi
	- sIBL Archive - Hdrlabs.com \[[link](http://www.hdrlabs.com/sibl/archive.html)\].
	- ++skies; - **[aokcub](https://twitter.com/aokcub_cg)** \[[link](https://aokcub.net/cg/incskies/)\].
	- USC Institute \[[link](http://gl.ict.usc.edu/Data/HighResProbes)\].
- Text editor
	- Notepad++ \[[link](https://notepad-plus-plus.org)\].
	- Visual studio code \[[link](http://code.visualstudio.com/Download)\].
- Materials
	- Hair for Apperience Models - by VanillaBear3600 \[[link](http://vanillabear3600.deviantart.com/art/RayCast-Hair-Shader-For-Apperience-Models-664061177)\].

Tutroial:
------------
* Chinese Pages \[[link](https://github.com/ray-cast/ray-mmd/wiki/0.0-%E6%95%99%E7%A8%8B)\].
* Chinese Videos - by TerayTech \[[bilibili](https://space.bilibili.com/24434095/#!/channel/detail?cid=18483)\]\[[Youtube](https://www.youtube.com/playlist?list=PLlHmdNgS3E_z65bxBy1SYT7XKCVf8wU4k)\].

Features :
------------
* Physically-Based Material: albedo, metallic, smoothness/roughness, specular/reflectance, emissive, etc
* Clear coat material with absorption to simulate a second layer
* Cloth and anisotropic materials
* Approximation subsurface scattering materials
* Cook-Torrance microfacet specular BRDF (GGX) and burley diffuse BRDF
* Physical light units
* Point light, spot light, directional light, ies light and area light
* IES light profiles (point and spot light)
* HDR linear lighting
* Volumetric light (point, spot and ies light)
* Volumetric fog (cube and sphere fog)
* Light shaft effect
* Approximation atmospheric fog and sky scattering
* Image-based lighting (RGBT encode)
* Scene Space Reflection
* Screen Space Ambient Occlusition
* Screen Space Subsurface Scattering
* Color Balance PostProcess
* HDR PostProcess
* Bloom PostProcess
* FXAA PostProcess
* SMAA PostProcess
* Reinhard/Hable/ACES-like tone-mapping

Contact
------------

* Reach me via Twitter: [@Rui](https://twitter.com/Rui_cg).

[License (MIT)](https://raw.githubusercontent.com/ray-cast/ray-mmd/developing/LICENSE.txt)
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

Digging Deeper
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