extends Node
class_name GameManager

## Managers
@onready var player_physics_body = $"../Main character/Character body"
@onready var state_machine = $"../Main character/StateMachine"
@onready var player_animation_controller = $"../Main character/Character body/AnimatedSprite2D"
@onready var speed_boost_manager = $"../Main character/Speed boost manager"

## Camera
@onready var camera = $"../Main character/Character body/Camera2D"
