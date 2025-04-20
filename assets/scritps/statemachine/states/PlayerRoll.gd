extends State
class_name PlayerRoll

func can_enter() -> bool:
	return super()

func allow_lateral_movement () -> bool: 
	return false;

static func get_state_name() -> String: 
	return "roll"

func enter():
	super()
	animation_controller.connect("animation_finished", finish_roll)

func exit():
	animation_controller.disconnect("animation_finished", finish_roll)
	# TODO: speed boost
	pass

func finish_roll() : 
	if animation_controller.animation == get_state_name() :
		state_machine.transition_to("idle")

func physics_update(_delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		return
	pass
	
func prevents_drag() -> bool : return true
