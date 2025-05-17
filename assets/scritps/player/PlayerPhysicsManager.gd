extends CharacterBody2D

@onready var gm = $"../../Game manager"

@export_group("Speed")
@export var max_lateral_speed : float ## The maximum lateral speed the player can naturally reach  
@export var lateral_acceleration : float ## Acceleration in distance unit per second
var lateral_movement_input : bool = false ## Whether there was a lateral directionnal input this frame
@export_group("Drag")
@export var lateral_ground_drag_acceleration : float ## Acceleration from the force opposed to movement when on the ground
@export var lateral_air_drag_acceleration : float ## Acceleration from the force opposed to movement when airborne
@export_group("Snap")
@export var snap_length : float

var was_on_floor : bool = false
var current_speed : Vector2 ## The speed at this frame
var previous_speed : Vector2 ## The speed at the previous frame
var previous_position : Vector2 ## The position at the previous frame 
var current_direction : int
var previous_direction : int ## The direction at the previous frame (> 0 = facing right) 
var coyote_time_start : float = 0

func _physics_process(delta: float) -> void:
	check_coyote_time()
	
	was_on_floor = is_on_floor()
	previous_speed = velocity
	previous_position = position
	previous_direction = current_direction
	
	compute_speed_boost(delta)
	compute_drag(delta)
	move_and_slide()
	
	if is_on_slope() :
		enable_snap()
	else : 
		disable_snap()
	
	velocity.x = current_speed.x
	lateral_movement_input = false

func check_coyote_time() :
	if (was_on_floor == true 
	and is_on_floor() == false 
	and gm.state_machine.current_state is not PlayerJump) :
		register_coyote_time_start()

func register_coyote_time_start() :
	coyote_time_start = Time.get_unix_time_from_system()
	
# Called by the input manager whenever a directionnal input is pressed 
func compute_input_lateral_speed(direction : int, delta : float) :
	if gm.speed_boost_manager.is_speed_boosted() :  return;
	current_direction = direction
	
	var added_velocity = lateral_acceleration * delta * direction
	current_speed.x += added_velocity
	if abs(current_speed.x) > max_lateral_speed :
		current_speed.x = max_lateral_speed * direction

func compute_speed_boost(delta : float) : 
	if !gm.speed_boost_manager.is_speed_boosted() : return
	
	var boost_speed : float
	if gm.speed_boost_manager.boost_remaining_time > gm.speed_boost_manager.boost_fade_duration :
		boost_speed = gm.speed_boost_manager.additional_speed
	else :
		boost_speed = gm.speed_boost_manager.additional_speed * (gm.speed_boost_manager.boost_remaining_time / gm.speed_boost_manager.boost_fade_duration)
	current_speed.x = (max_lateral_speed + boost_speed) * current_direction

func compute_drag(delta : float) :
	if lateral_movement_input || gm.speed_boost_manager.is_speed_boosted() : return
	if velocity.x == 0 : return
	
	var drag_enabled = is_on_floor() && !gm.state_machine.current_state.prevent_drag()
	var drag_acceleration_value = lateral_ground_drag_acceleration if drag_enabled else lateral_air_drag_acceleration
	var drag_value = min(abs(velocity.x), drag_acceleration_value * delta)
	current_speed.x -= (velocity.x / abs(velocity.x)) * drag_value

# Simulate movement to verify if a collision with a ceilling will occur and if so, simulate lateral movement to find the nearest corner
func correct_corners(check_area_width : int, delta : float) : 
	if gm.state_machine.current_state is not PlayerJump : return

	# if we hit a ceilling 
	if test_move(global_transform, Vector2(0, velocity.y) * delta) :
		for pixel_offset in range (1, check_area_width + 1) :
			for direction in [-1 , 1] :
				var collided = test_move(global_transform.translated(Vector2(pixel_offset * direction, 0)), Vector2(0, velocity.y * delta))
				if collided : continue;
				
				global_position.x = round(global_position.x)
				translate(Vector2(pixel_offset * direction, 0))
				return
		

func moved_last_frame() -> bool :
	return previous_position != position

func enable_snap() :
	floor_snap_length = snap_length

func disable_snap() : 
	floor_snap_length = 0

func is_on_slope() -> bool : 
	return get_floor_angle() > 0 && get_floor_angle() < 1
