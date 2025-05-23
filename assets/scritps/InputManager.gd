extends Node
class_name InputManager

@onready var gm = $"../Game manager"

static var JUMP_ACTION_KEY = "jump"
static var SLIDE_ACTION_KEY = "slide"
static var RELOAD_ACTION_KEY = "reload"
static var SPEED_BOOST_ACTION_KEY = "speed-boost"
static var GRAB_ACTION_KEY = "grab"

var grab_action_is_pressed : bool

func _ready() -> void:
	grab_action_is_pressed = false

func _process(delta: float) -> void:
	if !gm.state_machine.current_state.allow_input(): return
	
	if Input.is_action_pressed("direction-left"):
		gm.state_machine.current_state.update_lateral_speed(-1, delta)
		
	if Input.is_action_pressed("direction-right"):
		gm.state_machine.current_state.update_lateral_speed(1, delta)
	
	if Input.is_action_just_pressed(JUMP_ACTION_KEY):
		gm.state_machine.transition_to(PlayerJump.get_state_name())
		
	if Input.is_action_just_released(JUMP_ACTION_KEY) and gm.state_machine.current_state is PlayerJump:
		(gm.state_machine.current_state as PlayerJump).on_jump_early_release()
		
	if Input.is_action_just_pressed(SLIDE_ACTION_KEY):
		gm.state_machine.transition_to(PlayerSlide.get_state_name())

	if Input.is_action_just_pressed(RELOAD_ACTION_KEY):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed(SPEED_BOOST_ACTION_KEY) :
		if gm.speed_boost_manager.can_be_input() : 
			gm.speed_boost_manager.start_speed_boost()
			
	grab_action_is_pressed = gm.state_machine.current_state.allow_grab_input() && Input.is_action_pressed(GRAB_ACTION_KEY)
