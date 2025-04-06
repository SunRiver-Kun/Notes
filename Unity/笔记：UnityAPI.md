<!-- TOC -->

- [Event](#event)
- [Application](#application)
- [Mathf](#mathf)
- [GameObject](#gameobject)
- [UnityEngine](#unityengine)
    - [UnityEngine.Assertions.Assert](#unityengineassertionsassert)
    - [UnityEngine.Random](#unityenginerandom)
    - [UnityEngine.SceneManagement](#unityenginescenemanagement)
- [Animator](#animator)
- [Transform](#transform)
- [Vector3](#vector3)
- [Quaternion](#quaternion)
- [音/视频](#音视频)
- [截屏](#截屏)
- [物理](#物理)
    - [Physics](#physics)
    - [Rigidbody](#rigidbody)
    - [XXX Constraint](#xxx-constraint)
    - [Articulation Body](#articulation-body)
    - [Joint](#joint)
    - [Joint 2D](#joint-2d)
    - [Effector2D](#effector2d)
    - [Other](#other)
- [2D显示排序](#2d显示排序)
- [输入/控制](#输入控制)
    - [System.IO](#systemio)
    - [UnityEngine](#unityengine-1)
    - [UnityEditor](#unityeditor)
- [设置](#设置)
- [GUI](#gui)
- [UGUI](#ugui)
- [渲染](#渲染)
- [Job System](#job-system)
    - [NativeArray](#nativearray)
    - [IJob](#ijob)
    - [IJobParallelFor](#ijobparallelfor)
    - [IJobFor](#ijobfor)
    - [ParallelForTransform](#parallelfortransform)
- [优化](#优化)

<!-- /TOC -->


# Event #
--事件转发
UnityEngine.Events.UnityEvent<>，编辑器可以添加public的参数或最多带一个参数的函数。添加时，最上面的dynamic表示代码传入对应参数
简单的也可以用System.Action<>，不过Action可能为空，而UnityEvent不为空(public的编辑器自动实例化，不过建议手动new)
注：Action要判空，物体摧毁时要手动取消。
编辑器的UnityEvent会自己创建，在物体销毁后，只有函数无关物体才会调用！
子物体的析构函数在GameObject.Destroy时不会马上调用！ 

# Application #
{	
	isPlaying
	Quit()、OpenURL、installerName
	dataPath(..Assets)、streamingAssetsPath(..Assets/StreamingAssets)、
	consoleLogPath、temporaryCachePath、persistentDataPath	   Users/AppData/Local/...
	event:  logMessageReceived		//关于Scene的不要用，异步时会漏掉的
}

# Mathf # 
{
	float Clamp(value, min, max)	--返回[min,max]之间的值
	float Lerp(a, b, time)		-- time[0~1]，按time插值	return a*(1-t) + b*t
	--在Update中Lerp平滑，  value = Mathf.Lerp(value, target, Time.deltaTime * speed)
	float PingPong(t, max)	--摇摆t的值，且不大于max，也不小于0
	bool Approximately(a, b)	-- a==b，是否十分接近
	float DeltaAngle(a, b)		--计算两个角度间的夹角？	
	Ceil、Round(a)		--取整，System.Convert.ToInt32(a) , (int)
	Epsilon(很小的常量)、Infinity(正无穷)、NegativeInfinity(负无穷)、PI、Deg2Rad、Rad2Deg
	MoveTowards (current, target, maxDelta);   maxDelta正近，负离。  不会越过target
}

# GameObject #
{
	static FindGameObjectWithTag(tag)	
	static Find(name)

	CompareTag(tag)	//tag必须是已注册过的，不会会报错

	//组件获取，不管是否禁用都可以获取到
	GetComponent(type:string|Type)	GetComponent<T>()	

	//下面的涉及自身和子（父）对象是否已激活
	GetComponentInChildren<T>(bool includeInactive=false)	//自身一定，未激阻断
	GetComponentInParent<T>(bool includeInactive=false)	//自身一定，未激阻断
	BroadcastMessage(methodname[, parameter])	//逐级递推，未激阻断   未激活对象调用BroadcastMessage直接阻断
}

# UnityEngine #
## UnityEngine.Assertions.Assert ##
{
	IsNull、AreEqual、IsTrue
}

## UnityEngine.Random ## 
{
static:
	rotation、rotationUniform、value[0f,1f]、
	insideUnitCircle、insideUnitSphere、onUnitSphere
	Range[a,b]、ColorHSV()	
	InitState(seed)
}

## UnityEngine.SceneManagement ##
{
	SceneManager{
		LoadScene(index,type)   --从0开始编号，bulid Settings最上面改
	}
}

# Animator #
{
	IK、SetValue、GetValue、Play
}
UnityEditor.Animation{...}

# Transform #
{
	LookAt(Transform target, Vector3 worldUp)
	Vector3 TransformDirection(Vector3 direction)  //局转世，返长度一样，不受缩放或位置影响
	Vector3 InverseTransformDirection(direction)  //世转局，不受缩放影响
	Vector3 TransformPoint (Vector3 position)  //局转世，返回点受缩放影响
	Vector3 InverseTransformPoint (position);  //世转局，返回点受缩放影响
	position、eulerAngles、forward、right、up、rotation(四元素)
	childCount, parent, root,  
	Find("sub/subb"), GetChild(index), SetParent()
}

# Vector3 #
{
	Normalize()、normalized、magnitude、sqrMagnitude、x、y、z、Set()、ToString()	
static:
	+-Vector3、 float*float、/float、== !=、Equal()、Max()、Min()
	up、down、left、right、forward、back、one、zero、positiveInfinity、negativeInfinity
	Normalize()、OrthoNormalize()、Scale()、ClampMagnitude()、Cross(x)、Dot(.)
	Project()、ProjectOnPlane()、MoveTowards()、Reflect()
	Angle()、SignedAngle()、RotateTowards()、Distance()
	Lerp()、LerpUnclamped、Slerp()、SlerpUnclamped()、SmoothDamp()
}

# Quaternion #
{	
	eulerAngles、normalized、Set()、SetFromToRotation、SetLookRotation()、ToAngleAxis()、ToEulerAngles()
static:
	identity
	Angle()、AngleAxis()
	Euler(x,y,z)	--按°来旋转，左手螺旋
	*FromToRotation()*、Inverse()、LookRotation(direction, upward)、
	[S]Lerp()、[S]LerpUnclamped()、RotateTowards(from,to,maxdelta)
	Vector3 operator *(Quaternion rotation, Vector3 point);	//旋转后的另一个点
        	Quaternion operator *(Quaternion a, Quaternion b);	//∠a + ∠b
}

# 音/视频 #
AudioPlayer、AudioSource、VideoPlayer
UnityEngine.Audio{ 
	AudioMixer、AudioMixerGroup、AudioMixerPlayable
}

# 截屏 #
ScreenCapture{
	CaptureScreenshot(filename)
	Texture2D CaptureScreenshotAsTexture()

	SDK ->  LoadImage(...) -> Texture
}

# 物理 #
## Physics ##
{		
	public const int IgnoreRaycastLayer = 4;
        	public const int DefaultRaycastLayers = -5;	//除IgnoreRaycastLayer外的所有图层
        	public const int AllLayers = -1;
	public Vector3 gravity
	//LayerMask  Nothing=0  Default = 1   1<<x   	(x&1<<n) == 0

	bool RayCast( pos, direction[,out hitobjs], distance[, layout] )	--check colliseder
	bool CheckBox(Vector3 center, Vector3 halfExtents, Quaternion orientation);
	bool SphereCast(Vector3 origin, float radius, Vector3 direction, out RaycastHit hitInfo);
}	
ray = Camera.main.ScreenPointToRay(Input.mousePosition);
XXCollider.Raycast(Ray ray, out RaycastHit hitInfo, float maxDistance);


## Rigidbody ##
{	//relative 物体坐标系，否则全局坐标系
	SetDensity(float density)	--设置密度
	AddForce(Vector3 force, mode = ForceMode.Force)	--添加力
	AddTorque(Vector3 torque, mode = ForceMode.Force)	--添加力(转/扭)矩
	Sleep()	--强制让刚体睡眠至少一帧
	velocity(速度)、mass(质量,一般为0.1-10)、drag(摩擦力)
	
}

## XXX Constraint ##
{
	Aim	//旋转
	Look At	//简化的旋转，对于摄像机，镜头始终指向forward，即它的Z轴
	Parent	//位移和旋转，有惯性？不灵活！
	Position、Rotation、Scale	//单个
--先加Look At，后加Postion，实现镜头跟踪物体。反之会出现剧烈抖动！    注：Move Up/Down等不改变组件的添加顺序！
--Active：激活约束，即Lock and Active
--Zero：重置偏移量等
--XXX Rest：静止时（权为0时）
--XXX Offset：运动时
--Freeze XXX：对与position是启用，对于Rotation是禁用
}

效果 = 刚度 * (drivePosition - targetPosition) - 阻尼 * (driveVelocity - targetVelocity)  Stiffness：刚度	Damping：阻尼

## Articulation Body ##
{	接连体，用于Transform，模拟机械臂
   Joint{
固定	Fixed：固定关节，无附加属性
棱形	Prismatic：阻止除了沿特定轴滑动之外的所有运动
旋转	Revolute：允许绕特定轴旋转（如铰链）。
球形	Spherical：允许两次摆动和一次扭转。
}}

## Joint ##
{	*表示有电机
角色	Character：模拟球窝关节，例如臀部或肩膀。沿所有线性自由度约束刚体移动，并实现所有角度自由度。GameObject -> 3D ->Ragdoll(布娃娃)
*任意	Configurable：模拟任何骨骼关节，例如布娃娃中的关节。您可以配置此关节以任何自由度驱动和限制刚体的移动。
固定	Fixed：	限制刚体的移动以跟随所连接到的刚体的移动。无需Transform父级化
*铰链	Hinge：物体可绕某点旋转，门
弹簧	Spring：沿轴线施力，尝试让物体保持一定距离
}
Constant Force 恒定力

## Joint 2D ##
{	关节
距离	Distance：保持该刚体和另一个刚体或位置(None)的固定或最大距离
摩擦力	Friction：摩擦关节将对象之间的线速度和角速度降低到零
*铰链	Hinge：物体可绕某点旋转，门，电机
固定	Fixed：保持固定的距离和角度，弹簧，震动，锚点
*相关	Relative：保持固定的距离和角度，电机，偏移
*滑动	Slider：让物体只在一条直线上运动，电机，自动门/开关
弹簧	Spring：沿轴线施力，尝试让物体保持一定距离
目标	Target：尝试把物体移动到某点
*车轮	Wheel：弹簧让锚点沿Angle线重合，Motor让Connected Rigidbody转起来。挂车身上，车身把旋转关了避免翻车，车身用多边形碰撞器
}

## Effector2D ##
{   //效应器，同一物体无法添加多个效应器
	Platform：控制碰撞图层、单向碰撞、消除侧向摩擦/弹性等
	Surface：传送带，通过可随机speed来控制的，和人物移动冲突
	Point：引力/斥力点，可加随机力，反线性或反平方比例力
	Buoyancy：漂浮，可加随机力
	Area：定向可加随机力
}

## Other ##
Bounds{
	bool IntersectRay(Ray ray, out float distance)  -->  Ray.GetPoint(Math.Abs(distance))
}

--特殊的碰撞体
Character Controller{   不使用刚体的玩家角色，需要自己模拟重力
	不会对力作出反应，也不会自动推开刚体，不会触发OnCollideXXX，但可以触发Trigger
	回调：OnControllerColliderHit(other)	
	skinwidth最好是radius的10%左右
	CollisionFlags Move(Vector3 motion)   //世系，位移，不加重力
	bool SimpleMove(Vector3 speed)  //世系，速度，忽略y轴输入，自动加重力
}
Terrin Collider
Wheel Collider
Mesh Collider
Cloth：布料，与蒙皮网格渲染器一起使用。添加碰撞体（球/胶囊）体后只能响应力，不能施力。Obi Cloth

# 2D显示排序 #
SortGroup：对子物体按父物体来设置渲染
Sprite Render{
	DrawMode: Simple(非9切片、全缩放)，Sliced(拉伸不重复) and Tiled(可限制的重复)，用Full Rect，改Size，仅支持Box/Polygon Collider2D    
}
SpriteAtlas{ 图集，压缩存储的图片，可通过脚本进行加载。但一个图片在多个图集且都包含在Build时，可能随机选择其一的图片进行渲染
	int GetSprites(Sprint[] arr)
}
Sprite Shape Render、Sprite Controller(package: Sprite Shape)	https://www.jianshu.com/p/100597b24f02

# 输入/控制 # 
Input{
	默认：下上全过程多次调用	Down：按下，一次	Up：弹起，一次
	bool GetButton(string)		bool GetKey(KeyCode)		bool GetMouseButton()	0 左键 1 右键 2 中键
	bool GetButtonDown(string)		bool GetKeyDown(KeyCode)		bool GetMouseButtonDown()
	bool GetButtonUp(string)		bool GetKeyUp(KeyCode)		bool GetMouseButtonUp()
	float GetAxis("Horizontal" or "Vertical")  //float
	mousePosition
	//移动设备
	touches
	acceleration	//以主屏幕按钮为底部，竖直，右x上y前z
}
TouchScreenKeyboard.Open() 	//打开移动键盘
Cursor{ lockedState、visible}
//XR输入
UnityEngine.XR{  InputDevices、Input.CommonUsages  }

CharacterController{		不是很好用……
	CollisionFlags Move(Vector3 motion)	--不考虑重力，返回碰撞到的碰撞器
	SimpleMove(Vector3 speed)	--以 m/s 的速度移动(初速度)，自动添加重力(忽视传入的speed的y)
	isGrounded	--最后一次移动后，是否碰到地面
	velocity、slopeLimit、stepOffset(将影响刚体的下落速度！)
	、radius、height、center
}
 # 文件、资源管理 #
PlayerPrefs：通过key来保存数据，简单
ScriptObject：单独存数据，Reset,    Awake->OnEnable->OnDisable->OnDestroy  
	OnValidate，Editor only，当脚本被加载或值在Inspector中改变时调用
	配合[CreateAssetMenu(menuName="Settings",fileName="Settings")]
## System.IO ##
{
	FileInfo{
		if (!info.Directory.Exists) { info.Directory.Create(); }	//判断或创建路径

		bool isDir = (info.Attributes & FileAttributes.Directory) != 0   //是否是文件夹
	}
	File
	TextReader/Writer
	BinaryReader/Writer
	Path
}

## UnityEngine ##
{
	[System.Serializable] class Data{}
	ScriptableObject{
		public List<Data> values= new();
		[System.NonSerialized] privat Data current;   //不加System.NonSerialized则会序列化，但在编辑器下看不见
	}

	--.json放Application.streamingAssetsPath，也可放Resources->TextAssets->JsonUtility.FromJson<T>
	JsonUtility{ --使用Unity 序列化器，要创建的自定义结构体……public、[SerializeField]， not : static、private、[System. NonSerialized]
		Type FromJson<Type>(string json)	--Type: 只支持普通类和结构，不支持派生自 UnityEngine.Object 的类（如 MonoBehaviour 或 ScriptableObject）。
		string ToJson(object obj, bool prettyPrint = false)  --obj必须是 MonoBehaviour、ScriptableObject、[Serializable] 的类/结构体
	}
	--Shader
	 Material material = new Material (Shader.Find("Specular"));
	--File
	Resources{  "Assets/**/Resources"里的资源全部包含进打包，名字不能重复，会压缩！
		FindObjectsOfTypeAll(type)  //返回已加载的Unity对象，包括场景的和磁盘中的
		InstanceIDToObject(id)、InstanceIDTOObjectList(ids,objs)
		//path相对于Resources文件夹的，不包含后缀
		//txt,json->TextAsset  png->Texture2D/Sprite...  mp3->AudioClip
		Load<T>(path)
		LoadAll(filename || resourcespath, type)
		LoadAsync(path, type)  //异步   yield return 	
		//某些资源(纹理)在场景中不存在其实例时，也会占用内存
		UnLoadAsset(assetobject)   //从磁盘中销毁Asset，但之后还有引用则用到时重新加载回来
		UnLoadUnusedAssets()   //异步，必须是无任何引用的!  (AB.Unload(),  prefab=null)
	}	
	UnityWebRequest{   加载网络或StreamingAssets的资源  }
	--AssetBundle
	AssetBundle{	
		加载的AssetBundle是总内存，LoadAsset后分配新内存并反序列化给Asset
		AB包不会自动加载引用的Asset，而Resources和直接拖拽的会自动加载

		LoadFromFile(Path.Combine(Application.streamingAssetsPath, "AssetBundles"))	//加载失败返回null
		LoadAsset<T>("MyObject")	--> Resources.UnLoadAsset(assetobject)     UnLoadUnusedAssets()
		Unload(unloadAllLoadedObjects)	//卸载AB包，以及是否卸载从AB包出来的Asset       只有卸载AB包后，用Resources.UnLoadUnusedAssets()才能销毁从AB包出来的无用资源
	}

	--网络的AssetBundle，需要使用协程
	var request = Networking.UnityWebRequestAssetBundle.GetAssetBundle(url, 0);
	yield return request.Send();
	AssetBundle bundle = UnityEngine.Networking.DownloadHandlerAssetBundle.GetContent(request);

	--管理AssetBundle之间的依赖关系的     AssetBundleManifest
	AssetBundle assetBundle = AssetBundle.LoadFromFile(Defs.AssetBundlePath + "/manifestFile".ToLower());
	AssetBundleManifest manifest = assetBundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
	string[] dependencies = manifest.GetAllDependencies(“assetBundle");
	foreach(string dependency in dependencies){ AssetBundle.LoadFromFile(Path.Combine(assetBundlePath, dependency)); }
}
## UnityEditor ##
{
	--path = "Assets/XXX";
	AssetDatabase{  -- 导入-> 加载	要保留meta，推荐用这个类而不是System.IO
		ImportAsset("Assets/Textures/texture.jpg", ImportAssetOptions.Default);
		LoadAssetAtPath<Texture2D>("Assets/Textures/texture.jpg");
		Contains、CreateAsset、CreateFolder、RenameAsset、
		CopyAsset、MoveAsset、MoveAssetToTrash 、 DeleteAsset
	}
	EditorUtility{
		SaveFilePanel、SaveFolderPanel	...
		IsPersistent(Object target)  //确定对象是否存储在磁盘中。场景中的返false
	}
	ObjectFactory{  自动Undo注册
		AddComponent、CreateGameObject、CreateInstance、CreatePrimitive	
	}
	Presets.Preset{...}
	PrefabUtil
}

--时间
Time{
	deltaTime	--帧之间的间隔
	fixedDeltaTime
}

# 设置 #
（默认在UnityEngine）
UnityEngine{
	AudioSettings	--只能得到一些参数
	QualitySettings
Rendering.GraphicsSettings
	Physics、Physics2D
	SortingLayer  ->  LayerMask
	Time 
}
UnityEditor{
	EditorSettings
	PlayerSettings
}

# GUI #
{	--坐标系采用屏幕坐标系（左上角）  	(0,0) ↓y →x	--写在 OnGUI，每帧至少执行2次（一绘制，二响应）
--有些时候要保存数据要建个类成员
--Screen.xxx	直接用
--可以在组件上加属性 [ExecuteInEditMode]，来“预览”，交互print不怎么样
	if( GUI.Button(...) )  { ... }  
	slidervalue = GUI.HorizontalSlider(new Rect(0, 0, 200, 1000), slidervalue, 0, 100);	//代码实时更新，不过print处理就有点问题
}
GUILayout、GUILayoutUtility、EditorGUILayout
--调试/help
Debug{
	DrawRay( pos, vector, color)	--绘制射线
	Log(string)
}

Gizmos：{	--写在 OnDrawGizmos	OnDrawGizmoSelected
--绘制一些图案，帮忙确定距离等。在Game中不显示，而在Editor中实时显示
	Color
	DrawWireSphere、DrawIcon、DrawGUITextures	
}
Handles{ --自定义Editor时，绘画用	}

# UGUI #
Resolution.width/height
Screen{
	width/height 
	Screen.SetResolution(screenWidth, screenHeight, isFullScene);
	fullScreen
	currentResolution
}    
Cursor{
	lockState
	visible
}
Button、Text、Image、RawImage(Texture)ScrollRect、Scrollbar、Slider、Toggle、DropDown
TMPro{ TextMeshProUGUI、TMP_Dropdown  }
Selectable、ToggleGroup、InputField 
HorizontalLayoutGroup、VerticalLayoutGroup、GridLayoutGroup
AspectRatioFitter(等比)、ContentSizeFitter(子内容调大小，pivot位置不动)
Effects/Outline、PositionAsUV1、Shadow

UnityEngine.UI{	基本的UI控件
//找不到命名空间，把代码打开方式改为VS，打开一次，再改回VS Code即可。或更新Package里的vscode扩展
https://docs.unity3d.com/Packages/com.unity.ugui@1.0/manual/UIBasicLayout.html
	
}
UnityEngine.EventSystems{	管理点击等事件的触发，包含自定义UI接口
	EventSystem	->   事件发送器
	EventTrigger	->   添加该组件，设置其UnityEvent
	IPointerClickHandler, IPointerEnterHandler, IPointExitHandler  ...
}
坐标系转换：WorldToLocal、LocalToWorld、ChangeCoordinatesTo 本地Vector2/Rect与Panel坐标空间转换

# 渲染 #
--渲染，摄像机
UnityEngine.Rendering{
	RenderPipelineAsset 
	GraphicsSettings.renderPipelineAsset 
}

--是否被渲染，性能消耗较大
var planes = GeometryUtility.CalculateFrustumPlanes(mainCamera);
GeometryUtility.TestPlanesAABB(planes, GetComponent<Collider2D>().bounds)

# Job System #
仅能使用的类型
NativeArray<T>  引用，多读，单写   [ReadOnly]属性标志只读来优化
byte(255), sbyte(127), [u]int16, [u]int32, [u]int64, [U]IntPtr, float, double, Vector3

不能使用 class, T[], interface, object 等托管类型
不安全 static 静态数据，会绕开安全系统，可能导致崩溃

通过struct继承下列接口，并实现Execute接口，只能在*主线程*内传入NativeArray等参数后，Job.Schedule、JobHandle.Complete、NativeArray.Dispose()

注：Schedule只是加入了执行队列，要立刻运行JobHandle.Complete，不过会有一定性能开销
## NativeArray ##
{ 
	<T>  T是值类型，不能是托管类型
	Allocator{
		Persistent(长期存在)、TempJob(4帧内dispose)、Temp(return前dispose)
	}
    new NativeArray<Vector3>(arrSize, Allocator.TempJob);
	void Dispose()
}
## IJob ##
{
   public void Execute() {}

   public JobHandle Schedule(JobHandle depend = null);
}
## IJobParallelFor ##
{
	public void Execute(int i) { arr[i]; }

	//对应大规模计算loopSize为1，轻量级可以是32或64，本质是在循环中调用Execute(i)的无开销内循环。
	public JobHandle Schedule(arr.Length, loopSize, JobHandle depend = null);  
}
## IJobFor ##
{

}

## ParallelForTransform ##
专门为并行处理Transform准备的

# 优化 #
--对象池	 2021以上
UnityEngine.Pool{
	ObjectPool<_Ty>
}
