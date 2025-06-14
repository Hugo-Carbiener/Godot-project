extends State
class_name PlayerSlide

@export var slide_velocity_treshold = 20
@export var slide_min_duration = 1.0
@export var slide_max_duration = 0.5
@export var slide_initial_velocity : float
@export_group("Smoke fx")
@export var smoke_puff_offset : Vector2
var timer: float

static func get_state_name() -> String: 
	return "slide"

func allow_lateral_movement () -> bool: 
	return false;

func can_enter() -> bool:
	return super() and gm.player_physics_body.is_on_floor() and abs(gm.player_physics_body.velocity.x) > 0

func enter():
	super()
	timer = 0
	gm.player_physics_body.current_speed.x = get_initial_velocity()
	gm.player_physics_body.enable_snap()
	gm.player_animation_controller.connect("frame_changed", slide_smoke)

func exit() : 
	gm.player_physics_body.disable_snap()
	gm.player_animation_controller.disconnect("frame_changed", slide_smoke)

func update(delta: float):
	super(delta)
	
	if gm.player_physics_body.is_on_slope() : 
		can_exit = false
		gm.player_physics_body.current_speed.x = get_initial_velocity()
	else :
		can_exit = true

	if !gm.player_physics_body.is_on_floor() :
		gm.state_machine.transition_to("fall")
		return

	if abs(gm.player_physics_body.velocity.x) < slide_velocity_treshold :
		gm.state_machine.transition_to("idle")

	if gm.player_physics_body.is_on_wall() :
		gm.state_machine.transition_to("idle")

	if timer >= slide_max_duration :
		gm.state_machine.transition_to("idle")
		return
		
	if timer >= slide_min_duration && gm.input_manager.movement_input_is_pressed() :
		gm.state_machine.transition_to("idle")
		return
		
	timer += delta

func physics_snap_on_slopes() -> bool: return true

func get_initial_velocity() -> float :
	return (gm.player_physics_body.velocity.x/abs(gm.player_physics_body.velocity.x)) * slide_initial_velocity

func slide_smoke() :
	var direction = gm.player_physics_body.current_direction
	var smoke_position = gm.player_physics_body.position + (smoke_puff_offset * Vector2(direction, 1))
	gm.vfx_manager.start_vfx_animation(smoke_position, direction, gm.vfx_manager.VFX.SMALL_SMOKE)
