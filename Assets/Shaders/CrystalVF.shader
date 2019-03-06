Shader "DC/CrystalVF"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {}
		_BumpMap("Bump Map", 2D) = "bump" {}

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Distortion("Distortion", Range(0,1)) = 0.5
		_Emission("Emission", Range(0,3)) = 2

	}
	SubShader
	{
		Tags { "Queue" = "Transparent" 
				"IgnoreProjector" = "True" 
				"RenderType" = "Opaque"
			/*	"LightMode" = "ForwardBase"*/}

		ZWrite On
		Blend  One One

		GrabPass{"_BehindCrystal"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _BehindCrystal;

			sampler2D _MainTex;
			sampler2D _BumpMap;
			half _Glossiness;
			half _Distortion;
			fixed4 _Color;
			half _Emission;

			struct appdata
			{
				float4 normal : NORMAL;
				float4 color : COLOR;
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				fixed4 diff : COLOR0;
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
			};
	
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				o.uv = UnityObjectToWorldNormal(v.normal);
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				half4 texColor = tex2D(_MainTex, i.uv) *100 ;
				half4 bump = tex2D(_BumpMap, i.uv);
				half2 distortion = UnpackNormal(bump).rg;

				i.uvgrab.xy += distortion * _Distortion;

				float4 grabTexColor = tex2Dproj(_BehindCrystal, UNITY_PROJ_COORD(i.uvgrab))  ;

				return grabTexColor * texColor * _Color * _Emission;
			}

			ENDCG
		}

		Pass
		{
			Tags {"LightMode" = "ForwardAdd"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"
		
			struct appdata
			{
				float4 normal : NORMAL;
				float4 color : COLOR;
				float4 vertex : POSITION;
			};

			struct v2f
			{
				fixed4 diff : COLOR0;
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = UnityObjectToWorldNormal(v.normal);
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));


				o.diff = v.color * nl * _LightColor0;
				o.diff.rgb *= 0.05;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				return i.diff;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
