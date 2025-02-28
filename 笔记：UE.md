<!-- TOC -->

- [API](#api)
    - [添加组件](#添加组件)
- [信息](#信息)
- [Gameplay框架](#gameplay框架)
- [快速搜索](#快速搜索)
- [编辑器操作](#编辑器操作)
- [Config](#config)
    - [设备缓存](#设备缓存)
    - [可删除文件](#可删除文件)
    - [开发者文件夹](#开发者文件夹)
- [便捷操作](#便捷操作)

<!-- /TOC -->

# API #

## 添加组件 ##
如果组件应默认附加到Actor上，则应在Actor的构造函数中添加该组件。
UObject::CreateDefaultSubObject 函数添加组件。
点击蓝图编辑器 组件（Components） 面板中的 + 添加（+ Add） 
点击细节面板（Details Panel）中的 + 添加（+ Add） 按钮

# 信息 #
1. x轴是前，y轴是右，z轴是高。左手坐标系

# Gameplay框架 #
Actor: Entity，可以给它添加Component，本身不含位移等。添加网络同步
    -> World->SpawnActor
Pawn: 物理实体，Npc，角色。放血条等通用组件
    -> DefaultPawn：带有移动。球体碰撞组件、静态网格体组件
        -> SpectatorPawn：观察机制的移动。球体碰撞组件、无静态网格体组件
    -> Character：角色，CapsuleComponent、CharacterMovementComponent、SkeletalMeshComponent、SpringArmComponent、CameraComponent、ArrowComponent
Controller: 控制Pawn，Pawn销毁时Controller也可继续存在。
    -> AIController: 控制Npc及相关内容。BehaviorTree、AIMove(Nav)
    -> PlayerController: HUD、Input、PlayerCameraManager，玩家相关
HUD: Heads-up Display，抬头显示器。覆盖在显示器上，不可交互
UI: User Interface，用户界面，菜单等可交互。可以用UMG创建
GameMode：仅服务器，每关一个，加载关卡时最早实例化的Actor，定义一些默认类，项目->地图和模式（全局） || 世界场景设置（某关）
    :GetGameMode()，一关内的全局数据
GameState: 服务器&&客户端，网络同步，非实体Actor，游戏整体状态，仅一个由GameMode创建，所有玩家数据逻辑
GameInstance: 服务器和客户端单独存在，引擎启动时创建，并一直Active直到引擎关闭，
    不同关卡中都用到的数据, 存档等, 
    创建多个游戏子系统SubSystems，OnlineSubSystems等。生命周期和GameInstance一致
PlayerState: 非实体Actor，关联的玩家数据逻辑


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
8. 可以在Scene视图的上面，设置表面对齐，在移动物体时贴合表面。或者*V+拖拽*