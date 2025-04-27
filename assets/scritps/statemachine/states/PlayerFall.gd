extends State
class_name PlayerFall

## inspector variables values must be tracked at PlayerFall.gd

@export var fall_duration : float
@export var max_fall_velocity : float
@export var max_velocity_roll_coef : float

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

	if player_physics_body.is_on_wall() && player_physics_body.lateral_movement_input: 
		state_machine.transition_to("wall grind")
		return

	if player_physics_body.is_on_floor() && player_physics_body.previous_speed.y > max_velocity_roll_coef * max_fall_velocity : 
		state_machine.transition_to("roll")
		return

	if player_physics_body.is_on_floor() :
		state_machine.transition_to("idle")
		return
