extends State
class_name PlayerRun

@export var move_speed : int
@export var move_direction : int

# if the player was on the floor during the previous frame
var was_on_floor : bool
var coyote_time_time : float = 0

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor() and abs(player_physics_body.velocity.x) > 0
	
func physics_update(delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		
	if abs(player_physics_body.velocity.x) == 0 :
		state_machine.transition_to("idle")

func modify_animation(animationControler : AnimatedSprite2D) : 
	animationControler.speed_scale = abs(player_physics_body.velocity.x) / player_physics_body.max_lateral_speed
