extends RichTextLabel

@onready
var physicsBody = $"../Main character/Character body"
@onready
var stateManager = $"../Main character/State manager"

func _process(delta: float) -> void:
	text = ""
	text += getPhysicsDebugText()
	text += "\n"
	text += getStateDebugText()
	pass
	
func getPhysicsDebugText():
	var text = "physics\n"
	text += "velocity: " + str(physicsBody.velocity) + "\n"
	text += "Is on floor: " + str(physicsBody.is_on_floor()) + "\n"
	return text
	
func getStateDebugText():
	var text = "State: " + stateManager.State.keys()[stateManager.state] + "\n"
	return text
