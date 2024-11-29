extends State
class_name PlayerFall

func can_enter() -> bool:
	return super() and !player_physics_body.is_on_floor()  and player_physics_body.velocity.y > 0
	
func physics_update(delta: float):
	player_physics_body.velocity += player_physics_body.get_gravity() * delta
	
	if player_physics_body.is_on_floor():
		state_machine.transition_to("run")
