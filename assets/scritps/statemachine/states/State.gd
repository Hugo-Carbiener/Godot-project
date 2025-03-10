extends Node
class_name State

@onready
var state_machine = $".."
@onready
var animation_controller = $"../../Character body/AnimatedSprite2D"
@onready
var player_physics_body = $"../../Character body"

@export var animation_name : String

@export_group("Collider modifier")
@export var collider_size : Vector2;
@export var collider_position : Vector2;

signal Transitioned

var can_exit = true

func can_enter() -> bool:
	return true
	
func enter(): 
	if animation_name: 
		animation_controller.play(animation_name.to_lower())
		
	var collider = player_physics_body.get_node("Collider")
	collider.shape.size = collider_size
	collider.position = collider_position
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
	
func update_lateral_speed(direction : int, delta : float) :
	player_physics_body.lateral_movement_input = true
	if !allow_lateral_movement() : return
	
	player_physics_body.update_lateral_speed(direction, delta)

func modify_animation(animationControler : AnimatedSprite2D) : 
	return
	
func allow_lateral_movement() -> bool: 
	return true;
	
func sprite_is_reversed() -> bool:
	return false;
