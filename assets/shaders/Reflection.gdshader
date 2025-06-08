shader_type canvas_item;

uniform vec2 reflection_offset;
uniform sampler2D reflection_object;

void fragment() {
	vec4 reflection_color = textureLod( reflection_object, UV, 0.0 );
	COLOR.rgb = reflection_color.rgb;
	//COLOR.rgb = mix(
	//	COLOR.rgb,
	//	reflection_color.rgb,
	//	0.5);
}