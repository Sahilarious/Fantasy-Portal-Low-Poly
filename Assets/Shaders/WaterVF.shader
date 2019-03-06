Shader "DC/WaterVF"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {}
		_BumpMap("Bump Map", 2D) = "bump" {}

		_Glossiness("Smoothness", Range(0,10)) = 0.5
		_Magnitude("Magnitude", Range(0,1)) = 0.5
		_WaterSpeed("Water Speed", Range(0,1)) = 0.5
	}
		SubShader
		{

			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
			Blend One One
			//Blend SrcAlpha OneMinusSrcAlpha

			
			GrabPass{"_BelowWater"}
			Pass{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"


			sampler2D _BelowWater;

			fixed4 _Color;
			sampler2D _MainTex;
			sampler2D _BumpMap;
			half _Glossiness;
			half _Magnitude;
			half _WaterSpeed;

			struct appdata
			{
				float4 color : COLOR;
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD1;

			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				v.uv.y += _Time * _WaterSpeed;
				o.uv = v.uv ;

				return o;
			}


			float4 frag(v2f i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv) * 0.4 + 0.5;

				color.a = color.r *.7;
				half4 bump = tex2D(_BumpMap, i.uv);
				half2 distortion = UnpackNormal(bump).rg;

				i.uvgrab.xy += distortion * _Magnitude;

				float4 col = tex2Dproj(_BelowWater, UNITY_PROJ_COORD(i.uvgrab)) ;

				float4 allCol = col  * _Color * color;

				return allCol;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
