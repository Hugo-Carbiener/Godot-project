shader_type canvas_item;

uniform float shake_power = 0.03;
uniform float shake_rate : hint_range( 0.0, 1.0 ) = 0.2;
uniform float shake_speed = 5.0;
uniform float shake_block_size = 30.5;
uniform float shake_color_rate : hint_range( 0.0, 1.0 ) = 0.01;
uniform sampler2D screen_texture : hint_screen_texture;

float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment( )
{
	float enable_shift = float(
		random( trunc( TIME * shake_speed ) )
	<	shake_rate
	);

	vec2 fixed_uv = SCREEN_UV;
	fixed_uv.x += (
		random(
			( trunc( SCREEN_UV.y * shake_block_size ) / shake_block_size )
		+	TIME
		) - 0.5
	) * shake_power * enable_shift;

	vec4 pixel_color = textureLod( screen_texture, fixed_uv, 0.0 );
	pixel_color.r = mix(
		pixel_color.r,
		textureLod( screen_texture, fixed_uv + vec2( shake_color_rate, 0.0 ), 0.0 ).r,
		enable_shift
	);
	float right_blue = mix(
		pixel_color.b,
		textureLod( screen_texture, fixed_uv + vec2( -shake_color_rate, 0.0 ), 0.0 ).b,
		enable_shift
	);
	float left_blue = mix(
		pixel_color.b,
		textureLod( screen_texture, fixed_uv + vec2( shake_color_rate, 0.0 ), 0.0 ).b,	
		enable_shift
	);
	pixel_color.b = mix(
		pixel_color.b,
		clamp(left_blue + right_blue, 0, 1),
		enable_shift
		); //allow for cyan and magenta instead of red and blue
	pixel_color.g = mix(
		pixel_color.g,	
		textureLod( screen_texture, fixed_uv + vec2( -shake_color_rate, 0.0 ), 0.0 ).g,	
		enable_shift
	);
	COLOR = pixel_color;
}
