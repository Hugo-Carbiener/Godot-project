extends State
class_name PlayerIdle

func can_enter() -> bool:
	return super()
	
func enter():
	super()

func physics_update(delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		
	if abs(player_physics_body.velocity.x) > 0 && player_physics_body.moved_last_frame():
		state_machine.transition_to("run")
