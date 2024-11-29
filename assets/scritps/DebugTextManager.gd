extends RichTextLabel
class_name DebugTextManager

@onready
var physics_body = $"../Main character/Character body"
@onready
var state_machine = $"../Main character/StateMachine"

func _process(delta: float) -> void:
	text = ""
	text += getPhysicsDebugText()
	text += "\n"
	text += getStateDebugText()
	pass
	
func getPhysicsDebugText():
	var text = "PHYSICS\n"
	text += "position: " + str(physics_body.position) + "\n"
	text += "velocity: " + str(physics_body.velocity) + "\n"
	text += "Is on floor: " + str(physics_body.is_on_floor()) + "\n"
	return text
	
func getStateDebugText():
	var text = "State: " + state_machine.current_state.name.to_lower() + "\n"
	return text
