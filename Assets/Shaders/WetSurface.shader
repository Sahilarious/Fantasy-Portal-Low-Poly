Shader "DC/WetSurface"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {}
		_GlossMap("Gloss Map", 2D) = "white"{}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		sampler2D _MainTex;
		sampler2D _GlossMap;

		struct Input
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Smoothness = _Glossiness * tex2D(_GlossMap, IN.uv_MainTex * 2.5);
			o.Alpha = c.a;
		}
		ENDCG
	}

	FallBack "Diffuse"
}
