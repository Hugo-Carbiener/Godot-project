shader_type canvas_item;

uniform vec3 color;
uniform float alpha;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = color;
	COLOR.a *= alpha;
}