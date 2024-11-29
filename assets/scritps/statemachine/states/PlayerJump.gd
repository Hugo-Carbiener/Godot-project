extends State
class_name PlayerJump

@export var jump_height : float
@export var jump_ascension_duration : float
# the duration the player needs to hold the key for to make a full jump
@export var variable_jump_input_max_duration : float
# when not doing a full jump, the vertical velocity is mulitplied by the input duration ratio. This variable bounds it from below
@export var variable_jump_min_velocity_multiplier : float

@onready var jump_velocity : float = (2.0 * jump_height) / jump_ascension_duration * -1
@onready var jump_gravity : float = (-2.0 * jump_height) / pow(jump_ascension_duration, 2) * -1

var variable_jump_input_timer : float

func get_gravity() -> float:
	return jump_gravity

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor()
	
func enter():
	super()
	variable_jump_input_timer = 0
	player_physics_body.velocity.y = jump_velocity
	
func physics_update(delta: float):
	# jump gravity
	player_physics_body.velocity.y  += get_gravity() * delta

	# increment variable input jump timer
	variable_jump_input_timer += delta
	
	# on early release we precipitate the fall. If the key is never released or if the timer was exceeded, the jump keeps its normal behavior
	if Input.is_action_just_released("jump") and variable_jump_input_timer < variable_jump_input_max_duration:
		player_physics_body.velocity.y *= max(variable_jump_input_timer / variable_jump_input_max_duration, variable_jump_min_velocity_multiplier)
	
	if player_physics_body.velocity.y > 0 and !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		
	if 	player_physics_body.velocity.y == 0 and player_physics_body.is_on_floor():
		state_machine.transition_to("run")
