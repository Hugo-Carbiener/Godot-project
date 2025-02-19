extends CharacterBody2D

@onready var stateMachine = $"../StateMachine"

@export var max_lateral_speed : float ## The maximum lateral speed the player can naturally reach  
@export var lateral_acceleration : float ## Acceleration in distance unit per second
var was_on_floor : bool = false
var coyote_time_start : float = 0

func _physics_process(delta: float) -> void:
	check_coyote_time()
	
	was_on_floor = is_on_floor()
	move_and_slide()
	
func check_coyote_time() :
	if (was_on_floor == true 
	and is_on_floor() == false 
	and stateMachine.current_state is not PlayerJump):
		register_coyote_time_start()

func register_coyote_time_start():
	coyote_time_start = Time.get_unix_time_from_system()
	
	
func update_lateral_speed(direction : int, delta : float) :
	var added_velocity = lateral_acceleration * delta * direction
	velocity.x += added_velocity
	if (abs(velocity.x) > max_lateral_speed) :
		velocity.x = max_lateral_speed * direction
