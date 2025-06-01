extends AnimatedSprite2D
class_name PlayerAnimationController

@onready var gm = $"../../../Game manager"

func _process(_delta: float) -> void:
	check_player_orientation()
	gm.state_machine.current_state.modify_animation(self)
	
func check_player_orientation():
	scale.x = gm.player_physics_body.current_direction

	if gm.state_machine.current_state.sprite_is_reversed() : 
		scale.x *= -1;

## test
func darken_sprite() : 
	modulate = Color(0, 0, 0, 1)

func reset_sprite_color() : 
	modulate = Color(1, 1, 1, 1)

func get_current_player_texture() -> Texture :
	return sprite_frames.get_frame_texture(animation, frame)
