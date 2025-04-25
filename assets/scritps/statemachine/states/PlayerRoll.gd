extends TransitionState
class_name PlayerRoll

func can_enter() -> bool:
	return super()

static func get_state_name() -> String: 
	return "roll"

func on_animation_end() : 
	if animation_controller.animation == get_state_name() :
		player_physics_body.speed_boost_manager.unlock_speed_boost_input()
		state_machine.transition_to("idle")

func physics_update(_delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		return
	pass
