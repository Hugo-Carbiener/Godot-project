extends Node
class_name State

@onready var gm = $"../../../Game manager"

@export_group("Collider modifier")
@export var collider_size : Vector2;
@export var collider_position : Vector2;
@export_group("Animation modifier")
@export var animation_name : String
@export var animation_offset : Vector2
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
	
	gm.player_animation_controller.position = animation_offset
	
	var collider = gm.player_physics_body.get_node("Collider")
	collider.shape.size = collider_size
	collider.position = collider_position

func exit() :
	gm.player_animation_controller.position = Vector2.ZERO

func update(_delta: float):
	if gm.player_physics_body.is_on_wall() && PlayerWallClimb.is_input_valid() :
		gm.state_machine.transition_to(PlayerWallClimb.get_state_name().to_lower())
		return
	
	if gm.input_manager.jump_action_is_pressed : 
		gm.state_machine.transition_to(PlayerJump.get_state_name())
		return

	if gm.input_manager.slide_action_is_pressed : 
		gm.state_machine.transition_to(PlayerSlide.get_state_name())
		return
	
func physics_update(_delta: float):
	pass

func modify_animation(_animation_controler : AnimatedSprite2D) : return
func allow_input() -> bool : return true
func allow_lateral_movement() -> bool: return true
func allow_grab_input() -> bool : return false
func sprite_is_reversed() -> bool:	return false
func prevent_drag() -> bool: return false
