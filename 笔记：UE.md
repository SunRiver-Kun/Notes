<!-- TOC -->

- [信息](#信息)
- [快速搜索](#快速搜索)
- [编辑器操作](#编辑器操作)
- [Config](#config)
    - [设备缓存](#设备缓存)
    - [可删除文件](#可删除文件)
    - [开发者文件夹](#开发者文件夹)
- [便捷操作](#便捷操作)

<!-- /TOC -->

# 信息 #
1. x轴是前，y轴是右，z轴是高。左手坐标系

# 快速搜索 #
鼠标悬浮在资源上可以看元数据，在资源搜索条那里可以搜索。不区分大小写，不需要空格
Triangles>=10500
Type==Skeletal || Type:BulePrint

# 编辑器操作 #
*Alt+左键*断开编辑器的线，*Ctrl+左键*更改编辑器的线，    右键可以参数化，并可以在外面创建实例。

*Tab或右键*：全部节点

*1/2/3/4+左键*： 创建常量数组，右键可以参数化
*S+左键*：一维数字参数
*V+左键*：四维数字参数

*3+左左*: 向量，Vector
*R+左左*: 引用向量，Reflection Vector
*N+左左*: 向量标准化，Normalize

*T+左左*: 贴图导入，Texture Sample
*U+左左*: 贴图坐标，TexCoord

*P+左左*: 坐标随时间变化，Panner
*B+左左*: 坐标高度变化，高度图，BumpOffset

*F+左键*：未定义函数，Unspecified Function
*C+左键*：注释，Comment

*E+左左*: Power，x^n
*O+左左*: 1-x
*A+左左*: Add，A+B
*D+左左*: Divide，A/B
*M+左左*: Multiply，A*B
*L+左左*: Lerp，A*(1-Alpha)+B*Alpha
*I+左左*: 判断，If

# Config #

## 设备缓存 ##
1. 删除 C:\Users\Administrator\AppData\Local\UnrealEngine\Common\DerivedDataCache
2. 修改 D:\Epic Games\UE_5.5\Engine\Config\BaseEngine.ini 的
ENGINEVERSIONAGNOSTICUSERDIR%DerivedDataCache 
-> GAMEDIR%DerivedDataCache

## 可删除文件 ##
Saved	包含引擎生成的文件，如配置文件和日志。这些文件可以删除并重新构建。

## 开发者文件夹 ##
作为沙盒环境使用，避免外部文件引用该文件夹。
Content Browser -> Settings -> Show Developer Content
Content Browser -> Filters -> Other Filters -> Other Developers
从烘焙版本中排除 Edit> Project Settings-> Directories to never cook -> Add Developers  

# 便捷操作 #
1. 使用*End*来快速使物体置于平面上
2. *Ctrl+左键*多选物体，*长按左键+中键*可以改变多选物体的锚点
3. 使用*F*聚焦到物体
4. 按住*Shift*拖拽物体，镜头可以跟着移动
5. 使用*Alt+拖拽*或*Ctrl+D*来复制选中的物体
6. Scene视图的上面的网格、角度、缩放量的时候，会按照后面的数值每次变化
7. Scene视图右上角可以设置摄像机移动速度，切换成4视图。
8. 可以在Scene视图的上面，设置表面对齐，在移动物体时贴合表面