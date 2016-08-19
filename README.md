Ray-MMD
========
### 基于物理的MikuMikuDance渲染库 ###
#### Screenshot :
[![link text](Screenshot/LuoTianYi_small.png)](Screenshot/LuoTianYi.png)
[![link text](Screenshot/pistol_small.png)](Screenshot/pistol.png)

#### 教程 :
##### 1.0 文件夹介绍 :
* EnvLighting : 环境光(IBL)相关特效
* Main : 添加物体基本的光照
* Materials : 用于指定物体材质 (如皮肤，金属，天空盒....)
* Shadow : 用于渲染物体阴影的特效
* Skybox : 基本的天空盒特效和纹理
* ray.conf : 配置文件(可自行修改)
* ray.x : 渲染主文件
* ray_controller.pmx : 调整光强，SSAO，泛光..等效果
* ColorBalance.pmx : 色彩平衡

##### 2.0 载入模型 :
* 将ray.x载入到MMD中
* 添加Skybox/skybox.pmx并且在MaterialMap选择Materials/material_skybox.fx  
[![link text](Screenshot/2.2.png)](Screenshot/2.2.png)
* 添加任意模型到MMD，并在Main板块选择Main.fx
* 在MaterialMap板块中，对刚载入的模型在Materials文件夹中选择对应的材质
* 分配完后效果图如下:  
[![link text](Screenshot/2.5_small.png)](Screenshot/2.5.png)

##### 3.0 全局设置 <font color=gray>(ray_controller.pmx)</font>:
* DirectLight+/-直接光照中整体光强
* IndirectLight+/-间接光照中整体光强 (暂时只能控制SSAO产生的GI)
* EnvLight+-环境光的漫反射光强
* EnvSpecLight+-环境光的镜面光强
* SSAO+- 环境光遮蔽强度  
* BloomThreshold 提取最亮部分的阈值
* BloomIntensity 泛光的整体强度
* Exposure+- 曝光强度
* Vignette+- 窗口四周的暗角
* ToneMapping 色调映射的鲜艳度 (为0时采用FimicToneMapping, 为1时线性曝光)
* ShoStrength 亮度 (当ToneMapping越大时改值影响越大)
* LinStrength 灰度 (当ToneMapping越大时改值影响越大)
* LinWhite    消光 (当ToneMapping越大时改值影响越大)
* ToeNum      饱和度 (当ToneMapping越大时改值影响越大)
[![link text](Screenshot/3.1.png)](Screenshot/3.1.png)

##### 4.0 制作基于物理的环境光贴图(IBL) :
　　预处理的环境光贴图需要对天空盒纹理处理所以需要借助以下工具
```
    https://github.com/dariomanesku/cmftStudio
```
* 启动cmftstudio
* 选择一张(dds,ktx,tga,hdr)的图片文件，如果没有这些格式需要自行转换
* 如下图点击右侧的图片然后浏览需要处理的天空盒图片  
[![link text](Screenshot/4.1_small.png)](Screenshot/4.1.png)
* 点击Radiance中的Filter skybox with cmft，选中Exclude base和PhongBRDF以及Wrap模式并Process  
[![link text](Screenshot/4.2_small.png)](Screenshot/4.2.png)
* 点击Irradiance中的Fiter skybox with cmft，直接点Process即可  
[![link text](Screenshot/4.3_small.png)](Screenshot/4.3.png)
* 如下图分别保存出Radiance和Irradiance，因为MMD并不支持浮点格式纹理，因此保存为BGRA8
[![link text](Screenshot/4.4_small.png)](Screenshot/4.4.png)
[![link text](Screenshot/4.5_small.png)](Screenshot/4.5.png)
* 将导出的Irradiance和Radiance放入Skybox/textures/目录中
* 如图PMXEditor打开skybox.pmx，这里Texture里放渲染天空的纹理，Tone放Irradiance中的纹理SphereMap放Radiance中的纹理  
[![link text](Screenshot/4.6.png)](Screenshot/4.6.png)
* 至此完成了IBL需要的纹理，这里SphereMap模式需要改为加算，不然会无效

#### 借物表 :
* Model :  
　　TDA China Dress Luo Tianyi Canary Ver1.00 [Silver]
* Scene :  
　　シンプル風ステージ