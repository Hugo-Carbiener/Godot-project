shader_type canvas_item;

uniform float fade_in_duration;
uniform float start_time;
uniform vec3 bg_color;

void fragment() {
	float elapsed = TIME - start_time;
	float clear_radius = clamp(1.0 - (elapsed / fade_in_duration), 0, 1);
	float dist = distance(UV,  vec2(0.5));
	float a = step(clear_radius, dist);

	COLOR.rgb = bg_color;
	COLOR.a =  a;
}