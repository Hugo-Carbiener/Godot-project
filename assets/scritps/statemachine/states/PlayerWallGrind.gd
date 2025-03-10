extends PlayerFall
class_name PlayerWallGrind

## inspector variables values must be tracked from PlayerFall.gd

@export var gravity_coefficient : float

func get_gravity() -> float :
	return fall_gravity * gravity_coefficient
	
func physics_update(delta: float) :
	super(delta)
	
	if !player_physics_body.is_on_wall() : 
		state_machine.transition_to("fall")

func sprite_is_reversed() -> bool:
	return true;
