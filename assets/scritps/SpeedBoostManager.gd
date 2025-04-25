extends Node
class_name SpeedBoost_manager

@onready var animation_controller = $"../Character body/AnimatedSprite2D"

@export_group("Physics variables")
@export var additional_speed : float 
@export var boost_duration : float
@export var boost_fade_duration : float
var boost_remaining_time : float

@export_group("Input variables")
@export var input_time_span : float
var input_time_remaining : float
var boost_can_be_input : bool

func is_speed_boosted() -> bool : 
	return boost_remaining_time > 0

func start_speed_boost() :
	boost_remaining_time = boost_duration + boost_fade_duration

## Called by a transition state to make the boost input available to the player
func unlock_speed_boost_input() : 
	boost_can_be_input = true
	animation_controller.darken_sprite()
	input_time_remaining = input_time_span
	
func can_be_input() -> bool : 
	return boost_can_be_input

func _ready():
	boost_can_be_input = false

func _process(delta: float) -> void : 
	if !boost_can_be_input : return
	
	input_time_remaining -= delta
	if input_time_remaining <= 0 :
		animation_controller.reset_sprite_color()
		boost_can_be_input = false
