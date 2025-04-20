extends CharacterBody2D

@onready var state_machine = $"../StateMachine"

@export var max_lateral_speed : float ## The maximum lateral speed the player can naturally reach  
@export var lateral_acceleration : float ## Acceleration in distance unit per second
@export var lateral_ground_drag_acceleration : float ## Acceleration from the force opposed to movement when on the ground
@export var lateral_air_drag_acceleration : float ## Acceleration from the force opposed to movement when airborne

var lateral_movement_input : bool = false ## Whether there was a lateral directionnal input this frame
var was_on_floor : bool = false
var previous_speed : Vector2 ## The speed at the previous frame
var previous_position : Vector2 ## The position at the previous frame 
var coyote_time_start : float = 0

func _physics_process(delta: float) -> void:
	check_coyote_time()
	
	was_on_floor = is_on_floor()
	previous_speed = velocity
	previous_position = position
	apply_drag(delta)
	move_and_slide()
	
func check_coyote_time() :
	if (was_on_floor == true 
	and is_on_floor() == false 
	and state_machine.current_state is not PlayerJump) :
		register_coyote_time_start()

func register_coyote_time_start() :
	coyote_time_start = Time.get_unix_time_from_system()
	
# Called by the input manager whenever a directionnal input is pressed 
func update_lateral_speed(direction : int, delta : float) :
	var added_velocity = lateral_acceleration * delta * direction
	velocity.x += added_velocity
	if abs(velocity.x) > max_lateral_speed :
		velocity.x = max_lateral_speed * direction

func apply_drag(delta : float) :
	if lateral_movement_input : 
		lateral_movement_input = false
		return
		
	if velocity.x == 0 : return
	
	var drag_enabled = is_on_floor() && !state_machine.current_state.prevents_drag()
	var drag_acceleration_value = lateral_ground_drag_acceleration if drag_enabled else lateral_air_drag_acceleration
	var drag_value = min(abs(velocity.x), drag_acceleration_value * delta)
	velocity.x -= (velocity.x / abs(velocity.x)) * drag_value
	lateral_movement_input = false
	
func moved_last_frame() -> bool :
	return previous_position != position;
