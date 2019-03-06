Shader "DC/MushroomEmissive"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NoiseScale("Noise Scale", Range(0,10)) = 8
		_NoiseIntensity("Noise Intensity", Range(0,10)) = 5
		_Emission ("Emission", Range(0,3)) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		half _Emission;

		fixed4 _Color;
		half _NoiseScale;
		half _NoiseIntensity;

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 tec = tex2D(_MainTex, float2(IN.uv_MainTex.x * _NoiseScale * 10, IN.uv_MainTex.y * _NoiseScale)) * 3;
			fixed4 c = _Color * tec * tec * tec;
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			o.Emission = _Emission * _Color * c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
