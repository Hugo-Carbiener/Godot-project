extends AnimatedSprite2D
class_name PlayerAnimationController

@onready var player_physics_body = $"../../Character body"
@onready var state_machine = $"../../StateMachine"

func _process(delta: float) -> void:
	check_player_orientation()
	state_machine.current_state.modify_animation(self)
	
func check_player_orientation():
	if player_physics_body.velocity.x != 0 : 
		scale.x = player_physics_body.velocity.x / abs(player_physics_body.velocity.x)
	else : 
		scale.x = 1
		
	if state_machine.current_state.sprite_is_reversed() : 
		scale.x *= -1;

## test
func darken_sprite() : 
	modulate = Color(0, 0, 0, 1)

func reset_sprite_color() : 
	modulate = Color(1, 1, 1, 1)
