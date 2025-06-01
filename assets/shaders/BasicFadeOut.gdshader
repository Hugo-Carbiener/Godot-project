shader_type canvas_item;

uniform float fade_out_duration;
uniform float start_time;

void fragment() {
	float elapsed = TIME - start_time;
	float a = 1.0 - (elapsed / fade_out_duration);
	COLOR.a =  a;
}
