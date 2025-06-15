extends Node
class_name InputManager

@onready var gm = $"../../Game manager"

static var JUMP_ACTION_KEY = "jump"
static var SLIDE_ACTION_KEY = "slide"
static var RELOAD_ACTION_KEY = "reload"
static var SPEED_BOOST_ACTION_KEY = "speed-boost"
static var GRAB_ACTION_KEY = "grab"

var left_action_is_pressed : bool
var right_action_is_pressed : bool
var bottom_action_is_pressed : bool
var jump_action_is_pressed : bool
var jump_action_is_released : bool
var slide_action_is_pressed : bool
var speed_boost_action_is_pressed : bool
var grab_action_is_pressed : bool
var reload_action_is_pressed : bool

func _ready() -> void:
	grab_action_is_pressed = false
	left_action_is_pressed = false
	right_action_is_pressed = false
	jump_action_is_pressed = false
	jump_action_is_released = false
	slide_action_is_pressed = false
	speed_boost_action_is_pressed = false
	grab_action_is_pressed = false
	reload_action_is_pressed = false

func _process(delta: float) -> void:
	set_movement_input()
	set_jump_input()
	set_slide_input()
	set_grab_input()
	set_speed_boost_input()
	set_reload_input()

func set_movement_input() :
	left_action_is_pressed = !gm.game_paused \
		&& gm.state_machine.current_state.allow_input() \
		&& Input.is_action_pressed("direction-left")
		
	right_action_is_pressed = !gm.game_paused \
		&& gm.state_machine.current_state.allow_input() \
		&& Input.is_action_pressed("direction-right")
	
	bottom_action_is_pressed = !gm.game_paused \
		&& gm.state_machine.current_state.allow_input() \
		&& Input.is_action_pressed(SLIDE_ACTION_KEY)

func set_jump_input() : 
	jump_action_is_pressed = !gm.game_paused \
		&& gm.state_machine.current_state.allow_input() \
		&& Input.is_action_just_pressed(JUMP_ACTION_KEY)

	jump_action_is_released = !gm.game_paused \
		&& gm.state_machine.current_state.allow_input() \
		&& gm.state_machine.current_state is PlayerJump \
		&& Input.is_action_just_released(JUMP_ACTION_KEY)

func set_slide_input() :
	slide_action_is_pressed = !gm.game_paused \
		&& gm.state_machine.current_state.allow_input() \
		&& Input.is_action_just_pressed(SLIDE_ACTION_KEY)

func set_speed_boost_input() :
	speed_boost_action_is_pressed = !gm.game_paused \
	&& gm.state_machine.current_state.allow_input() \
	&& gm.speed_boost_manager.can_be_input() \
	&& Input.is_action_just_pressed(SPEED_BOOST_ACTION_KEY)

func set_grab_input() : 
	grab_action_is_pressed = !gm.game_paused \
	&& gm.state_machine.current_state.allow_input() \
	&& gm.state_machine.current_state.allow_grab_input() \
	&& Input.is_action_pressed(GRAB_ACTION_KEY)

func set_reload_input() : 
	reload_action_is_pressed = !gm.game_paused \
	&& gm.state_machine.current_state.allow_input() \
	&& Input.is_action_just_pressed(RELOAD_ACTION_KEY)

func movement_input_is_pressed() :
	return left_action_is_pressed || right_action_is_pressed
