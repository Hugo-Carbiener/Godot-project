extends TransitionState
class_name PlayerRoll

func can_enter() -> bool:
	return super()

static func get_state_name() -> String: 
	return "roll"

func on_animation_end() : 
	if gm.player_animation_controller.animation == get_state_name() :
		gm.speed_boost_manager.unlock_speed_boost_input()
		gm.state_machine.transition_to(PlayerIdle.get_state_name().to_lower())

func physics_update(_delta: float):
	if !gm.player_physics_body.is_on_floor():
		gm.state_machine.transition_to(PlayerFall.get_state_name().to_lower())
		return
	pass
