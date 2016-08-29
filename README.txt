Ray-MMD

基于物理的MikuMikuDance渲染库

项目主页 :
    https://github.com/ray-cast/ray-mmd

更新内容 :

2016-8-30 ver 1.0.3 beta
* 改进默认材质对Diff&Spec的兼容
* 添加了新的HDR和工具，以及更新HDR制作教程(现在可以支持HDR的天空了)
* 添加了LightMap用于渲染多个光源
* 添加了点光源，聚光灯，方形区域光和球形区域光 (都会根据材质进行光照)
* 添加了天空盒旋转表情 (EnvRotateX/Y/Z)
* 添加了主光源阴影用于IBL的表情 (EnvShadow)
* 添加了Blub表情 (B快门)

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