extends AnimatedSprite2D
class_name PlayerAnimationController

@onready
var player_physics_body = $"../../Character body"

func _process(delta: float) -> void:
	check_player_orientation()
	
func check_player_orientation():
	if (player_physics_body.velocity.x != 0) :
		scale.x = player_physics_body.velocity.x / abs(player_physics_body.velocity.x)
