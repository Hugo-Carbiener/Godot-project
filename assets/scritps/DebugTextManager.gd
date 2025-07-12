extends RichTextLabel
class_name DebugTextManager

@onready var gm = $"../../Game manager"

func _process(_delta: float) -> void:
	text = ""
	text += getPhysicsDebugText()
	text += "\n"
	text += getStateDebugText()
	pass
	
func getPhysicsDebugText():
	var debug_text = "DEBUG - Press R to reload\n"
	debug_text += "PHYSICS\n"
	debug_text += "position: " + str(gm.player_physics_body.position) + "\n"
	debug_text += "direction: " + str(gm.player_physics_body.current_direction) + "\n"
	debug_text += "velocity: " + str(gm.player_physics_body.velocity) + "\n"
	debug_text += "Is on floor/wall/wall only: " + str(gm.player_physics_body.is_on_floor()) + ", " + str(gm.player_physics_body.is_on_wall()) + ", " +  str(gm.player_physics_body.is_on_wall_only()) + "\n"
	
	debug_text += "\nSLOPE\n"
	debug_text += "Floor angle: " + str(gm.player_physics_body.get_floor_angle()) + "\n"
	debug_text += "Is on slope: " + str(gm.player_physics_body.is_on_slope()) + "\n"
	
	debug_text += "\nINPUT\n"
	debug_text += "Lateral input (left, right, bottom): (" + str(gm.input_manager.left_action_is_pressed) + ", " + str(gm.input_manager.right_action_is_pressed) + ", " + str(gm.input_manager.bottom_action_is_pressed) + ")\n"
	debug_text += "Jump (pressed, released, held): " + str(gm.input_manager.jump_action_is_pressed) + ", " + str(gm.input_manager.jump_action_is_released) + ", " + str(gm.input_manager.jump_action_is_held) + "\n"
	debug_text += "Slide: " + str(gm.input_manager.slide_action_is_pressed) + "\n"
	debug_text += "Speed boost: " + str(gm.input_manager.speed_boost_action_is_pressed) + "\n"
	debug_text += "Grab: " + str(gm.input_manager.grab_action_is_pressed) + "\n"
		
	debug_text += "\nLEDGE DETECTION\n"
	debug_text += "Detected ledge: " + str(gm.grab_manager.nearest_detected_ledge) + "\n"


	return debug_text

func getStateDebugText():
	var debug_text = "State: " + gm.state_machine.current_state.name.to_lower() + "\n"
	return debug_text
