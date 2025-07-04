extends State
class_name PlayerFall

## inspector variables values must be tracked at PlayerFall.gd

@export var fall_duration : float
@export var max_fall_velocity : float
@export var max_velocity_roll_coef : float
@export_group("Smoke fx")
@export var smoke_puff_offset : Vector2

@onready var player_jump_state = $"../Jump"
@onready var fall_gravity : float = (-2.0 * player_jump_state.jump_height) / (player_jump_state.jump_ascension_duration * fall_duration) * -1

static func get_state_name() -> String:
	return "fall"

func get_gravity() -> float:
	return fall_gravity

func can_enter() -> bool:
	return super() and !gm.player_physics_body.is_on_floor()

func exit() :
	if gm.player_physics_body.is_on_floor() : 
		landing_smoke()

func physics_update(delta: float):
	gm.player_physics_body.velocity.y += get_gravity() * delta
	if gm.player_physics_body.velocity.y > max_fall_velocity:
		gm.player_physics_body.velocity.y = max_fall_velocity
	
	if gm.player_physics_body.is_on_wall() && gm.input_manager.movement_input_is_pressed(): 
		gm.state_machine.transition_to(PlayerWallGrind.get_state_name().to_lower())
		return

	if gm.player_physics_body.is_on_floor() && gm.player_physics_body.previous_speed.y > max_velocity_roll_coef * max_fall_velocity : 
		gm.state_machine.transition_to(PlayerRoll.get_state_name().to_lower())
		return

	if gm.player_physics_body.is_on_floor() :
		gm.state_machine.transition_to(PlayerIdle.get_state_name().to_lower())
		return

func allow_grab_input() -> bool : return true

func landing_smoke() : 
	var direction = gm.player_physics_body.current_direction
	var smoke_position = gm.player_physics_body.position + (smoke_puff_offset * Vector2(direction, 1))
	gm.vfx_manager.start_vfx_animation(smoke_position, direction, gm.vfx_manager.VFX.BIG_SMOKE)
