extends State
class_name PlayerSlide

@export var slide_velocity_treshold = 20
@export var slide_duration = 1.0
@export var collider_size : Vector2;
@export var collider_position : Vector2;
var default_collider_size : Vector2;
var default_collider_position : Vector2;
var timer: float

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor() and abs(player_physics_body.velocity.x) > 0

func enter():
	super()
	var collider = player_physics_body.get_node("Collider")
	default_collider_size = collider.shape.size
	default_collider_position = collider.position
	collider.shape.size = collider_size
	collider.position = collider_position
	timer = slide_duration
	
func update(_delta: float):
	if (timer <= 0):
		state_machine.transition_to("run")
	timer -= _delta
	
func exit():
	var collider = player_physics_body.get_node("Collider")
	collider.shape.size = default_collider_size
	collider.position = default_collider_position
