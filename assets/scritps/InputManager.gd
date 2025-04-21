extends Node
class_name InputManager

@onready
var state_machine = $"../Main character/StateMachine"
static var JUMP_ACTION_KEY = "jump"
static var SLIDE_ACTION_KEY = "slide"
static var RELOAD_ACTION_KEY = "reload"

var bufferedInputs = [JUMP_ACTION_KEY]
@export
var bufferLifeSpan : float


func _process(delta: float) -> void:
	if !state_machine.current_state.allow_input(): return
	
	if Input.is_action_pressed("direction-left"):
		state_machine.current_state.update_lateral_speed(-1, delta)
		
	if Input.is_action_pressed("direction-right"):
		state_machine.current_state.update_lateral_speed(1, delta)
	
	if Input.is_action_just_pressed(JUMP_ACTION_KEY):
		state_machine.transition_to(PlayerJump.get_state_name())
		
	if Input.is_action_just_released(JUMP_ACTION_KEY) and state_machine.current_state is PlayerJump:
		(state_machine.current_state as PlayerJump).on_jump_early_release()
		
	if Input.is_action_just_pressed(SLIDE_ACTION_KEY):
		state_machine.transition_to(PlayerSlide.get_state_name())

	if Input.is_action_just_pressed(RELOAD_ACTION_KEY):
		get_tree().reload_current_scene()
