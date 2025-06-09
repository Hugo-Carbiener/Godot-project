extends PlayerFall
class_name PlayerWallGrind

## inspector variables values must be tracked from PlayerFall.gd

@export var gravity_coefficient : float

func enter():
	super()
	gm.player_animation_controller.connect("frame_changed", slide_smoke)

func exit() : 
	gm.player_animation_controller.disconnect("frame_changed", slide_smoke)

func get_gravity() -> float :
	return fall_gravity * gravity_coefficient
	
func physics_update(delta: float) :
	super(delta)
	
	if !gm.player_physics_body.lateral_movement_input :
		gm.state_machine.transition_to("fall")
	
	if !gm.player_physics_body.is_on_wall_only() : 
		gm.state_machine.transition_to("idle")

func sprite_is_reversed() -> bool:
	return true;

func slide_smoke() :
	var direction = gm.player_physics_body.current_direction
	var smoke_position = gm.player_physics_body.position + (smoke_puff_offset * Vector2(direction, 1))
	gm.vfx_manager.start_vfx_animation(smoke_position, direction, gm.vfx_manager.VFX.SMALL_SMOKE)
