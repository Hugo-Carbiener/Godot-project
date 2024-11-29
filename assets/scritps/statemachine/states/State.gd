extends Node
class_name State

@onready
var state_machine = $".."
@onready
var sprite_controller = $"../../Character body/Sprite"
@onready
var player_physics_body = $"../../Character body"

@export var sprite: Resource
signal Transitioned

var can_exit = true

func can_enter() -> bool:
	return state_machine.current_state.can_exit

func enter(): 
	if sprite: 
		sprite_controller.set_sprite(sprite)
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
