
# 反编译 #
dotPeek 解析 G:\Steam\steamapps\common\OxygenNotIncluded\OxygenNotIncluded_Data\Managed\Assembly-CSharp.dll

# 鸿蒙 #
    static void Postfix(ref string __result)
    {
        if (__result == "foo")
            __result = "bar";
    }

    返回true继续执行