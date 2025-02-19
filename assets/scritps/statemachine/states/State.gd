extends Node
class_name State

@onready
var state_machine = $".."
@onready
var animation_controller = $"../../Character body/AnimatedSprite2D"
@onready
var player_physics_body = $"../../Character body"

@export var animation_name : String
signal Transitioned

var can_exit = true

func can_enter() -> bool:
	return true

func enter(): 
	if animation_name: 
		animation_controller.play(animation_name.to_lower())
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
	
func update_lateral_speed(direction : int, delta : float) :
	player_physics_body.update_lateral_speed(direction, delta)
	
