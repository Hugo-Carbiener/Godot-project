extends State
class_name PlayerJump

@export var jump_height : float
@export var jump_ascension_duration : float
# the duration the player needs to hold the key for to make a full jump
@export_group("Variable jump")
@export var variable_jump_input_max_duration : float
# when not doing a full jump, the vertical velocity is mulitplied by the input duration ratio. This variable bounds it from below
@export var variable_jump_min_velocity_multiplier : float
@export_group("Coyote time")
@export var coyote_time_duration : float
@export_group("Corner correction")
@export var check_area_width : int

@onready var jump_velocity : float = (2.0 * jump_height) / jump_ascension_duration * -1
@onready var jump_gravity : float = (-2.0 * jump_height) / pow(jump_ascension_duration, 2) * -1

var variable_jump_input_timer : float

static func get_state_name() -> String: 
	return "jump"

func get_gravity() -> float:
	return jump_gravity

func can_enter() -> bool:
	return super() and (gm.player_physics_body.is_on_floor() or is_coyote_time_valid(gm.player_physics_body.coyote_time_start)) 
	
func enter():
	super()
	variable_jump_input_timer = 0
	gm.player_physics_body.velocity.y = jump_velocity
	
func physics_update(delta: float):
	if gm.input_manager.jump_action_is_released :
		on_jump_early_release()
	
	gm.player_physics_body.correct_corners(check_area_width, delta)
	
	# jump gravity
	gm.player_physics_body.velocity.y += get_gravity() * delta

	# increment variable input jump timer
	variable_jump_input_timer += delta
	
	if gm.player_physics_body.velocity.y > 0 and !gm.player_physics_body.is_on_floor():
		gm.state_machine.transition_to("fall")
		return
		
	if 	gm.player_physics_body.velocity.y == 0 and gm.player_physics_body.is_on_floor():
		gm.state_machine.transition_to("run")
		return

# on early release we precipitate the fall. If the key is never released or if the timer was exceeded, the jump keeps its normal behavior
func on_jump_early_release():
	if variable_jump_input_timer < variable_jump_input_max_duration:
		gm.player_physics_body.velocity.y *= max(variable_jump_input_timer / variable_jump_input_max_duration, variable_jump_min_velocity_multiplier)

func is_coyote_time_valid(coyote_time_start_timestamp: float) -> bool:
	return Time.get_unix_time_from_system() - coyote_time_start_timestamp <= coyote_time_duration

func allow_grab_input() -> bool : return true
