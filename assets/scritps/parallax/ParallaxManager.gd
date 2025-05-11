extends Node
class_name ParallaxManager

@onready var gm = $"../Game manager"

const LEFT = -1
const RIGHT = 1
@export var parallax_layer_data : Array[ParallaxLayerData]
var parallax_layer_sprite_amount = 3
var layers : Array[Sprite2D]
var camera_previous_position : Vector2
var camera_current_position : Vector2

func _ready() -> void:
	camera_previous_position = gm.camera.global_position
	camera_current_position = gm.camera.global_position
	for layer_index in range(parallax_layer_data.size() * parallax_layer_sprite_amount) :
		setup_layer(layer_index)

func _process(delta: float) -> void:
	camera_previous_position = camera_current_position
	camera_current_position = gm.camera.global_position
	var camera_movement = camera_current_position - camera_previous_position
	
	update_layers_with_cam_movement(camera_movement)
	update_layer_sprites_copy_offset(camera_current_position)

func setup_layer(layer_index : int) : 
	var layer_data_index = floor(layer_index / parallax_layer_sprite_amount)
	var layer_data = parallax_layer_data[layer_data_index]
	
	var sprite = Sprite2D.new()
	sprite.name = "Parallax layer " + str(layer_data_index) + " sprite " + str(layer_index)
	sprite.texture = layer_data.sprite
	sprite.z_index = layer_data.sorting_order
	
	var layer_sprite_offset_coef = layer_index % parallax_layer_sprite_amount - (floor(parallax_layer_sprite_amount / 2)) ## a number describing the position of a layer sprite (-1, 0, 1 for 3 sprites per layer)
	var sprite_copy_offset = Vector2(sprite.texture.get_width() * layer_sprite_offset_coef, 0)
	sprite.position = gm.camera.global_position + layer_data.offset + sprite_copy_offset
	
	layers.append(sprite)
	add_child(sprite)

func update_layers_with_cam_movement(camera_movement : Vector2) : 
	for layer_index in range(layers.size()) :
		var sprite = layers[layer_index]
		var layer_data_index = floor(layer_index / parallax_layer_sprite_amount)
		var layer_data = parallax_layer_data[layer_data_index]
		sprite.position += camera_movement * layer_data.movement_coefficient
	
func update_layer_sprites_copy_offset(camera_current_position : Vector2) :
	for layer_data_index in range(parallax_layer_data.size()): 
		var middle_sprite_index = layer_data_index * parallax_layer_sprite_amount + floor(parallax_layer_sprite_amount / 2)
		var middle_sprite = layers[middle_sprite_index]
		if is_camera_on_copy_sprite(camera_current_position, middle_sprite, LEFT) :
			shift_sprites(middle_sprite_index, LEFT)
			return
		if is_camera_on_copy_sprite(camera_current_position, middle_sprite, RIGHT) :
			shift_sprites(middle_sprite_index, RIGHT)
			return

func is_camera_on_copy_sprite(camera_current_position : Vector2, middle_sprite : Sprite2D, direction : int) -> bool :
	var sprite_width = middle_sprite.texture.get_width()
	return direction == RIGHT && camera_current_position.x > middle_sprite.position.x + (sprite_width * direction / 2) \
		|| direction == LEFT && camera_current_position.x < middle_sprite.position.x + (sprite_width * direction / 2)

func shift_sprites(middle_sprite_index : int, direction : int) :
	var middle_sprite = layers[middle_sprite_index]
	var shift_span = middle_sprite.texture.get_width()
	var sprite_copy_index = middle_sprite_index - floor(parallax_layer_sprite_amount / 2)
	for sprite_index in range(parallax_layer_sprite_amount) :
		var current_sprite = layers[sprite_copy_index]
		current_sprite.position.x += shift_span * direction
		sprite_copy_index += 1
