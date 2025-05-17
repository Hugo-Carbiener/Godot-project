extends State
class_name PlayerRun

@export var move_speed : int
@export var move_direction : int

# if the player was on the floor during the previous frame
var coyote_time_time : float = 0

func can_enter() -> bool:
	return super() and gm.player_physics_body.is_on_floor() and abs(gm.player_physics_body.velocity.x) > 0

func exit() :
	super()
	gm.player_animation_controller.speed_scale = 1
	
func physics_update(_delta: float):
	if gm.player_physics_body.is_on_slope() :
		gm.state_machine.transition_to("slide")
		return

	if !gm.player_physics_body.is_on_floor():
		gm.state_machine.transition_to("fall")
		return
	
	if abs(gm.player_physics_body.velocity.x) == 0 || !gm.player_physics_body.moved_last_frame():
		gm.state_machine.transition_to("idle")
		return

func modify_animation(animationControler : AnimatedSprite2D) : 
	animationControler.speed_scale = abs(gm.player_physics_body.velocity.x) / gm.player_physics_body.max_lateral_speed
	
	## slow animation 
	if (gm.player_physics_body.lateral_movement_input) :
		var delta_speed = gm.player_physics_body.previous_speed - gm.player_physics_body.velocity
		if (gm.player_physics_body.previous_speed.x * gm.player_physics_body.velocity.x > 0 && delta_speed.x * gm.player_physics_body.velocity.x > 0) :
			animationControler.play("slow")
		elif (animationControler.animation.get_basename() != "run") :
			animationControler.play("run")
