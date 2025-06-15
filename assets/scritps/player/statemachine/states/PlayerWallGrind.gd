extends PlayerFall
class_name PlayerWallGrind

## inspector variables values must be tracked from PlayerFall.gd

@export var gravity_coefficient : float

static func get_state_name() -> String:
	return "wall grind"

func enter():
	super()
	gm.player_animation_controller.connect("frame_changed", slide_smoke)

func exit() : 
	super()
	gm.player_animation_controller.disconnect("frame_changed", slide_smoke)

func get_gravity() -> float :
	return fall_gravity * gravity_coefficient
	
func physics_update(delta: float) :
	super(delta)
	
	if gm.input_manager.jump_action_is_pressed :
		gm.state_machine.transition_to(PlayerJump.get_state_name())
	
	if !gm.input_manager.movement_input_is_pressed() :
		gm.state_machine.transition_to(PlayerFall.get_state_name().to_lower())
	
	if !gm.player_physics_body.is_on_wall_only() : 
		gm.state_machine.transition_to(PlayerIdle.get_state_name().to_lower())

func sprite_is_reversed() -> bool:
	return true;

func slide_smoke() :
	var direction = gm.player_physics_body.current_direction
	var smoke_position = gm.player_physics_body.position + (smoke_puff_offset * Vector2(direction, 1))
	gm.vfx_manager.start_vfx_animation(smoke_position, direction, gm.vfx_manager.VFX.SMALL_SMOKE)
