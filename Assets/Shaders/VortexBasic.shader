Shader "DC/VortexBasic"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_BaseTex ("Base Texture", 2D) = "white" {}
		_AlphaTex("Alpha Texture", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Emission("Emission", Range(0,1)) = 0.5
		_Smoothness("Smoothness", Range(0, 1)) = .5
		_DegFactor("Degree Factor", float) = 500
		_RadFactor("Radius Factor", float) = 1000
		_NormalFactor("Normal Factor", Range(0,10)) = 5
	}

	SubShader
	{
		Tags{"Queue"="Transparent"}

		Cull Off
		CGPROGRAM
		#pragma surface surf Standard alpha:fade

		sampler2D _BaseTex;
		sampler2D _AlphaTex;
		sampler2D _NormalMap;

		struct Input
		{
			float2 uv_BaseTex;
		};

		fixed4 _Color;
		fixed _Emission;
		fixed _Smoothness;
		float _DegFactor;
		float _RadFactor;
		float _NormalFactor;

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			float x = IN.uv_BaseTex.x - 0.5;
			float y = IN.uv_BaseTex.y - 0.5;

			float radius = sqrt(x * x + y * y );
			float theta = degrees(acos(x/radius));
			//if (theta < 0)
			//	theta += 360;

			float2 newUV;

			newUV.x = (radius + _SinTime.x / _RadFactor) * cos(_Time.x + theta/ _DegFactor);
			newUV.y = (radius + _SinTime.x / _RadFactor) * sin(_Time.x + theta/ _DegFactor);
	
			fixed4 c = tex2D (_BaseTex, newUV);

			o.Albedo = c.rgb * _Color;
			half a = c.r + 0.3;
			o.Alpha = a * tex2D(_AlphaTex, IN.uv_BaseTex).r;
			o.Emission = _Emission;
			o.Smoothness = _Smoothness;
			//o.Normal = saturate(UnpackNormal(tex2D(_NormalMap, newUV))) * _NormalFactor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
