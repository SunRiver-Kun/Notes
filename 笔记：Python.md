<!-- TOC -->

- [基础知识](#基础知识)
- [输出](#输出)
- [文件](#文件)
    - [序列化](#序列化)
- [sys库](#sys库)
- [pywifi](#pywifi)

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
fn(v2=xxx)

fn = lambda v1,v2 : v1+v2    --只能对输入有限的处理，无法调用外部变量

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
sys{
    argv: string[], 命令行参数
    path: string[], python启动路径
}

if [moduleName.]__name__ == "__main__":

# pywifi #
pip install pywifi