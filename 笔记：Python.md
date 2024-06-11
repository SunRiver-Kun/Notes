<!-- TOC -->

- [基础知识](#基础知识)
- [输出](#输出)
- [文件](#文件)
    - [序列化](#序列化)
- [sys库](#sys库)
- [os库](#os库)
- [re库](#re库)
- [json库](#json库)
- [urllib库](#urllib库)
- [其他标准库](#其他标准库)
- [扩展库](#扩展库)

<!-- /TOC -->

# 基础知识 #

1. 注释：#
2. 字符串：  "", '' , + , \跨行+    原字符串r""
3. 导入
整个模块 import moudle      -->   moudle.fn()
模块中某函数  from moudle import fn[, fn2]   -->  fn()
模块中全部函数 from moudle import *  --> fn()
父级路径下的 from ..othermodule import *

__init__.py 导入时调用，每个文件夹都需要，可以放给空文件
sound/                          顶层包
      __init__.py               初始化 sound 包 
      formats/                  文件格式转换子包
              __init__.py
              wavread.py
              ...
      effects/                  声音效果子包
              __init__.py       --> 进行赋值，表示文件夹里有哪些可导入的module  __all__ = ["echo", ...]
              echo.py
              ...
      filters/                  filters 子包
              __init__.py
              equalizer.py
              ...


4. 保留关键字
'False', 'None', 'True', 'and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield'
5. Python 根据缩减换行
6. 类型
不可变数据：Number（int, float, bool(True, False), complex）、String（"", '', Unicode）、Tuple（(v1, v2)）、bytes（0~255 整, b"chars", b[0]==ord("a")）；
可变数据：List（[v1, v2]）、Dictionary（{}, {key:value}, [key]=value）、Set（set(), {v1, v2}, -,|,&,^）。

String, List, Tuple:     str[0], str[0, -1], str[0:] ,  str[start, end=start, step=1]  截取[start, end) 的字符串

type(value) == int    --不考虑是否是继承
isinstance(value, class)   --考虑是否继承

转换函数：
int(x [,base])，float(x)，str(x)，complex(real [,imag])
repr(x) 将对象 x 转换为表达式字符串
eval(str) 用来计算在字符串中的有效Python表达式,并返回一个对象
tuple(s) 将序列 s 转换为一个元组
list(s) 将序列 s 转换为一个列表
set(s) 转换为可变集合
dict(d) 创建一个字典。d 必须是一个 (key, value)元组序列。
frozenset(s) 转换为不可变集合
chr(x) 将一个整数转换为一个字符
ord(x) 将一个字符转换为它的整数值
hex(x) 将一个整数转换为一个十六进制字符串
oct(x) 将一个整数转换为一个八进制字符串
deque() 双向列表，需要先导入  from collections import deque

7. 2/4-->float   2//4-->int   2**4-->pow(2,4)=16
8. 安装 pip install xxx 
9. 变量
a, b, c = 1, 2, 3
del a, b, c
全局变量定义在开头无缩进即可
10. cmd使用交互式ptyhon，输入 py 或 python
11. cmd运行python代码，py xx.py
12. 条件
if condition_1:
    statement_block_1
elif condition_2:
    statement_block_2
else:
    statement_block_3

if (n:=xxx) > 1:    --临时变量n
if value in list:
if value not in list:

13. 循环
while xxx:
for v in list:
for v in sorted(list):   --遍历一个新的排序好的
for i, v in enumerate(list):
for k,v in map.items():
for i in range(start, end[, step]):    [start, end)
for i in reversed(range(1, 10, 2)):  反向便利，但用得少
[else:]

break, continue
pass站位符
14. 推导式，快速从一个集合创造另一个集合
[{( fn(v)|v for v in ? [if v?] )}]

arr = [v for v in list if v not in "adada"]
map = {key:len(key) for key in map if key~=""}
set = {v for v in set if v~=0}
tuple = (v for v in tuple if v..)
15. 迭代器
it = iter(list)
next(it)
for v in it:

def fn():
    index = 0
    while index<99:
        yield index
        index += 1

for v in fn():
    print(v)
    
class A:
    def __iter__(self):
        self.a = 1
        return self

    def __next__(self):
        if self.a ? :
            return self.a
        else:
            raise StopIteration
16. 异常
try:
    print (next(it))
except StopIteration:
    sys.exit()
17. 函数
def fn(v1=1, v2=0):
def fn(*args):   --可变参数，以tuple的形式传进来
fn(a,b) --> (a,b)
fn((a,b)) --> ((a,b))
fn(*(a,b)) --> (a,b)

def fn(**kwargs)  --可变参数，以map的形式进来
fn(name="name", age=18) -->  {name="name", arg=18}
fn({name="name", age=18}) -->  报错
fn(**{name="name", age=18}) -->  {name="name", arg=18}

fn(v2=xxx)

fn = lambda v1,v2 : v1+v2    --只能对输入有限的处理，无法调用外部变量
18. 类
class A(Base1[, Base2]):   __开头是private
    static_value = 0
    __private_static_value = 1
    @staticmethod
    def static_fn(...):

    def __init__(self, ...): 构造
        Base1.__init__(self, ...)
        [Base2.__init__(self, ...)]
        self.value = ...
        print(self.__class__)
    def __del__(self):  析构
    def fn(self, ...):

    def __str__(self):  -->string
    __setitem__ : 按照索引赋值
    __getitem__: 按照索引获取值
    __len__: 获得长度
    __cmp__: 比较运算
    __call__: 函数调用
    __add__: 加运算
    __sub__: 减运算
    __mul__: 乘运算
    __truediv__: 除运算
    __mod__: 求余运算
    __pow__: 乘方
19. global xxx 函数中修改全局变量     nonlocal xxx 闭包
20. 修饰器
def decorator_function(original_function):
    def wrapper(*args, **kwargs):
        # 这里是在调用原始函数前添加的新功能
        before_call_code()
        
        result = original_function(*args, **kwargs)
        
        # 这里是在调用原始函数后添加的新功能
        after_call_code()
        
        return result
    return wrapper

@decorator_function   -->decorator_function: Tresult (*fnPtr)(fn)   可以整个函数来生成这个
def target_function(arg1, arg2):
    pass  # 原始函数的实现

class DecoratorClass:
    def __init__(self, func):
        self.func = func
    
    def __call__(self, *args, **kwargs):
        # 在调用原始函数之前/之后执行的代码
        result = self.func(*args, **kwargs)
        # 在调用原始函数之后执行的代码
        return result

@DecoratorClass
def my_function():
    pass


# 输出 #
print(...)
print(xxx, end="")    --输出不换行
print("str"*2)   --打印多次
print("{0}".format(...))

dir([module])  --> moduleName || attributesNames

# 文件 #
open(fileName, mode)  --mode同C

## 序列化
import pickle
pickle.dump(data1, output:file)
value = pickle.load(file)

# sys库 #
sys 模块提供了与 Python 解释器和系统相关的功能，例如解释器的版本和路径，以及与 stdin、stdout 和 stderr 相关的信息。
sys{
    argv: string[], 命令行参数
    path: string[], python启动路径
}

if [moduleName.]__name__ == "__main__":

# os库 #
os 模块提供了许多与操作系统交互的函数，例如创建、移动和删除文件和目录，以及访问环境变量等。
import os
dir(os)  #returns a list of all module functions>
help(os)

# re库 #
re{   re 模块：re 模块提供了正则表达式处理函数，可以用于文本搜索、替换、分割等。
    findall(r"regex", str)
    re.sub(r"regex", "subStr", str)
}

# json库 #
json 模块提供了 JSON 编码和解码函数，可以将 Python 对象转换为 JSON 格式，并从 JSON 格式中解析出 Python 对象。

# urllib库 #
urllib 模块提供了访问网页和处理 URL 的功能，包括下载文件、发送 POST 请求、处理 cookies 等。
urllib{
    request{
        urlopen("http://")
    }
}

# 其他标准库 #
time 模块：time 模块提供了处理时间的函数，例如获取当前时间、格式化日期和时间、计时等。
datetime 模块：datetime 模块提供了更高级的日期和时间处理函数，例如处理时区、计算时间差、计算日期差等。
random 模块：random 模块提供了生成随机数的函数，例如生成随机整数、浮点数、序列等。
math 模块：math 模块提供了数学函数，例如三角函数、对数函数、指数函数、常数等。
压缩模块：zlib，gzip，bz2，zipfile，以及 tarfile。
性能与测试：timeit，unittest，doctest

# 扩展库 #
pip install xxx
1. Requests.Kenneth Reitz写的最富盛名的http库。每个Python程序员都应该有它。
2. Scrapy. 如果你从事爬虫相关的工作，那么这个库也是必不可少的。用过它之后你就不会再想用别的同类库了。
3. Pillow. 它是PIL（Python图形库）的一个友好分支。对于用户比PIL更加友好，对于任何在图形领域工作的人是必备的库。
4. NumPy.我们怎么能缺少这么重要的库？它为Python提供了很多高级的数学方法。
5. SciPy. 既然我们提了NumPy，那就不得不提一下SciPy。这是一个Python的算法和数学工具库，它的功能把很多科学家从Ruby吸引到了Python。
6. matplotlib. 一个绘制数据图的库。对于数据科学家或分析师非常有用。
7. wxPython.Python的一个GUI（图形用户界面）工具。我主要用它替代tkinter。你一定会爱上它的。
8. SQLAlchemy.一个数据库的库。对它的评价褒贬参半。是否使用的决定权在你手里。
9. BeautifulSoup.我知道它很慢，但这个xml和html的解析库对于新手非常有用。
10. Twisted.对于网络应用开发者最重要的工具。它有非常优美的api，被很多Python开发大牛使用。
11. Pygame.哪个程序员不喜欢玩游戏和写游戏？这个库会让你在开发2D游戏的时候如虎添翼。
12. Pyglet.3D动画和游戏开发引擎。非常有名的Python版本Minecraft就是用这个引擎做的。
13. pyQT.Python的GUI工具。这是我在给Python脚本开发用户界面时次于wxPython的选择。
14. pyGtk.也是Python GUI库。很有名的Bittorrent客户端就是用它做的。
15. Scapy.用Python写的数据包探测和分析库。
16. pywin32.一个提供和windows交互的方法和类的Python库。
17. nltk.自然语言工具包。我知道大多数人不会用它，但它通用性非常高。如果你需要处理字符串的话，它是非常好的库。但它的功能远远不止如此，自己摸索一下吧。
18. nose.Python的测试框架。被成千上万的Python程序员使用。如果你做测试导向的开发，那么它是必不可少的。
19. SymPy.SymPy可以做代数评测. 差异化. 扩展. 复数等等。它封装在一个纯Python发行版本里。
20. IPython.怎么称赞这个工具的功能都不为过。它把Python的提示信息做到了极致。包括完成信息. 历史信息. shell功能，以及其他很多很多方面。一定要研究一下它。
21. TensorFlow. 该库是由Google与Brain Team合作开发的。如果您目前正在使用Python进行机器学习项目，那么您可能已经听说过这个流行的开源库，即TensorFlow。
22. NumPy.Numpy被认为是Python中最受欢迎的机器学习库之一。该界面可用于将图像，声波和其他二进制原始流表达为N维中的实数数组。
23. Scikit-Learn. 它是一个与NumPy和SciPy相关联的Python库。它被认为是处理复杂数据的最佳库之一。
24. Keras. Keras被认为是Python中最酷的机器学习库之一。它提供了一种更容易表达神经网络的机制。Keras还提供了一些用于编译模型，处理数据集，图形可视化等的最佳工具。
25. PyTorch. PyTorch是最大的机器学习库，通过GPU加速执行张量计算，创建动态计算图，并自动计算梯度, 解决与神经网络相关的应用问题. 基于Torch，用C语言实现的开源机器库，带有Lua中的包装器。
26. pywifi. 破解wifi
27. googletrans 谷歌翻译
28. pyqrcode 生产二维码
29. 打包py程序：PyInstaller，py2app，py2exe
30. 处理xlsx: openpyxl，tablib