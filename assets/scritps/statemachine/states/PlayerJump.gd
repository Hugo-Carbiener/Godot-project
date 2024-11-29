extends State
class_name PlayerJump

@export var jump_initial_velocity = -600.0

func can_enter() -> bool:
	var isFloor = player_physics_body.is_on_floor()
	return super() and  isFloor
	
func enter():
	super()
	player_physics_body.velocity.y = jump_initial_velocity	
	
func physics_update(delta: float):
	if player_physics_body.velocity.y > 0 and !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		
	if 	player_physics_body.velocity.y == 0 and player_physics_body.is_on_floor():
		state_machine.transition_to("run")
