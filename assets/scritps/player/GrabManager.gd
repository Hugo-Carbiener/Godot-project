extends Node
class_name GrabManager

@onready var gm = $"../../../Game manager"

@export var left_collider : CollisionShape2D
@export var right_collider : CollisionShape2D
@export var left_detector : CollisionShape2D
@export var right_detector : CollisionShape2D
var left_collider_enabled : bool
var right_collider_enabled : bool

func _process(_delta: float) -> void:
	left_collider.disabled = !gm.input_manager.grab_action_is_pressed
	right_collider.disabled = !gm.input_manager.grab_action_is_pressed
