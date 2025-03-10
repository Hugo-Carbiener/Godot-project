extends RichTextLabel
class_name DebugTextManager

@onready
var physics_body = $"../../Main character/Character body"
@onready
var state_machine = $"../../Main character/StateMachine"

func _process(delta: float) -> void:
	text = ""
	text += getPhysicsDebugText()
	text += "\n"
	text += getStateDebugText()
	pass
	
func getPhysicsDebugText():
	var debug_text = "DEBUG - Press R to reload\n"
	debug_text += "PHYSICS\n"
	debug_text += "position: " + str(physics_body.position) + "\n"
	debug_text += "velocity: " + str(physics_body.velocity) + "\n"
	debug_text += "Is on floor: " + str(physics_body.is_on_floor()) + "\n"
	debug_text += "Is against wall: " + str(physics_body.is_on_wall()) + "\n"
	debug_text += "Lateral input: " + str(physics_body.lateral_movement_input) + "\n"

	return debug_text
	
func getStateDebugText():
	var debug_text = "State: " + state_machine.current_state.name.to_lower() + "\n"
	return debug_text
