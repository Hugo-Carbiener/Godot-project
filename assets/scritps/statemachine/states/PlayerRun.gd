extends State
class_name PlayerRun

@export var move_speed : int
@export var move_direction : int

# if the player was on the floor during the previous frame
var coyote_time_time : float = 0

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor() and abs(player_physics_body.velocity.x) > 0
	
func exit() :
	animation_controller.speed_scale = 1
	
	
func physics_update(_delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
	
	if abs(player_physics_body.velocity.x) == 0 :
		state_machine.transition_to("idle")

func modify_animation(animationControler : AnimatedSprite2D) : 
	animationControler.speed_scale = abs(player_physics_body.velocity.x) / player_physics_body.max_lateral_speed
	
	if (player_physics_body.lateral_movement_input) :
		var delta_speed = player_physics_body.previous_speed - player_physics_body.velocity
		if (player_physics_body.previous_speed.x * player_physics_body.velocity.x > 0 && delta_speed.x * player_physics_body.velocity.x > 0) :
			animationControler.play("slow")
		elif (animationControler.animation.get_basename() != "run") :
			animationControler.play("run")
