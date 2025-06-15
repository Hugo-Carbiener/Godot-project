extends State
class_name PlayerIdle

static func get_state_name() -> String:
	return "idle"

func can_enter() -> bool:
	return super()

func enter():
	super()

func physics_update(_delta: float):
	if !gm.player_physics_body.is_on_floor():
		gm.state_machine.transition_to(PlayerFall.get_state_name().to_lower())
		return

	if abs(gm.player_physics_body.velocity.x) > 0 && gm.player_physics_body.moved_last_frame():
		gm.state_machine.transition_to(PlayerRun.get_state_name().to_lower())
		return
