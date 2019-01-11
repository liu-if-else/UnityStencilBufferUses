Shader "Unlit/Polygons"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

        CGINCLUDE
        #include "UnityCG.cginc"
        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float2 uv : TEXCOORD0;
            UNITY_FOG_COORDS(1)
            float4 vertex : SV_POSITION;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        
        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            UNITY_TRANSFER_FOG(o,o.vertex);
            return o;
        }
        ENDCG

        Pass
        {
            Stencil {
                Ref 0           //0-255
                Comp always     //default:always
                Pass IncrWrap       //default:keep
                Fail keep       //default:keep
                ZFail IncrWrap  //default:keep
            }
            ColorMask 0

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(0,0,0,0);
            }
            ENDCG
        }
        
        Pass
        {
            Stencil {
                Ref 2           //0-255
                Comp Equal     //default:always
                Pass keep       //default:keep
                Fail keep       //default:keep
                ZFail keep  //default:keep
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            
            #include "UnityCG.cginc"

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(0.2,0.2,0.2,1);
            }
            ENDCG
        }

        Pass
        {
            Stencil {
                Ref 3          //0-255
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
            
            #include "UnityCG.cginc"

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(0.6,0.6,0.6,1);
            }
            ENDCG
        }

        Pass
        {
            Stencil {
                Ref 4          //0-255
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
            
            #include "UnityCG.cginc"

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
	}
}
