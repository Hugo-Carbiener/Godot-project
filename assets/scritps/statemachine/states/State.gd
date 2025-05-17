extends Node
class_name State

@onready var gm = $"../../../Game manager"

@export var animation_name : String
@export_group("Collider modifier")
@export var collider_size : Vector2;
@export var collider_position : Vector2;

signal Transitioned

var can_exit = true

static func get_state_name() -> String:
	assert(false)
	return ""

func can_enter() -> bool:
	return true
	
func enter(): 
	if animation_name: 
		gm.player_animation_controller.play(animation_name.to_lower())
		
	var collider = gm.player_physics_body.get_node("Collider")
	collider.shape.size = collider_size
	collider.position = collider_position
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
	
func update_lateral_speed(direction : int, delta : float) :
	gm.player_physics_body.lateral_movement_input = true
	if !allow_lateral_movement() : return
	
	gm.player_physics_body.compute_input_lateral_speed(direction, delta)

func modify_animation(animationControler : AnimatedSprite2D) : return
func allow_lateral_movement() -> bool: return true
func allow_input() -> bool : return true
func sprite_is_reversed() -> bool:	return false
func prevent_drag() -> bool: return false
