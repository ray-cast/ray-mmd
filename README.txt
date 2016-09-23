Ray-MMD

基于物理的MikuMikuDance渲染库

项目主页 :
    https://github.com/ray-cast/ray-mmd

更新内容 :
##### 2016-9-18 ver 1.0.6 beta
* 添加了聚光灯的阴影
* 添加了更详细的材质介绍
* 改进了光源，添加了Intensity+
* 改进了IBL使其更贴贴合UE4
* Bloom从LDR到了HDR空间中计算
* 删除了老式的ToneMapping，增加了Rec2020的输出
* 修复RGB转Ycbcr浮点误差引起的不正确亮度计算和Bloom

##### 2016-9-18 ver 1.0.5
* 添加SSR (屏幕空间的局部反射，需要修改ray.conf的SSR_QUALITY)
* 添加纹理采样的过滤方式 (默认16x各向异性, 远景看不见闪烁了)
* 添加alpha物体的自发光
* 添加ALBEDO_MAP_APPLY_DIFFUSE 将PMX中的扩散色，以乘的方式用在纹理上
* 添加FilmLine (扫面线)
* 添加BokehBlur (将远景模糊成很多小圆(散焦)，暂时没用，以后会发展成景深)
* 改进TubeLighting的漫反射 (以前是错误的计算)
* 改进SSAO的采样，以及减少了SSAO采样的范围，增加SSAO表情控制的强度
* 删除了Screenshot目录
* 删除了ColorBalance，以放置ray_controller表情右下角
* 修复了不正确的亮度计算导致的锯齿
* 修复了skydome的阴影bug
* 修复了旋转天空盒导致fresnel计算错误产生不正确的光照

##### 2016-9-11 ver 1.0.4
* 添加TubeLight
* 添加播放GIF/APNG图片以及RectangleLight的双面光照
* 添加视差贴图
* 添加获取来至AVI/屏幕的纹理用于材质
* 添加ALBEDO的参数代替自发光的参数，但可以使用EMISSIVE_APPLY_COLOR 和 EMISSIVE_APPLY_MORPH_COLOR
* 添加Debug的扩展
* 添加MikuMikuMoving的兼容
* 优化SSAO的模糊
* 优化Bloom以及自发光

##### 2016-9-4 ver 1.0.3
* 改进光照模式，以及渲染速度
* 添加了alpha的支持
* 添加了纹理作为光源的矩形区域光
* 添加了视频作为光源的矩形区域光(LED)
* 添加了skydome的地面阴影
* 调整ToneMapping在最大时改用线性曝光
* 略微提高了天空球的清晰度(如果需要更清晰可以把skybox.pmx里的贴图纹理改成HDR文件)

##### 2016-8-30 ver 1.0.3 beta
* 改进默认材质对Diff&Spec的兼容
* 添加了新的HDR和工具，以及更新HDR制作教程(现在可以支持HDR的天空了)
* 添加了LightMap用于渲染多个光源
* 添加了点光源，聚光灯，方形区域光和球形区域光 (都会根据材质进行光照)
* 添加了天空盒旋转表情 (EnvRotateX/Y/Z)
* 添加了主光源阴影用于IBL的表情 (EnvShadow)
* 添加了Blub表情 (B快门)
* 修复只启用次法线时normalMapSubScale无效

2016-8-25 ver 1.0.2
* 修复了不启用USE_CUSTOM_MATERIAL产生的Bug
* 修复了发光贴图的Bug
* 修复了光滑贴图和金属性贴图的Bug
* 表情Noise改为FilmGrain
* 添加了BloomRadius表情，产生更大范围的Bloom
* 增加了metalnessBaseSpec(默认0.04)，如果不想反射太强改为 0, 用于皮肤的渲染
* 添加了transmittanceStrength，指定SS的模糊程度
* 添加了HDR的dds文件支持(下个版本将会出将HDR转DDS支持的工具)
* 垂直翻转了天空盒纹理
* 增加了低版本的兼容性
* 下版本预计会出多光源支持，以及改善alpha的兼容

2016-8-22 ver 1.0.1
* 增加材质单独存放其它目录(必须和 material_common.fxsub) 一起打包
* 增加控制SSAO产生阴影半径的大小
* 增加了相机色散，以及色散半径的效果 (表情: Dispersion && Dispersion Radius)
* 增加了因相机曝光不足产生的噪点效果 (表情: Noise)
* 优化了SSSS (提高了一定的fps)