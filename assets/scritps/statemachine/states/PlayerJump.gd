extends State
class_name PlayerJump

@export var jump_height : float
@export var jump_ascension_duration : float

@onready var jump_velocity : float = (2.0 * jump_height) / jump_ascension_duration * -1
@onready var jump_gravity : float = (-2.0 * jump_height) / pow(jump_ascension_duration, 2) * -1

func get_gravity() -> float:
	return jump_gravity

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor()
	
func enter():
	super()
	player_physics_body.velocity.y = jump_velocity	
	
func physics_update(delta: float):
	player_physics_body.velocity.y  += get_gravity() * delta
	if player_physics_body.velocity.y > 0 and !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		
	if 	player_physics_body.velocity.y == 0 and player_physics_body.is_on_floor():
		state_machine.transition_to("run")
