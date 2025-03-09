extends State
class_name PlayerSlide

@export var slide_velocity_treshold = 20
@export var slide_min_duration = 1.0
@export var slide_max_duration = 0.5
@export var slide_initial_velocity : float
@export var collider_size : Vector2;
@export var collider_position : Vector2;
var default_collider_size : Vector2;
var default_collider_position : Vector2;
var timer: float

func allow_lateral_movement () -> bool: 
	return false;

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor() and abs(player_physics_body.velocity.x) > 0

func enter():
	super()
	var collider = player_physics_body.get_node("Collider")
	default_collider_size = collider.shape.size
	default_collider_position = collider.position
	collider.shape.size = collider_size
	collider.position = collider_position
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
	
func exit():
	var collider = player_physics_body.get_node("Collider")
	collider.shape.size = default_collider_size
	collider.position = default_collider_position
