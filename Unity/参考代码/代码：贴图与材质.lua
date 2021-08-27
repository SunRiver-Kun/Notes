贴图
{
    二维贴图
    { 
        1.支持PSD、TIFF、TGA、PNG、JPG、BMP、IFF、PICT等
        常用“次时代”贴图格式：PSD、TIFF、TGA
        一般手游：PNG、JPG
        建议“模型贴图”尺寸为2的n次幂，如 2,4,8,16,32,64,128,256,512,1024,2048 pixels
        UI可以无视这个规则
        2.Texture、Normal map、Sprite(2D and UI)、Editor GUI and Legacy GUI(旧)、Cursor、Reflection(反射)、Cookie(遮蒙贴图，用于Cookie效果)、Lightmap(光照贴图)
        3.Alpha From Grayscale 根据灰度生成Alpha通道、Wrap Mode 纹理平铺模式(Clamp打断/Repeat)、Filter Mode 拉伸时的差值过滤方式、Aniso Level 各项异性等级
        4.Advanced
        {
            Non Power of 2：不是2个n次幂的要给其设置个缩放方式
            Bypass sRGB Sampling：使用原有颜色，UI设计时建议开启
            Generate Mip Maps：生成Mipmap贴图，游戏场景建议开启，UI关闭
            Border Mip Maps：防止Mipmap贴图边缘颜色溢出
            Mip Map Filtering：过滤Mipmap贴图以优化质量，若贴图在远处模糊可试试这个选项
            备注：Mipmap贴图是内容相同但尺寸不同的图像列表，是一种优化实时渲染的贴图技术。摄像机近时使用高尺寸的，远时使用小尺寸的
        }
    }
    立方体贴图
    {
        定义：由6张二维无缝贴图构成的贴图类型，与天空盒原理相似。主要用来模拟物体对环境的反射效果，是由贴图决定的，而非外部环境
        步骤：
            一、建个CubeMap贴图，找6个天空盒子的图
            二、建立个Material，把 Shader 的 Diffuse 改为 Reflection/Diffuse
            三、把CubeMap贴图给Material的Reflection Cubemap属性
            四、添加到对象
            五、若反射不明显，可把Material的MainColor改为灰色
        }
    视频贴图
    {
        QuickTime可以播放的视频文件(.mov/mpg/mpeg/mp4/avi/asf)可作为动态贴图附在物体上，实现在场景中播放视频的效果。
        步骤：
            一、安装QuickTime播放软件
            二、在场景中添加Plane对象
            三、导入视频文件，且在属性窗口中能预览
            四、建立发光Material{
                Shader: Self-Illumin/Diffuse
                Base(RGB)Gloss(A): 导入的视频文件
            }
            五、给对象加Material
            六、AudioSource组件
            {
                Audio Clip: 导入的视频文件
            }
            七、编写脚本，并添加到对象{
                public MovieTexture movitexture;
                private bool isplaying = false;
                void Start() {
                    renderer.material.mainTexture = movitexture;
                    gameObject.audio.clip = movitexture.audioClip;}
                void Update(){
                    if(Input.GetKeyDown(KeyCode.P)) {
                        if(isplaying){
                            gameObject.audio.Stop(); //播放音频
                            movitexture.Stop(); //播放视频}
                        else{
                            gameObject.audio.Play(); //播放音频
                            movitexture.Play(); //播放视频 }
                        isplaying = !isplaying; 
                    }}}
    }
    渲染贴图
    {
        //类似开发监控录像，导航地图等功能
        //贴图是动态的，内容由场景中的摄像机获取
        步骤：
            一、建立 RenderTexture 
            二、创建 Camera与Plane，且把 RenderTexture 赋值给他们
    }
}
//贴图决定大致内容，材质决定质感
材质
{
    最终呈现颜色 = （ 漫反射 + 凹凸 + 高光+ 自发光 + 反射 ）* 透明度
    材质组成要素：固有颜色、质感、光学性质
    
    标准材质类型有：顶点着色材质(Lertex Lit,只对顶点着色,高效,现在少用)、
    漫反射材质(Diffse)、凹凸漫反射材质(Bumped Diffse)、高光材质(Specular)、凹凸高光材质(Bumped Specular)、
    视差漫反射材质(Parallax Diffse,对深色模拟更真实)、视差高光材质(Parallax Specular)、贴合材质(Decal,又加一层材质) 

    透明材质类型：模拟水之类的，通过带有 Alpha通道的Base(RGB)Trans(A) 进行控制，Shader为
    Transparent/Diffuse

    自发光材质类型：类似灯泡等自发光的，就算没用光照，也会显示自己颜色。通过 Illumin(A) 贴图进行控制，Shader为
    Self-Illumin/Bumped Specular

    反射材质类型：玻璃等，通过 Reflection Cubemap 和 RefStrength 控制，看13条
}
15.Shader
{
    决定了Render的方法，Unity的是用ShaderLab(CG的二次加工)写的Surface。同时也支持 HLSL(Direct3D)、GLSL(OpenGL)、CG(C for graphics)
    原理：
    3D数据 -> 3D API(OpenGL/DirectX) ->                   显卡驱动  CPU
                                                          ↓     ↓  GPU...
“对象空间”转“世界空间”转“视维空间”  顶点变化处理（可编程管线） ←     ↓
                                ↓                               ↓
                                        图元装配与三角形处理
                                                ↓ 
                                      帧缓存 ← 光栅化 → 光照及阴影处理（可编程管线）
                                        ↓                    ↓
                                                显示屏幕           

}
材质例子：
顶点和片元着色器(Vertex and Fragment Shader)基于完整CG/HLSL语言，更底层、灵活
表面着色器(Surface Shader)，Unity基于ShaderLab(CG的二次封装)写的，以下为Surface Shader的一些例子
参考代码：\Editor\Data\CGIncludes.  UnityCG.cginc、Lighting.cginc、UnityShaderVariables.cginc
1.自定义漫反射
Shader "LiuguozhuShader/ShaderDemo2_NormalTextures"
{
    Properties{
        _MainTex("Base (RGB)",2D) = "white"{} //定义原始贴图
        _Bump("Bump",2D) = "bump" {} //定义法线贴图
    }
    SubShader{
        Tags {"RenderType" = "Opaque"} //声明渲染一个不透明物体
        /*其他
        Tags{"RenderType" = "Transparent"} //声明渲染一个透明物体， Blend SrcAlpha OneMinusSrcAlpha  //指定“透明度混合”
        Tags{"ForceNoShadowCasting" = "True"} //声明本材质不产生阴影
        */
        LOG 200
        CGPROGRAM
            #pragma surface surf Lambert // surface表示采用“表面着色”类型 Lambert表示漫反射材质
            sampler2D _MainTex; //声明
            sampler2D _Bump;
            struct Input{
                float2 uv_MainTex;
                float2 uv_Bump;
            }
            /*Input、SurfaceOutput的完整定义
            struct Input{
                float2 uv_MainTex;  //UV贴图
                float3 viewDir;  //view direction 视图方向值
                float3 worldPos;  //世界空间位置
                float3 worldRefl;  //世界空间中的反射向量
                float4 screenPos;  //裁剪空间位置
                float4 anyName:COLOR;  //每个顶点(per-vertex)颜色的插值
            }
            struct SurfaceOutput
            {
                half Alpha;  //像素的透明度
                half Specular;  //像素的镜面高光
                half Gloss;  //像素的发光强度
                half3 Normal;  //像素的法线值
                half3 Albedo;  //像素的颜色              
                half3 Emission;  //像素的发散颜色
            }
            */
            void surf(Input IN,inout SurfaceOutput o){ //固定名字，为Unity简化CG的一个固定函数
                half4 c = tex2D(_MainTex,IN.uv_MainTex);
                // UnpackNormal 为法线解包函数
                o.Normal = UnpackNormal(tex2D(_Bump,In.uv_Bump));
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
        ENDCG
    }
    FallBack "Diffuse" //Shader的跨平台发布的回退机制，即不能显示默认使用什么材质
}
2.自定义“Alpha混合”材质
Shader "LiuguozhuShader/ShaderDemo6_Surface"{
    Properties{
        _MainTex("Base (RGB)",2D) = "white"{}
        _Cutoff("Alpha cutoff",Range(0,1)) = 0.5 //透明度效果
    }
    SubShader{
        CGPROGRAM
            // #pragma surface surf Lambert  普通光照模型技术
            #pragma surface surf Lambert alphatest:_Cutoff //定义Alpha混合处理技术
            sampler2D _MainTex; //声明
            struct Input{
                float2 uv_MainTex;
            }
            void surf(Input IN,inout SurfaceOutput o){
                half4 c = tex2D(_MainTex,In.uv_MainTex);
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
        ENDCG     
    }
    FallBack "Diffuse"
}
3.自定义“可变色调与亮度”材质
Shader "LiuguozhuShader/ShaderDemo10_Surface_LightEffect"
{
    Properties{
        _MainTex("Base (RGB)",2D) = "white"{}
        _AddNewTex("Add(RGB)",2D) = "white"{}
        _AddColor("Add Color",Color) = (0,0,0,0) //rgba
    }
    SubShader{
        Tags{"RenderType"="Opaque"}
        LOD 200

        CGPROGRAM
            #pragma surface surf Lambert
            sampler2D _MainTex;  //声明
            sampler2D _AddNewTex;
            float4 _AddColor; 
            struct Input{
                float2 uv_MainTex;
            }
            void surf(Input IN,inout SurfaceOutput o){
                half4 c = tex2D(_MainTex,IN.uv_MainTex);
                o.Emission = c.rgb + _AddColor.rgb; //固有颜色加法色调变化大
                // o.Emission = c.rgb * _AddColor.rgb; 固有颜色乘法亮度变化大
                o.Alpha = c.a;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
4.自定义“贴图叠加”材质
Shader "LiuguozhuShader/ShaderDemo12_Surface_LightEffect"
{
    Properties{
        _MainTex("Base (RGB)",2D) = "white"{}
        _AddNewTex("Add(RGB)",2D) = "white"{}
    }
    SubShader{
        Tags{"RenderType"="Opaque"}
        LOD 200

        CGPROGRAM
            #pragma surface surf Lambert
            sampler2D _MainTex;  //声明
            sampler2D _AddNewTex;
            struct Input{
                float2 uv_MainTex;
            }
            void surf(Input IN,inout SurfaceOutput o){
                //透明度混合
                half4 c = tex2D(_MainTex,IN.uv_MainTex);
                half4 c2 = tex2D(_AddNewTex,In.uv_MainTex);
                //透明度公式: NewColor = SrcColor*(1-Alpha) + Color*Alpha;
                o.Emission = c.rgb * (1-c2.a) + c2.rgb*c2.a;
                o.Alpha = c.a;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
5.自定义“去色”材质
Shader "LiuguozhuShader/ShaderDemo13_Surface_LightEffect"
{
    Properties{
        _MainTex("Base (RGB)",2D) = "white"{}
    }
    SubShader{
        Tags{"RenderType"="Opaque"}
        LOD 200

        CGPROGRAM
            #pragma surface surf Lambert
            sampler2D _MainTex;  //声明
            struct Input{
                float2 uv_MainTex;
            }
            void surf(Input IN,inout SurfaceOutput o){
                half4 c = tex2D(_MainTex,IN.uv_MainTex);
                // rgb手动调整
                c.r = c.g;
                c.b = c.g;
                o.Emission = c.rgb;
                o.Alpha = c.a;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
6.自定义“透明”材质
Shader "LiuguozhuShader/ShaderDemo17_Surface_LightEffect"
{
    Properties{
        _MainTex("Base (RGB)",2D) = "white"{}
    }
    SubShader{
        //Tags{"RenderType"="Opaque"} 非透明效果
        Tags{"RenderType"="Transparent" "Queue"="Transparent"} //透明效果
        Blend SrcAlpha OneMinusSrcAlpha  //指定“透明度混合”
        LOD 200

        CGPROGRAM
            #pragma surface surf Lambert
            sampler2D _MainTex;  //声明
            struct Input{
                float2 uv_MainTex;
            }
            void surf(Input IN,inout SurfaceOutput o){
                half4 c = tex2D(_MainTex,IN.uv_MainTex);
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
7.自定义“流光”材质
Shader "LiuguozhuShader/ShaderDemo15_Surface_LightEffect"
{
    Properties{
        _MainTex("Base (RGB)",2D) = "white"{}
        _FlowLightTex("Light Texture(A)",2D) = "black"{}
        _UvPos("_UvPos",range(0.5,1.5))= 2 //Range?
        //_UvFlowLightSpeed("FlowLightSpeed",float) = 2  替换,流光UV速度，大量金光闪闪 
    }
    SubShader{
        Tags{"RenderType"="Opaque"} 非透明效果
        LOD 200

        CGPROGRAM
            #pragma surface surf Lambert
            sampler2D _MainTex;  //声明
            sampler2D _FlowLightTex;
            float _UvPos;
            struct Input{
                float2 uv_MainTex;
            }
            void surf(Input IN,inout SurfaceOutput o){
                half4 c = tex2D(_MainTex,IN.uv_MainTex);
                float2 uv = IN.uv_MainTex;
                uv.x /= 2; //横向取一般进行累加
                uv.x += _UvPos;
                // uv.x += Time.y * _UvFlowLightSpeed;  替换，大量金光闪闪 
                float floLight = tex2D(_FlowLightTex,uv).a ; //取流光亮度RGB累加输出
                o.Albedo = c.rgb + float3(floLight,floLight,floLight);
                o.Alpha = c.a;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
调用代码
public class FlowLight:MonoBehaviour
{
    void Start()
    {
        localoffset = startoffset;
        InvokeRepeating("ShowFlowLight",showtime,0.1F);
    }
    void ShowFlowLight()
    {
        if(localoffset < endoffset)
        {
            gameObject.renderer.material.SetFloat(nameinshader,localoffset);
            localoffset += movespeed;
        }
        else
            CancelInvoke("ShowFlowLight");
    }
    public float startoffset = 0.5F;
    public float endoffset = 1.5F;
    public float movespeed = 0.5F;
    public float nameinshader = "_Uvoffset"; //Shader内流光UV偏移量名字
    public float showtime = 2F;
    
    private float localoffset;
}