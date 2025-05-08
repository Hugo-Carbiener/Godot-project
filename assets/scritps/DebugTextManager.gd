extends RichTextLabel
class_name DebugTextManager

@onready var gm = $"../../Game manager"

func _process(delta: float) -> void:
	text = ""
	text += getPhysicsDebugText()
	text += "\n"
	text += getStateDebugText()
	pass
	
func getPhysicsDebugText():
	var debug_text = "DEBUG - Press R to reload\n"
	debug_text += "PHYSICS\n"
	debug_text += "position: " + str(gm.player_physics_body.position) + "\n"
	debug_text += "velocity: " + str(gm.player_physics_body.velocity) + "\n"
	debug_text += "Is on floor: " + str(gm.player_physics_body.is_on_floor()) + "\n"
	debug_text += "Is against wall: " + str(gm.player_physics_body.is_on_wall()) + "\n"
	debug_text += "Moved last frame: " + str(gm.player_physics_body.moved_last_frame()) + "\n"
	debug_text += "\nLateral input: " + str(gm.player_physics_body.lateral_movement_input) + "\n"

	return debug_text
	
func getStateDebugText():
	var debug_text = "State: " + gm.state_machine.current_state.name.to_lower() + "\n"
	return debug_text
