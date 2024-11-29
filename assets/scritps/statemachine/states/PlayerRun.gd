extends State
class_name PlayerRun

@export var move_speed: = 40
@export var move_direction: = 1

func enter():
	super()
	player_physics_body.velocity.x = move_speed * move_direction	
	
func physics_update(delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
