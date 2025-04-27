extends CharacterBody2D

@onready var state_machine = $"../StateMachine"
@onready var speed_boost_manager = $"../Speed boost manager"

@export_group("Speed")
@export var max_lateral_speed : float ## The maximum lateral speed the player can naturally reach  
@export var lateral_acceleration : float ## Acceleration in distance unit per second
var lateral_movement_input : bool = false ## Whether there was a lateral directionnal input this frame
@export_group("Drag")
@export var lateral_ground_drag_acceleration : float ## Acceleration from the force opposed to movement when on the ground
@export var lateral_air_drag_acceleration : float ## Acceleration from the force opposed to movement when airborne

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
	velocity.x = current_speed.x
	lateral_movement_input = false

func check_coyote_time() :
	if (was_on_floor == true 
	and is_on_floor() == false 
	and state_machine.current_state is not PlayerJump) :
		register_coyote_time_start()

func register_coyote_time_start() :
	coyote_time_start = Time.get_unix_time_from_system()
	
# Called by the input manager whenever a directionnal input is pressed 
func compute_input_lateral_speed(direction : int, delta : float) :
	if speed_boost_manager.is_speed_boosted() :  return;
	current_direction = direction
	
	var added_velocity = lateral_acceleration * delta * direction
	current_speed.x += added_velocity
	if abs(current_speed.x) > max_lateral_speed :
		current_speed.x = max_lateral_speed * direction

func compute_speed_boost(delta : float) : 
	if !speed_boost_manager.is_speed_boosted() : return
	
	var boost_speed : float
	if speed_boost_manager.boost_remaining_time > speed_boost_manager.boost_fade_duration :
		boost_speed = speed_boost_manager.additional_speed
	else :
		boost_speed = speed_boost_manager.additional_speed * (speed_boost_manager.boost_remaining_time / speed_boost_manager.boost_fade_duration)
	current_speed.x = (max_lateral_speed + boost_speed) * current_direction

func compute_drag(delta : float) :
	if lateral_movement_input || speed_boost_manager.is_speed_boosted() : return
	if velocity.x == 0 : return
	
	var drag_enabled = is_on_floor() && !state_machine.current_state.prevent_drag()
	var drag_acceleration_value = lateral_ground_drag_acceleration if drag_enabled else lateral_air_drag_acceleration
	var drag_value = min(abs(velocity.x), drag_acceleration_value * delta)
	current_speed.x -= (velocity.x / abs(velocity.x)) * drag_value

func moved_last_frame() -> bool :
	return previous_position != position
