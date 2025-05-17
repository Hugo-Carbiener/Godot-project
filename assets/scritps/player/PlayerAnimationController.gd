extends AnimatedSprite2D
class_name PlayerAnimationController

@onready var gm = $"../../../Game manager"

func _process(delta: float) -> void:
	check_player_orientation()
	gm.state_machine.current_state.modify_animation(self)
	
func check_player_orientation():
	if gm.player_physics_body.velocity.x != 0 : 
		scale.x = gm.player_physics_body.velocity.x / abs(gm.player_physics_body.velocity.x)
	else : 
		scale.x = 1
		
	if gm.state_machine.current_state.sprite_is_reversed() : 
		scale.x *= -1;

## test
func darken_sprite() : 
	modulate = Color(0, 0, 0, 1)

func reset_sprite_color() : 
	modulate = Color(1, 1, 1, 1)
