extends Node
class_name VFXManager

@onready var gm = $"../Game manager"

@export_group("Step smoke puff fx")
@export var small_smoke_vfx_data : VFXData
var step_smoke_pool : Array[AnimatedSprite2D]
@export_group("Slide smoke puff fx")
@export var big_smoke_vfx_data : VFXData
var slide_smoke_pool : Array[AnimatedSprite2D]

enum VFX {
	SMALL_SMOKE,
	BIG_SMOKE
}

func _ready() -> void:
	## init step smoke fx
	init_vfx_data(small_smoke_vfx_data)
	#init_vfx(step_smoke_pool, step_smoke_animation, step_smoke_layer_order, step_smoke_reversed, step_smoke_sprite_amount, "Step smoke")
	## init slide smoke fx
	init_vfx_data(big_smoke_vfx_data)
	#init_vfx(slide_smoke_pool, slide_smoke_animation, slide_smoke_layer_order, slide_smoke_reversed, slide_smoke_sprite_amount, "Slide smoke")

func init_vfx(pool : Array[AnimatedSprite2D], sprite : AnimatedSprite2D, layer_order : int, is_reversed : bool, instance_amount : int, instance_name : String) :
	pool.append(sprite)
	sprite.set_process(false)
	sprite.visible = false
	sprite.z_index = layer_order
	sprite.flip_h = is_reversed
	pool.append(sprite)
	
	for instance_idx in instance_amount - 1 :
		var sprite_copy = sprite.duplicate()
		sprite_copy.name = instance_name + " " + str(instance_idx)
		pool.append(sprite_copy)
		add_child(sprite_copy)

func init_vfx_data(vfx_data : VFXData) :
	var animated_sprite = AnimatedSprite2D.new()
	
	animated_sprite.name = vfx_data.vfx_name + " 0"
	animated_sprite.sprite_frames = vfx_data.sprite_frame
	animated_sprite.set_process(false)
	animated_sprite.visible = false
	animated_sprite.z_index = vfx_data.layer_order
	animated_sprite.flip_h = vfx_data.is_reversed
	vfx_data.sprite_pool.append(animated_sprite)
	add_child(animated_sprite)
	
	for instance_idx in vfx_data.sprite_amount - 1 :
		var sprite_copy = animated_sprite.duplicate()
		sprite_copy.name = vfx_data.vfx_name + " " + str(instance_idx + 1)
		vfx_data.sprite_pool.append(sprite_copy)
		add_child(sprite_copy)

func start_vfx_animation(position : Vector2, direction : int, vfx : VFX) :
	var sprite_pool : Array[AnimatedSprite2D]
	match vfx :
		VFX.SMALL_SMOKE :
			sprite_pool = small_smoke_vfx_data.sprite_pool
		VFX.BIG_SMOKE : 
			sprite_pool = big_smoke_vfx_data.sprite_pool
		_ : 
			printerr("Invalid vfx type : " + str(vfx))
			return
			
	var sprite = get_vfx_animated_sprite(sprite_pool)
	if sprite == null : 
		printerr("No available vfx instance of type " + str(vfx) + " in pool of size " + str(sprite_pool.size()))
		return
		
	instantiate_vfx(position, direction, sprite)

func instantiate_vfx(position : Vector2, direction : int, sprite : AnimatedSprite2D) : 
	sprite.connect("animation_finished", stop_vfx.bind(sprite))
	sprite.position = position
	sprite.scale.x = abs(gm.player_physics_body.scale.x) * direction
	sprite.set_process(true)
	sprite.visible = true
	sprite.play(sprite.animation)

func get_vfx_animated_sprite(sprite_array : Array[AnimatedSprite2D]) -> AnimatedSprite2D :
	for sprite in sprite_array :
		if sprite != null && !sprite.visible :
			return sprite
	return null

func stop_vfx(sprite : AnimatedSprite2D) : 
	sprite.disconnect("animation_finished", stop_vfx.bind(sprite))
	sprite.stop()
	sprite.set_process(false)
	sprite.visible = false
