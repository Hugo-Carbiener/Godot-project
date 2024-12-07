extends Node
class_name InputManager

@onready
var stateMachine = $"../Main character/StateMachine"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		stateMachine.transition_to("jump")
		
	if Input.is_action_just_released("jump") and stateMachine.current_state is PlayerJump:
		(stateMachine.current_state as PlayerJump).on_jump_early_release()
		
	if Input.is_action_just_pressed("slide"):
		stateMachine.transition_to("slide")

	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
