extends State
class_name PlayerFall

@export var fall_duration : float
@export var max_fall_velocity : float

@onready var player_jump_state = $"../Jump"
@onready var fall_gravity : float = (-2.0 * player_jump_state.jump_height) / (player_jump_state.jump_ascension_duration * fall_duration) * -1

func get_gravity() -> float:
	return fall_gravity

func can_enter() -> bool:
	return super() and !player_physics_body.is_on_floor()
	
func physics_update(delta: float):
	player_physics_body.velocity.y += get_gravity() * delta
	if player_physics_body.velocity.y > max_fall_velocity:
		player_physics_body.velocity.y = max_fall_velocity

	if player_physics_body.is_on_floor() :
		state_machine.transition_to("idle")
