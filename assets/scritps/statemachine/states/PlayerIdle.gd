extends State
class_name PlayerIdle

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor() and player_physics_body.velocity.x == 0
	
func enter():
	super()
	player_physics_body.velocity.x = 0

func physics_update(delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		
	if abs(player_physics_body.velocity.x) > 0 :
		state_machine.transition_to("run")
