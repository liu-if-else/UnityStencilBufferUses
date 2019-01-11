Shader "Unlit/SV_DepthFailBeta"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry+1"}  //在渲染所有阴影体内物体后再渲染阴影体
        LOD 100
        
        CGINCLUDE       //三个pass内着色器内容相同
        #include "UnityCG.cginc"
        struct appdata
        {
            float4 vertex : POSITION;
        };

        struct v2f
        {
            UNITY_FOG_COORDS(1)
            float4 vertex : SV_POSITION;
        };

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            UNITY_TRANSFER_FOG(o,o.vertex);
            return o;
        }
        
        fixed4 frag (v2f i) : SV_Target
        {
            // apply fog
            UNITY_APPLY_FOG(i.fogCoord, col);
            return fixed4(0.3,0.3,0.3,1);           //影子颜色
        }
        ENDCG

        Pass
        {
            Cull Front          //阴影体内侧像素Z测试失败，stencil值加1
            Stencil {           
                Ref 0           //0-255
                Comp always     //default:always
                Pass keep       //default:keep
                Fail keep       //default:keep
                ZFail IncrWrap  //default:keep
            }

            ColorMask 0         //关闭color buffer写入
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            ENDCG
        }
        
        Pass
        {
            Cull Back           //阴影体外侧像素Z测试失败，stencil值减1
            Stencil {
                Ref 0           //0-255
                Comp always     //default:always
                Pass keep       //default:keep
                Fail keep       //default:keep
                ZFail DecrWrap  //default:keep
            }
            ColorMask 0         //关闭color buffer写入
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            ENDCG
        }

        Pass
        {
            Cull Back          //经过前两个pass，stencil值为1的值为在此阴影体内被阴影覆盖的像素
            Stencil {
                Ref 1          //0-255
                Comp equal     //default:always
                Pass keep   //default:keep
                Fail keep      //default:keep
                ZFail keep  //default:keep
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            ENDCG
        }
    }
}