extends State
class_name PlayerRun

@export var move_speed : int
@export var move_direction : int
@export_group("Smoke fx")
@export var smoke_puff_offset : Vector2
var has_spawned_smoke_on_frame = false
var run_smoke_frames = [0, 4]

# if the player was on the floor during the previous frame
var coyote_time_time : float = 0

func can_enter() -> bool:
	return super() and gm.player_physics_body.is_on_floor() and abs(gm.player_physics_body.velocity.x) > 0

func enter():
	super()
	gm.player_animation_controller.connect("frame_changed", on_frame_changed.bind(gm.player_animation_controller))

func exit() :
	super()
	gm.player_animation_controller.speed_scale = 1
	gm.player_animation_controller.disconnect("frame_changed", on_frame_changed.bind(gm.player_animation_controller))

func physics_update(_delta: float):
	if gm.player_physics_body.is_on_slope() :
		gm.state_machine.transition_to("slide")
		return

	if !gm.player_physics_body.is_on_floor():
		gm.state_machine.transition_to("fall")
		return
	
	if abs(gm.player_physics_body.velocity.x) == 0 || !gm.player_physics_body.moved_last_frame():
		gm.state_machine.transition_to("idle")
		return

func modify_animation(animation_controler : AnimatedSprite2D) : 
	animation_controler.speed_scale = abs(gm.player_physics_body.velocity.x) / gm.player_physics_body.max_lateral_speed
	running_smoke(animation_controler)
	
	## slow animation 
	if (gm.player_physics_body.lateral_movement_input) :
		var delta_speed = gm.player_physics_body.previous_speed - gm.player_physics_body.velocity
		if (gm.player_physics_body.previous_speed.x * gm.player_physics_body.velocity.x > 0 && delta_speed.x * gm.player_physics_body.velocity.x > 0) :
			animation_controler.play("slow")
		elif (animation_controler.animation.get_basename() != "run") :
			animation_controler.play("run")

func sprite_is_reversed() -> bool:
	return gm.player_animation_controller.animation == "slow"

func running_smoke(animation_controler : AnimatedSprite2D) : 
	if run_smoke_frames.has(animation_controler.frame) && !has_spawned_smoke_on_frame :
		has_spawned_smoke_on_frame = true
		var direction = gm.player_physics_body.current_direction
		var smoke_position = gm.player_physics_body.position + (smoke_puff_offset * Vector2(direction, 1))
		gm.vfx_manager.start_vfx_animation(smoke_position, direction, gm.vfx_manager.VFX.STEP_SMOKE)

func on_frame_changed(animation_controler : AnimatedSprite2D) : 
	has_spawned_smoke_on_frame = false
