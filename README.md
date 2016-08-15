Ray-MMD
========
### 基于物理的MikuMikuDance渲染库 ###
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

##### 2.0 载入模型 :
* 2.1 将ray.x载入到MMD中
* 2.2 添加Skybox/skybox.pmx并且在MaterialMap选择Materials/material_skybox.fx  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/2.2.png">
     <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/2.2.png" align=left/>
 </a>
* 2.3 添加任意模型到MMD，并在Main板块选择Main.fx
* 2.4 在MaterialMap板块中，对刚载入的模型在Materials文件夹中选择对应的材质
* 2.5 分配完后效果图如下:  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/2.5.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/2.5.png" width="50%" height="50%" align=left/>
 </a>

##### 3.0 调整全局设定 :
* 3.1 将ray_controller.pmx载入MMD中  
* 3.2 DirectLight+/-调整光照中整体光强
* 3.2 IndirectLight+/-调整间接光照中整体光强 (暂时只能控制SSAO产生的GI)
* 3.3 EnvLight+-调整来至天空盒的环境光强
* 3.4 Exposure+- 调整整体的曝光强度
* 3.5 BloomThreshold 调整提取最亮部分的阈值
* 3.6 BloomIntensity 调整泛光的整体强度
* 3.7 Vignette+- 调整窗口四周的暗角 (初始不产生暗角)
* 3.8 SSAO+- 调整环境光遮蔽强度  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/3.1.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/3.1.png" width="50%" height="50%" align=left/>
 </a>