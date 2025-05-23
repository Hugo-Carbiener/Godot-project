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
	return super() and !gm.player_physics_body.is_on_floor()
	
func physics_update(delta: float):
	gm.player_physics_body.velocity.y += get_gravity() * delta
	if gm.player_physics_body.velocity.y > max_fall_velocity:
		gm.player_physics_body.velocity.y = max_fall_velocity

	if gm.player_physics_body.is_on_wall() && gm.player_physics_body.lateral_movement_input: 
		gm.state_machine.transition_to("wall grind")
		return

	if gm.player_physics_body.is_on_floor() && gm.player_physics_body.previous_speed.y > max_velocity_roll_coef * max_fall_velocity : 
		gm.state_machine.transition_to("roll")
		return

	if gm.player_physics_body.is_on_floor() :
		gm.state_machine.transition_to("idle")
		return

func allow_grab_input() -> bool : return true
