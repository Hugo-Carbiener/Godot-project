extends State
class_name PlayerWallHang

@export_group("Smooth landing")
@export var smooth_landing_duration : float
var smooth_landing_timer : Timer = Timer.new()

const GRAB_ANIMATION_KEY = "ledge_grab"
const GRAB_TOP_ANIMATION_KEY = "ledge_grab_top"
const GRAB_BOTTOM_ANIMATION_KEY = "ledge_grab_bottom"

static func get_state_name() -> String:
	return "wall hang"

func get_gravity() -> float :
	return 0

func _ready() -> void:
	smooth_landing_timer.one_shot = true
	add_child(smooth_landing_timer)

func enter(): 
	super()
	gm.player_physics_body.reset_wall_jumps()
	can_exit = false
	smooth_landing_timer.start(smooth_landing_duration)

func update(_delta: float):
	super(_delta)
	smooth_landing(smooth_landing_timer)
	if is_looking_down() && gm.input_manager.jump_action_is_pressed :
		ledge_drop()
		return
		
	if is_looking_up() && gm.input_manager.jump_action_is_pressed:
		ledge_jump()
		return

func modify_animation(animation_controler : AnimatedSprite2D) : 
	if is_looking_down() :
		animation_controler.play(GRAB_BOTTOM_ANIMATION_KEY)
		return
	
	if is_looking_up() :
		animation_controler.play(GRAB_TOP_ANIMATION_KEY)
		return
	
	animation_controler.play(GRAB_ANIMATION_KEY)

func smooth_landing(timer : Timer) :
	if timer.time_left > 0:
		var wall_normal = gm.player_physics_body.get_wall_normal().x
		var player_collider_size = gm.player_physics_body.main_collider.shape.size
		var target_position = gm.grab_manager.nearest_detected_ledge + Vector2(player_collider_size.x / 2 * wall_normal, player_collider_size.y / 2) - gm.player_physics_body.main_collider.position
		gm.player_physics_body.global_position = gm.player_physics_body.position.lerp(target_position, (smooth_landing_duration - smooth_landing_timer.time_left) / smooth_landing_duration)

func is_looking_up() -> bool :
	return (gm.input_manager.left_action_is_pressed && gm.player_physics_body.get_wall_normal().x < 0) \
	|| (gm.input_manager.right_action_is_pressed && gm.player_physics_body.get_wall_normal().x > 0)

func is_looking_down() -> bool :
	return gm.input_manager.bottom_action_is_pressed

func ledge_jump() :
	can_exit = true
	gm.state_machine.transition_to(PlayerJump.get_state_name().to_lower())

func ledge_drop() : 
	can_exit = true
	gm.state_machine.transition_to(PlayerFall.get_state_name().to_lower())

func allow_lateral_movement() -> bool: return false
func sprite_is_reversed() -> bool:	return true
