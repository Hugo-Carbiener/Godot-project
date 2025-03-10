extends AnimatedSprite2D
class_name PlayerAnimationController

@onready var player_physics_body = $"../../Character body"
@onready var state_machine = $"../../StateMachine"

func _process(delta: float) -> void:
	check_player_orientation()
	state_machine.current_state.modify_animation(self)
	
func check_player_orientation():
	if (player_physics_body.velocity.x != 0) :
		scale.x = player_physics_body.velocity.x / abs(player_physics_body.velocity.x)
		
		if state_machine.current_state.sprite_is_reversed() : 
			scale.x *= -1;
