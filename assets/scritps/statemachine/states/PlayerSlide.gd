extends State
class_name PlayerSlide

@export var slide_velocity_treshold = 20
@export var slide_min_duration = 1.0
@export var slide_max_duration = 0.5
@export var slide_initial_velocity : float
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

func exit() : 
	gm.player_physics_body.disable_snap()

func update(_delta: float):
	if gm.player_physics_body.is_on_slope() : 
		can_exit = false
		gm.player_physics_body.current_speed.x = get_initial_velocity()
	else :
		can_exit = true

	if !gm.player_physics_body.is_on_floor() :
		gm.state_machine.transition_to("fall")
		return

	if (timer >= slide_max_duration) :
		gm.state_machine.transition_to("idle")
		return
		
	if (timer >= slide_min_duration && gm.player_physics_body.lateral_movement_input) :
		gm.state_machine.transition_to("idle")
		return
		
	timer += _delta

func physics_snap_on_slopes() -> bool: return true

func get_initial_velocity() -> float :
	return (gm.player_physics_body.velocity.x/abs(gm.player_physics_body.velocity.x)) * slide_initial_velocity
