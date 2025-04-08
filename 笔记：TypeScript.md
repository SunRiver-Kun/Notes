<!-- TOC -->

- [简介](#简介)
    - [VS插件](#vs插件)
- [类型](#类型)
    - [类型别名](#类型别名)
    - [类型判断](#类型判断)
    - [类型转换](#类型转换)
    - [类型提取](#类型提取)
- [字符串](#字符串)
- [接口](#接口)
- [类](#类)
- [元组](#元组)
- [容器](#容器)
- [函数](#函数)
- [泛型](#泛型)
- [枚举和常量](#枚举和常量)
- [模块](#模块)
- [命名空间](#命名空间)
- [异步](#异步)

<!-- /TOC -->
# 简介 #
TypeScript是JavaScript的超集，支持ECMAScript6标准。
添加了类型推断、擦除、接口、枚举、泛型、命名空间、元组、Await、Mixin。

npm install -g typescript

## VS插件 ##
TypeScript Importer：自动导入
ESLint：格式化


# 类型 #
string、number、boolean、undefined(未初始化)、object(null)
void（函数无返回值，一般不写）、never（常用于函数只会throw，不会return）
any（任意类型，跳过检测）、unknown（未知类型，在赋值给其他类型时需要转换） 

[let, const, readonly, static, public, protected, private] value:string = "str";

注：new String、Number是object，要用原生的string和number

## 类型别名 ##
type StringOrNumber = string | number;
let value:StringOrNumber = 0;   value="str";

type MyType<T> = T extends xxx ? string : number;
type MyFunc = (v:number) => number;
type Methods = { [K in keyof MyObject]: MyObject[K] extends Function ? K : never }[keyof MyObject];

T? 的类型是 T | undefined,  function fn(a:number, b?:string)

keyof Type ==> "key1" | "key2" | ...

## 类型判断 ##
typeof x === "string"   -->  无法区分Array和Object
if( value instanceof ClassName )
Object.prototype.tostring.call(v) --> "[object Array]"，可以区分Array和Object

obj?.xxx  --> obj存在时才继续运行 
value ?? defaultValue   --> value是null or undefined时，返回defaultGValue

if(v) 中 false, undefined, null, 0, "" 为false

null, undefined == null, undefined  --> true ， 在==其他时都是false
null, undefined > 0 或 < 0   -->  false,  null和undefined会转换为0再比较
* null, undefined <= 0 或 >= 0 -->  true， !(null, undefined <> 0)

## 类型转换 ##
value as T
<T> value
!!value  === Boolean(value)

## 类型提取 ##
Parameters<Fn> --> Fn的参数类型tuple
keyof MyObject  --> MyObject的key数组
valuesof object --> object的值数组

# 字符串 #
使用string，而不是String(object)
`${表达式}${表达式二}`  -->  (表达式)+(表达式二)

# 接口 #
注：接口无法转成JavaScript
默认public
export interface Name extends Other1, Other2{
    name: string;
    age: number;
    family?: { father?:string, mother?:string };
    
    fn( arg:any )[: void];
    --fn2: (arg: any) => void ;

    --限制 list:Name的list[index]的类型为T。
    [index:number]:T;  --> let list:Name = ["", ""];  限制继承接口的是字符串数组
    [index:string]:T;  --> let map:Name;   map[name] = T;
}

# 类 #
通过 ClassName.prototype 来给obj添加函数，ClassName.value 来设置static
默认public
export class ClassName [extends SuperClass] [implements Interface] {
    value:T = _;
    constructor(arg: any) {}

    //属性
    private _length:number;
    public get length(): number { return this._length; }
    public set lenght(len) { this._length = len; }

    fn(){ super.fn(); this.length = 0;   }

    public abstract fn2():void
}

export class ClassName{
    constructor(public value:T) {}   -->  相当于自动声明和赋值给value了
}

# 元组 #
let point: [number, number] = [10, 1];
point[0] === 10;

tuple{
    push(value)
    pop()
    concat(otherTuple): Array
    slice(index): Array   -->   let newTuple = [ ...tuple ];

}

let newTuple[number, ...typeof tuple] = [0, ...tuple];

let [x, y] = [10, 0];  
let [, y] = [10, 0, 1];   --> y=0

let tuple = [0, ""] as const;   --> tuple只读

for(let v of tuple){ ... }
tuple.forEach( v => console.log(v) )

# 容器 #
注：
for of: 有序，不会遍历prop里的，推荐使用，使用可迭代对象，遍历值        for v of arr        arr.forEach( (v)=>{} )
for in: 无序，会遍历prop里的，配合 hasOwnProperty 用，适用对象，遍历*键名*.   for index in arr

-- get(), set(), size, for of
new Map<K, V>()
new ReadOnlyMap<K, V>([ [k1, v1], [k2, v2] ])
new Set<T>()
new ReadOnlySet<T>( [v1, v2] )

new Array<T>( v1, v2, ... ) || T[]   -->  push(), pop(), length, for in|for of

# 函数 #
function fn(name:string, age:number): void { ... }

(arg:string) : number => return 0;
function(arg:string) : number { return 0; }

(function() {})();   --直接运行

# 泛型 #
function fn<T = any>(value:T):T { return value; }
fn<number>(1)

function fn<T extends XXX>(){}

export const getProperty = <T, K extends keyof T>(obj: T, key: K) => { return obj[key]; };


# 枚举和常量 #
const value = 值类型  --> 常量
const obj = 对象    --> 对象不能赋值（obj=xxx），但可以改变其属性（obj.value=xxx）等
const enum DIrection { Up, Down, ... }    -->  比单独的enum性能好

# 模块 #
export function fn() { ... }
export{ fn, str, ... }
export default { name: value } //let default={name: value}  export{ default }

import { export1 [, export2 as alias2[, ...]] } from "module.js";  //导出特定的函数，变量(一般深拷贝)等      
import std_default from "module.js";  //导出default到std命名空间
import * as std from 'std.js';  //导出全部内容到std命名空间
import "init.js" //导入的时候会运行代码
import('module.js').then((std) => { ... });  //动态导入

# 命名空间 #
//cc.d.ts
export namespace _decorator { 
    export const ccclass: ((name?: string) => ClassDecorator) & ClassDecorator;
    
    export function property(options?: __private._cocos_core_data_decorators_property__IPropertyOptions): __private._cocos_core_data_decorators_utils__LegacyPropertyDecorator;
    export function property(type: __private._cocos_core_data_decorators_property__PropertyType): __private._cocos_core_data_decorators_utils__LegacyPropertyDecorator;
    export function property(...args: Parameters<__private._cocos_core_data_decorators_utils__LegacyPropertyDecorator>): void;

    export namespace math {
        export class Vec3 extends ValueType {
            static ZERO: Readonly<Vec3>;
            static squaredDistance(a: IVec3Like, b: IVec3Like): number;
            x: number;
            constructor(v: Vec3);
            constructor(x?: number, y?: number, z?: number);
            set(other: Vec3): Vec3;
            normalize(): this;
        }
    }
}

//test.js
import { _decorator, Component, math, Node } from 'cc';
const { ccclass, property } = _decorator;

# 异步 #
async function getData(url:string): Promise<string> {
    try{
        const response = await fetch(url);
        return response.data;
    } catch(error){
        console.error(`Failt to load ${url}`);
    }
}

Promise.all、Promise.race、