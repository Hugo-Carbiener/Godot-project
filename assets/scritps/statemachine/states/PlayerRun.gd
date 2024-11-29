extends State
class_name PlayerRun

@export var move_speed : int
@export var move_direction : int

# if the player was on the floor during the previous frame
var was_on_floor : bool
var coyote_time_time : float = 0

func can_enter() -> bool:
	return super() and player_physics_body.is_on_floor()

func enter():
	super()
	player_physics_body.velocity.x = move_speed * move_direction	
	
func physics_update(delta: float):
	if !player_physics_body.is_on_floor():
		state_machine.transition_to("fall")
		
	player_physics_body.velocity.x = move_speed * move_direction
