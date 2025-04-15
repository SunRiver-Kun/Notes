<!-- TOC -->

- [装饰器](#装饰器)
    - [类](#类)
    - [属性](#属性)
- [场景](#场景)
- [版本控制](#版本控制)
- [快捷操作](#快捷操作)

<!-- /TOC -->

# 装饰器 #
import { _decorator } from 'cc';
const { ccclass, property, ...其他装饰器 } = _decorator;

## 类 ##
@ccclass("test")   //或 @ccclass
export class test extends Component{ }

@menu("MyCmp/Test")     //添加到组件菜单

@executeInEditMode(true)    //让其在编辑器下运行，配合update用

@requireComponent(Sprite)   //没有组件时，自动添加组件

@executionOrder(order:number)  //同节点小于0先执行，不同节点按树结构. 只对onLoad,onEnable,start,update,lateUpdate有效，对onDisable和onDestroy无效

@disallowMultiple(true)     //同一节点上只允许添加一个同类型（含子类）的组件，

@help('https://docs.cocos.com/creator/3.5/manual/zh/scripting/decorator.html')


## 属性 ## 
CCInteger、CCFloat、CCBoolean、CCString: 可以直接@property，但其数组需要[Type]
其他cc类型：需要 @property({ type: Type })， Color、RealCurve、CurveRange、Gradient
其他@ccclass(name)并继承CCObject的数据
只有@property({type: tp})的属性才能被识别并序列化
注意：数组初始化并改类型后，需要先清楚数据再重新赋值，否则将导致数据错乱

@property({type: Type, [visible: true, serializable: true, tooltip: "", override: true], [min:0, max:100, step:1, range:[0, 100, 1], slide=true ], [  ]})      // _开头的默认是不显示的

@property({type: CCInteger})    --> @property   ||  @CCInteger  ||  @property(CCInteger)
value: number = 0;              --> value: number = 0;    

@property({type: [CCInteger]})
arr: number[] = [];

# 场景 #
Scene的检查窗口里的 AutoReleaseAssets 记得勾上，不然卸载场景时不会默认释放资源(直接或间接引用的)。
1. Asset.addRef() 来避免被默认释放
2. assetManager.releaseAsset() 来手动释放资源
3. isValid() 来判断是否有效
4. 脚本动态加载的只能由脚本动态释放

# 版本控制 #
Cocos Creator在新建项目时会生成 .gitignore 文件
只需要提交：
assets、extensions、settings、package.json和其他手动添加的关联文件

不需要提交：
build(构建生成)、library(导入生成)、local(本地配置)、profiles(编辑器信息)、temp(临时文件)

# 快捷操作 #
- 顶点吸附：v，表面吸附：Ctrl+Shift