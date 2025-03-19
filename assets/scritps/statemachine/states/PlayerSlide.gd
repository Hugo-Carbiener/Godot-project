extends State
class_name PlayerSlide

@export var slide_velocity_treshold = 20
@export var slide_min_duration = 1.0
@export var slide_max_duration = 0.5
@export var slide_initial_velocity : float
var timer: float

static func get_state_name() -> String: 
	return "jump"

func allow_lateral_movement () -> bool: 
	return false;

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor() and abs(player_physics_body.velocity.x) > 0

func enter():
	super()
	timer = 0
	player_physics_body.velocity.x = (player_physics_body.velocity.x/abs(player_physics_body.velocity.x)) * slide_initial_velocity
	
func update(_delta: float):
	if !player_physics_body.is_on_floor() :
		state_machine.transition_to("fall")

	if (timer >= slide_max_duration) :
		state_machine.transition_to("idle")
		
	if (timer >= slide_min_duration && player_physics_body.lateral_movement_input) :
		state_machine.transition_to("idle")
	timer += _delta
