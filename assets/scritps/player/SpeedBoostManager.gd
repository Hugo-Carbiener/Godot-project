
extends Node
class_name SpeedBoost_manager

@onready var gm = $"../../Game manager"

const COLOR_SHADER_PARAM_KEY = "shader_parameter/color"
const ALPHA_SHADER_PARAM_KEY = "shader_parameter/alpha"

@export_group("Physics variables")
@export var additional_speed : float 
@export var boost_duration : float
@export var boost_fade_duration : float
var boost_remaining_time : float

@export_group("Input variables")
@export var input_time_span : float
var boost_can_be_input : bool

@export_group("Ghost variables")
@export var ghost_amount : int
@export var ghost_shader : ShaderMaterial
@export var ghost_colors : Array[Color]
var ghosts : Array[AnimatedSprite2D]
var ghost_positions : Array[Vector2]
var ghosts_are_enabled : bool 

func _ready():
	boost_can_be_input = false
	init_ghosts()
	
func _process(delta: float) -> void : 
	if ghosts_are_enabled : 
		if boost_remaining_time > 0 :
			boost_remaining_time -= delta
			update_ghosts()
		else : 
			ghosts_are_enabled = false
		
		if boost_remaining_time <= boost_fade_duration :
			update_ghost_fader(boost_remaining_time / boost_fade_duration)

func is_speed_boosted() -> bool : 
	return boost_remaining_time > 0

func start_speed_boost() :
	boost_remaining_time = boost_duration + boost_fade_duration
	ghosts_are_enabled = true

## Called by a transition state to make the boost input available to the player
func unlock_speed_boost_input() : 
	boost_can_be_input = true
	gm.player_animation_controller.darken_sprite()
	var timer = Timer.new()
	add_child(timer)
	timer.start(input_time_span)
	timer.connect("timeout", lock_speed_boost_input)
	
func lock_speed_boost_input() :
	gm.player_animation_controller.reset_sprite_color()
	boost_can_be_input = false
	
func can_be_input() -> bool : 
	return boost_can_be_input

## --- GHOSTS --- ##

func init_ghosts() : 
	assert(ghost_colors.size() == ghost_amount)
	
	ghosts_are_enabled = false
	for ghost_index in ghost_amount : 
		ghost_positions.append(Vector2.ZERO)

		var sprite = AnimatedSprite2D.new()
		sprite.name = "Ghost " + str(ghost_index)
		sprite.process_mode = Node.PROCESS_MODE_DISABLED
		sprite.sprite_frames = gm.player_animation_controller.sprite_frames
		sprite.material = ghost_shader.duplicate()
		sprite.material.set(COLOR_SHADER_PARAM_KEY, ghost_colors[ghost_index])
		sprite.material.set(ALPHA_SHADER_PARAM_KEY, 1 - ((float(ghost_index) + 1) / (ghost_amount + 1)))
		sprite.z_index = gm.player_animation_controller.z_index + gm.player_physics_body.z_index - (ghost_index + 1)
		ghosts.append(sprite)
		add_child(sprite)

func update_ghosts() :
	for n in range(ghost_amount - 1, 0, -1) : 
		ghost_positions[n] = ghost_positions[n - 1]
	ghost_positions[0] = gm.player_physics_body.previous_position
	
	for ghost_index in ghosts.size() :
		var current_ghost = ghosts[ghost_index]
		## position
		current_ghost.position = ghost_positions[ghost_index]
		current_ghost.scale = gm.player_animation_controller.scale
		
		## animation frame
		current_ghost.animation = gm.player_animation_controller.animation
		var frame_index = gm.player_animation_controller.frame - (ghost_index + 1)
		if frame_index < 0 : frame_index += current_ghost.sprite_frames.get_frame_count(current_ghost.animation)
		current_ghost.frame = frame_index
		
		## enable first goes
		if ghost_index == 0 : 
			if current_ghost.process_mode == 4 : 
				current_ghost.process_mode = 0
			continue
		
		## enable further ghosts after the first frame
		var previous_ghost = ghosts[ghost_index - 1]
		if current_ghost.process_mode == 4 && previous_ghost.process_mode == 0 :
			current_ghost.process_mode = 0

func update_ghost_fader(fade_out_progression : float) :
	for ghost in ghosts : 
		var current_alpha = ghost.material.get(ALPHA_SHADER_PARAM_KEY)
		var new_alpha : float
		if fade_out_progression < 0 :
			ghost.process_mode = 4
		elif current_alpha < fade_out_progression : new_alpha = current_alpha
		else : new_alpha = fade_out_progression
		ghost.material.set(ALPHA_SHADER_PARAM_KEY, new_alpha)
