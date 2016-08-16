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

##### 3.0 全局设置 <font color=gray>(ray_controller.pmx)</font>:
* DirectLight+/-调整光照中整体光强
* IndirectLight+/-调整间接光照中整体光强 (暂时只能控制SSAO产生的GI)
* EnvLight+-调整来至天空盒的环境光强
* Exposure+- 调整整体的曝光强度
* BloomThreshold 调整提取最亮部分的阈值
* BloomIntensity 调整泛光的整体强度
* Vignette+- 调整窗口四周的暗角 (初始不产生暗角)
* SSAO+- 调整环境光遮蔽强度  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/3.1.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/3.1.png" width="50%" height="50%" align=left/>
 </a>

##### 4.0 制作基于物理的环境光贴图(IBL) :
　　预处理的环境光贴图需要对天空盒纹理处理所以需要借助以下工具
```
    https://github.com/dariomanesku/cmftStudio
```
* 4.1 启动cmftstudio
* 4.2 选择一张(dds,ktx,tga,hdr)的图片文件，如果没有这些格式需要自行转换
* 4.3 如下图点击右侧的图片然后浏览需要处理的天空盒图片  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.1.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.1.png" width="50%" height="50%" align=left/>
 </a>
* 4.4 点击Radiance中的Filter skybox with cmft，选中Exclude base和PhongBRDF以及Wrap模式并Process  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.2.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.2.png" width="50%" height="50%" align=left/>
 </a>
* 4.5 点击Irradiance中的Fiter skybox with cmft，直接点Process即可  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.3.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.3.png" width="50%" height="50%" align=left/>
 </a>
* 4.6 如下图分别保存出Radiance和Irradiance，因为MMD并不支持浮点格式纹理，因此保存为BGRA8
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.4.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.4.png" width="50%" height="50%" align=left/>
 </a>  
 <a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.5.png">
 <img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.5.png" width="50%" height="50%" align=left/>
 </a>
* 4.7 将导出的output_iem.dds和output_pmrem.dds放入Skybox/textures/目录中
* 4.8 如图PMXEditor打开skybox.pmx，这里Texture里放Radiance中的纹理SphereMap放Irradiance中的纹理  
<a target="_Blank" href="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.6.png">
<img src="https://coding.net/u/raycast/p/ray-mmd/git/raw/master/Tutorial/4.6.png" width="50%" height="50%" align=left/>
</a>
* 4.9 至此完成了IBL需要的纹理，这里SphereMap模式需要改为加算，不然会无效