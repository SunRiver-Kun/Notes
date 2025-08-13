<!-- TOC -->

- [环境](#环境)
- [字符串](#字符串)
- [枚举](#枚举)
- [事件](#事件)
- [元组](#元组)
- [序列化](#序列化)
    - [IO](#io)
    - [XML](#xml)
    - [JSON](#json)
- [格式](#格式)
- [其他](#其他)
    - [启动外部程序](#启动外部程序)
    - [Winform绘图](#winform绘图)

<!-- /TOC -->

# 环境 #
dotnet --info

donet build -c Release

# 字符串 #
C#的字符串是只读的、线程安全的，修改、拼接字符串会生成新的字符串。在拼接字符串多的情况下要用 StringBuilder
1. 比较char[]与string
bool ok = str.Equal(new string(char*))   //注意char[]不需要'\0'结尾！
2. 字符串内插， $" {表达式} " 
3. 逐字文本， @"c:\documents"

# 枚举 #
System.Enum.GetName ...

# 事件 #
委托和事件    不要用?.Invoke() ， 而要用 if(){}，否则空event的时候可能会报错
委托：类，包含+-=等，可以通过其他类Invoke
事件：类，类外只能+-=，不能Invoke

# 元组 #
元组，是值类型
var x = new ("sss",1,0f)  --> x.Item1  x.Item2
(string Name, int Value) x = new ("SSS", 0)   --> x.Name   x.Value
var (_,_,n) = fn();	//_表示弃用
public (string,int,int) fn() { return ("",1,0); }

# 序列化 #

## IO ##
System.IO{
	File -> Read|Write|Exists
	File.OpenRead()	File.OpenWrite并不会自动清空，要情况请用 Open(path, FileMode.Write)

	StreamReader/Writer
	BinaryReader/Writer	PeekChar()==-1
	Path{ HasExtension()、IsPathRooted()、GetFullPath()、GetTempPath()、GetTempFileName()、GetDirectoryName()、GetExtension }
	FileInfo -> Directory.GetFiles(目录) -> Create
	Directory.Exists/ GetFiles / Delete(path, true)
}

using System.Runtime.Serialization.Formatters.Binary;
BinaryFormatter{
	Serialize(FileStream, object data);
	object Deserialize(FileStream file);
}

unity   Application.persistentDataPath 

## XML ##
XML读写
using System.Xml;
XmlDocument doc = new XmlDocument();       
doc.Load(path);	//doc.LoadXml("<root>...</root>");
root = doc.FirstChild or doc.DocumentElement;
XmlElement.GetAttribute()
XmlElement["nodename"]

root = doc.CreateElement();
doc.CreatAttribute()  -> root.Attributes.Append()
doc.CreateElement() -> element.InnerText ->root.AppendChild(element)
doc.Save(path);

foreach(XmlElement v in folder.ChildNodes)  //XmlNode

## JSON ##


Json
using System.Text.Json;

string jsonString = JsonSerializer.Serialize(weatherForecast);

		string fileName = "WeatherForecast.json";
		string jsonString = File.ReadAllText(fileName);
WeatherForecast? weatherForecast = JsonSerializer.Deserialize<WeatherForecast>(jsonString);

# 格式 #
Class{
	public static T Instance => _Instance;
	static T _Instance;
	
	public Length = > _length;
	public value;
	private _length;
	void Fn(){} 
}

# 其他 #
## 启动外部程序 ##
using System.Diagnostics;
Process proc = new Process();
proc.StartInfo.FileName = "BuiltGame.exe";
proc.Start();

## Winform绘图 ##
System.Drawing
using System.Drawing;

-每秒都会重绘

-重写OnPaint
-event Paint
-Graphics.FromXXX
-this.CreatGraphics()




集合初始值设定项
Student s = new  Student[(...)]{ Name="Tom", Age = 18 }
var students2 = new Dictionary<int, StudentName>()
        {
            [111] = new StudentName { FirstName="Sachin", LastName="Karnik", ID=211 },
            [112] = new StudentName { FirstName="Dina", LastName="Salimzianova", ID=317 } ,
            [113] = new StudentName { FirstName="Andy", LastName="Ruth", ID=198 }
        };

7.?:、??、?.
p ?? false;	<-->  p!=null ? p : false
p?.fn()	<-->	p!=null ? p.fn() : null	//注：fn是事件或委托时可能为空而出错

8. 
if( dir.TryGetValue(key, out _TValue v) ) { v... }  
if( x is int num ) { print(num); }  //当x可以转为num时进入if	//is not
using(int x) { ... }  //自动析构x，Dispose
string fn(string v) => 
 v switch
{
      "A" => "Alice",
      "B"  => "BGM",
       _  =>  ""   //default
};

delegate(args...){ ... }
(args...)=>{...}

9. 
10. 属性
public bool x
{
	get => return __x;
	set => __x = value;
}
public bool x {get; private set;}   //默认false 0
public bool y {get; set;}	--和 public bool y; 一样
public T x => xxx		--> public T x => {return xxx;} 
public T fn(v) => {...}

public event Action x
{
	add { if(value==null) }
	remove { if(value==null) }
}

11.元组 (T1,T2,...)
(string,int) fn(string a, int b) { return (a,b); }
void fn( (string,int) v ) { v.Item1 = "";}
var (name, id) = fn("",1);	//用 _ 占位丢弃， name可以已声明，也可以没有
(string name, var/int id) 	(name, int id)
Class{
 public void Deconstruct(out T a, out T b) => (a, b) = (...);
}

隐式类型
var x = {"",123};
var arr = new[] { 1,2,33 };
var arr2 = new[] { new[]{1,2,3},  new[]{1} }


自定义类中可以用定义 Deconstruct 来实现元组
public void Deconstruct(out string fname, out string lname)


12.运算符重载
public static T operator @1(T a) 
public static T operator @2(T a, T b)
public static [implicit/explicit] operator targettype(T a)

不可重载但可由编译器自动生成： +=, -=, *=, /=, %=
不可重载：=, ., ?; ->, new, is, sizeof, typeof

值，string ==/Equals 比较的是内容，
引入的 == 比较引入，Equals重载后比较内容，所以用泛型时用Equals

13. 
Console.Write 尽量避免传值的object进去
Console.Write("{0:4}")
Console.Write($"{1+2} + {str}")	//{str}里的会执行
nameof(param)  //把变量的名变为字符串，为什么不直接copy呢

14. 委托
System
{	
	void Action<...>(... args)	--0~16
	TResult Func<..., TResult>(... args)	--0~16	
	bool Predicate<in T>(T obj);		//Find
	int Comparison<in T>(T x, T y);	//比较 return x-y;
	TOutput Converter<in TInput, out TOutput>(TInput input);	//转换

	//匿名函数写法
	x => x + 1;
	(x,y) => {return x > y;}
	(GameObjcet inst) =>{ ... } 
	delegate {...}  	//忽略参数
}

15. 
System.Collections.Generic;
System.Comparer<T>.Defult  ||  Comparer<T>.Creat(Comparison<T> fn)
List<T>   -->  vector
Stack<T>  --> stack
PriorityQueue<T, TPriority>  --> priority_queue
Queue<T>  --> queue
LinkedList<T>  --> list 
Dictionary<TKey,T Value>  --> map
HashSet<T>   --> set
SortedDictionary<TKey, TValue>
SortList<T>

16. 接口
System{
	IComparable<T>	-->  int (a, b)  a.CompareTo(b)   对a来说，1后  0不动 -1先前
	IEquatable<T>
	Predicate<T>	-->   bool fn(T)
}

System.Collections.Generic{
	IComparer<T>	--Comparer<T>.Default  
	IEqualityComparer<T>	--EqualityComparer<T>.Default 
	IEnumerable<T>  class  - foreach > GetEnumerator() -> IEnumerator<T>    当实现IEnumerable时，也应该建个迭代器实现IEnumerator
	IEnumerator<T>  return
	ICollection<T> : IEnumerable<T>
	IList<T> : ICollection<T>, IEnumerable<T>
	IDictionary<TKey,TValue> : ICollection<KeyValuePair<TKey,TValue>>, IEnumerable<KeyValuePair<TKey,TValue>>
}

System.Linq{
	IGrouping<TKey,TElement>
	IOrderedEnumerable<TElement>
	IOrderedQueryable<T>	
	IQueryable<T>
}

17. 泛型修饰符
in：类型可逆变 ( object -> int )
out：类型可协变( int -> object )

引用参数，不能在async, yield return, yield break 中使用
ref：在调用方法之前必须初始化参数。 该方法可以将新值赋给参数，但不需要这样做。
out：该调用方法在调用方法之前不需要初始化参数。 该方法必须向参数赋值。
ref readonly：在调用方法之前必须初始化参数。 该方法无法向参数赋新值。
in：在调用方法之前必须初始化参数。 该方法无法向参数赋新值。 
编译器可能会创建一个临时变量来保存 in 参数的自变量副本。调用时可以不加in

18. String.Format和字符串内插$	
https://docs.microsoft.com/zh-cn/dotnet/api/system.string.format?view=net-6.0
"{index[,alignment][:formatString]}"

19. 构造，赋值
class/struct XXX {...};
XXX v = new XXX(...) {name="", id = 111, ...};

https://docs.microsoft.com/zh-cn/dotnet/csharp/tutorials/string-interpolation
$"{value[,alignment][:formatString]}"   其中：{{, }}表单括号。 { (bool ? : ) }  三目括号起来

https://docs.microsoft.com/zh-cn/dotnet/standard/base-types/standard-numeric-format-strings

19. 接口和接口可以多继承，类可以继承一个基类和多个接口。C#继承只有public的

20. public static class Defs{
	public static const string name = "";
	public static const string value => ... ;
}

21. 反射
AppDomain.CurrentDomain.GetAssemblies() -> Assembly[] -> GetType() -type> Type.GetProperty() -PropertyInfo> GetGetMethod().Invoke(null, new object[]{}).ToString()

22. 约束  https://learn.microsoft.com/zh-cn/dotnet/csharp/programming-guide/generics/constraints-on-type-parameters
void Fn<T>(T v) where T : class, new(), XXClass, struct
return default;  ("Name", 11)

23. DLL
[DllImport("user32.dll", SetLastError = true)]
private static extern int GetSystemMetrics(int nIndex);

25. 
String 是不可变的，线程安全；
用StringBuilder来创建复杂的字符串相加；
$"{xxx} is run"

26. object 会创建值类型的副本，并存在堆上，和原本的栈上的值类型不再相关。装箱拆箱值类型有内存消耗。
拆箱会进行类型检测，需要尽量避免装箱拆箱。
lambda 捕获的变量不会作为垃圾回收直至lambda可回收。

27. 记录（record）是类(record class)或结构(record struct)，值相等性(值比较)、不可变性、ToString
public record Person(string FirstName, string LastName);

public record Person(string FirstName, string LastName){
    public required string[] PhoneNumbers { get; init; }
}	-->    Person person1 = new("Nancy", "Davolio") { PhoneNumbers = new string[1] };
public record Teacher(string FirstName, string LastName, int Grade): Person(FirstName, LastName);

Person person = new("Nancy", "Davolio");    
Console.WriteLine(person);
Person person2 = person with { 【FirstName = "John"】 };   //副本   

28. 
using forwpf = System.Windows;
forwpf::Point	global::System.Console

using System;
using (StreamReader reader = File.OpenText("numbers.txt")) { ...  }	//自动 reader.dispose()

29. 指针
unsafe
{
    int number = 27;
    int* pointerToNumber = &number;

    byte[] bytes = { 1, 2, 3 };  --  byte[] bytes = new byte[3]{ 1, 2, 3 };	堆
    fixed (byte* pointerToFirst = &bytes[0]){ ... }	--fixed 获取在堆上的地址，class、数组等

    char* pointerToChars = stackalloc char[123];	--栈  stackalloc 
}


其他：

CLI：Common Language Infrastructure，通用语言框架，包括CIL/CLR
IL：Intermediate Language 中间语言		
CIL：Common Intermediate Language 通用中间语言，.Net下的IL标准
CLR：Common Language RunTime 通用语言运行，编译CIL到机械语言

高级语言 -编译器> IL -即时编译JIT> CLR -> 虚拟机(.Net Framework / Mono VM) 执行

编译链接：
ECMA标准（Ecma- 334和Ecma-335），CLI就可以在.Net上用
.Net Framework：只运行在Window
Mono：开源项目，运行在各平台







