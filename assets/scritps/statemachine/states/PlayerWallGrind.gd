extends PlayerFall
class_name PlayerWallGrind

## inspector variables values must be tracked from PlayerFall.gd

@export var gravity_coefficient : float

func get_gravity() -> float :
	return fall_gravity * gravity_coefficient
	
func physics_update(delta: float) :
	super(delta)
	
	if !gm.player_physics_body.lateral_movement_input :
		gm.state_machine.transition_to("fall")
	
	if !gm.player_physics_body.is_on_wall_only() : 
		gm.state_machine.transition_to("idle")

func sprite_is_reversed() -> bool:
	return true;
