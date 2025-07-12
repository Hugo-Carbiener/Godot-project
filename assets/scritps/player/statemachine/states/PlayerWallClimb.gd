extends TransitionState
class_name PlayerWallClimb

@export_group("Wall climb physics")
@export var vertical_speed : float

var actual_speed : float
var ledge_position : Vector2

func can_enter() -> bool:
	return super() \
	&& is_input_valid() \
	&& gm.player_physics_body.is_on_wall() \
	&& gm.player_physics_body.can_wall_jump() \
	&& gm.player_physics_body.velocity.y <= 0

static func get_state_name() -> String: 
	return "wall climb"

func enter(): 
	super()
	gm.player_physics_body.consume_wall_jump()
	var selected_speed = gm.player_physics_body.current_speed.y if gm.player_physics_body.current_speed.y < 0 else gm.player_physics_body.current_speed.x
	actual_speed = max(vertical_speed, abs(selected_speed))

func physics_update(_delta: float):
	gm.player_physics_body.velocity.y = -actual_speed
	
	ledge_position = gm.grab_manager.nearest_detected_ledge

	if !gm.input_manager.jump_action_is_held  \
	|| gm.player_physics_body.is_on_ceiling() \
	|| !gm.player_physics_body.is_on_wall()   \
	|| is_ledge_under_hitbox_top(): 
		gm.state_machine.transition_to(PlayerIdle.get_state_name().to_lower())

func get_gravity() -> float :
	return 0

func on_timer_end() : 
	gm.state_machine.transition_to(PlayerIdle.get_state_name().to_lower())

static func is_input_valid() -> bool : 
	return GameManager.instance.input_manager.movement_input_is_pressed() && GameManager.instance.input_manager.jump_action_is_held

func is_ledge_under_hitbox_top() -> bool : 
	return ledge_position != Vector2.ZERO && ledge_position.y > gm.player_physics_body.global_position.y - (gm.player_physics_body.main_collider.shape.size.y / 2)
