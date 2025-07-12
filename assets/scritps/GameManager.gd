extends Node
class_name GameManager

## Managers
@onready var player_manager = $"../Main character"
@onready var player_physics_body = $"../Main character/Character body"
@onready var state_machine = $"../Main character/StateMachine"
@onready var player_animation_controller = $"../Main character/Character body/AnimatedSprite2D"
@onready var vfx_manager = $"../VFX Manager"
@onready var speed_boost_manager = $"../Main character/Speed boost manager"
@onready var input_manager = $"../Main character/Player Input"
@onready var grab_manager = $"../Main character/Ledge detector"
var game_paused = false

static var instance : GameManager

## Camera
@onready var camera = $"../Main character/Character body/Camera2D"

func _ready() -> void:
	if instance == null : 
		instance = self

func _process(delta: float) -> void:
	if input_manager.reload_action_is_pressed : 
		get_tree().reload_current_scene()

func set_game_paused(paused : bool) :
	game_paused = paused
