extends Area2D
class_name DeathBox

@onready var gm = $"../Game manager"

@export_group("Fader")
@export var death_fader : Sprite2D
@export var fade_in_duration : float
@export var fade_in_shader : ShaderMaterial
@export_group("Camera movement")
@export var camera_center_duration : float
@export_group("Glitch effect")
@export var player_sprite_copy : Sprite2D
@export var glitch_shader_layer : Sprite2D
@export var glitch_duration : float
@export var glitch_shader : ShaderMaterial
@export_group("Fade out")
@export var fade_out_duration : float
@export var fade_out_shader : ShaderMaterial

var fade_in_timer : Timer = Timer.new()
var camera_timer : Timer = Timer.new()
var glitch_timer : Timer = Timer.new()
var fade_out_timer : Timer = Timer.new()
var start_time : float
var transition_active : bool

const START_TIME_SHADER_PARAM_KEY = "shader_parameter/start_time"
const FADE_IN_SHADER_PARAM_KEY = "shader_parameter/fade_in_duration"
const FADE_OUT_SHADER_PARAM_KEY = "shader_parameter/fade_out_duration"
const Z_ORDER_FADE_IN = 100
const Z_ORDER_PLAYER_SPRITE = 101
const Z_ORDER_GLITCH_EFFECT = 102
const Z_ORDER_FADE_OUT = 103

func _ready() -> void:
	start_time = Time.get_unix_time_from_system()
	transition_active = false
	
	add_child(fade_in_timer)
	add_child(camera_timer)
	add_child(glitch_timer)
	add_child(fade_out_timer)
	fade_in_timer.connect("timeout", on_fade_in_over)
	fade_in_timer.connect("timeout", fade_in_timer.stop)
	camera_timer.connect("timeout", camera_timer.stop)
	glitch_timer.connect("timeout", on_glitch_over)
	glitch_timer.connect("timeout", glitch_timer.stop)
	fade_out_timer.connect("timeout", on_fade_out_over)
	fade_out_timer.connect("timeout", fade_out_timer.stop)
	
	connect("body_entered", start_death_transition)

func _process(delta: float) -> void:
	if transition_active :
		update_camera()

func on_fade_in_over() :
	start_glitch()
	pass

func on_glitch_over() : 
	reset_player_copy()	
	reset_camera()
	start_respawn_fade_out()
	pass

func on_fade_out_over() :
	gm.set_game_paused(false)
	reset_death_transition()

func start_death_transition(body : Node2D) -> void:
	if body != gm.player_physics_body || transition_active: return
	transition_active = true
	
	gm.set_game_paused(true)
	fade_in_timer.start(fade_in_duration)
	camera_timer.start(camera_center_duration)
	glitch_timer.start(fade_in_duration + glitch_duration)
	copy_player()
	start_fader()

func start_fader() : 
	death_fader.global_position = gm.player_physics_body.position
	death_fader.z_index = Z_ORDER_FADE_IN
	death_fader.material = fade_in_shader
	death_fader.material.set(START_TIME_SHADER_PARAM_KEY, Time.get_unix_time_from_system() - start_time)
	death_fader.material.set(FADE_IN_SHADER_PARAM_KEY, fade_in_duration)
	death_fader.visible = true

func update_camera() :
	var cur_pos = gm.camera.position.lerp(Vector2.ZERO, (camera_center_duration - camera_timer.time_left) / camera_center_duration)
	gm.camera.position = cur_pos

func copy_player() : 
	player_sprite_copy.global_position = gm.player_physics_body.position
	player_sprite_copy.scale = gm.player_animation_controller.scale
	player_sprite_copy.z_index = Z_ORDER_PLAYER_SPRITE;
	player_sprite_copy.texture = gm.player_animation_controller.get_current_player_texture()
	
	player_sprite_copy.process_mode = Node.PROCESS_MODE_INHERIT
	player_sprite_copy.visible = true

func start_glitch() :
	glitch_shader_layer.global_position = gm.player_physics_body.position
	glitch_shader_layer.texture = gm.player_animation_controller.get_current_player_texture()
	glitch_shader_layer.material = glitch_shader.duplicate()
	glitch_shader_layer.z_index = Z_ORDER_GLITCH_EFFECT
	
	glitch_shader_layer.process_mode = Node.PROCESS_MODE_INHERIT
	glitch_shader_layer.visible = true

func start_respawn_fade_out() : 
	gm.player_manager.respawn()
	
	death_fader.global_position = gm.player_physics_body.position
	death_fader.z_index = Z_ORDER_FADE_OUT
	death_fader.material = fade_out_shader
	death_fader.material.set(START_TIME_SHADER_PARAM_KEY, Time.get_unix_time_from_system() - start_time)
	death_fader.material.set(FADE_OUT_SHADER_PARAM_KEY, fade_out_duration)
	fade_out_timer.start(fade_out_duration)

func reset_death_transition() :
	transition_active = false
	reset_fader()

func reset_fader() : 
	death_fader.visible = false
	player_sprite_copy.process_mode = Node.PROCESS_MODE_DISABLED

func reset_camera() :
	gm.camera.reset_position()

func reset_player_copy() : 
	player_sprite_copy.visible = false
	player_sprite_copy.process_mode = Node.PROCESS_MODE_DISABLED
	glitch_shader_layer.visible = false
	glitch_shader_layer.process_mode = Node.PROCESS_MODE_DISABLED
