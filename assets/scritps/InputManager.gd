extends Node
class_name InputManager

@onready
var stateMachine = $"../Main character/StateMachine"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		stateMachine.transition_to("jump")
		print("jump input")
		pass
		
	if Input.is_action_just_pressed("slide"):
		stateMachine.transition_to("slide")
		print("slide input")
		pass
