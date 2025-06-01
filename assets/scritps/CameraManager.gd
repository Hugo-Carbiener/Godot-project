extends Node
class_name CameraManager

var initial_local_position : Vector2

func _ready() -> void:
	initial_local_position = self.position

func reset_position() :
	self.position = initial_local_position
