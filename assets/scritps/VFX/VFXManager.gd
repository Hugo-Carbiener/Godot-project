extends Node
class_name VFXManager

@onready var gm = $"../Game manager"

@export_group("Step smoke puff fx")
@export var step_smoke_animation : AnimatedSprite2D
@export var step_smoke_sprite_amount : int
@export var step_smoke_layer_order : int
@export var step_smoke_reversed : bool
var step_smoke_pool : Array[AnimatedSprite2D]
@export_group("Slide smoke puff fx")
@export var slide_smoke_animation : AnimatedSprite2D
@export var slide_smoke_sprite_amount : int
@export var slide_smoke_layer_order : int
@export var slide_smoke_reversed : bool
var slide_smoke_pool : Array[AnimatedSprite2D]

enum VFX {
	STEP_SMOKE,
	SLIDE_SMOKE
}

func _ready() -> void:
	## init step smoke fx
	init_vfx(step_smoke_pool, step_smoke_animation, step_smoke_layer_order, step_smoke_reversed, step_smoke_sprite_amount, "Step smoke")
	## init slide smoke fx
	init_vfx(slide_smoke_pool, slide_smoke_animation, slide_smoke_layer_order, slide_smoke_reversed, slide_smoke_sprite_amount, "Slide smoke")

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

func start_vfx_animation(position : Vector2, direction : int, vfx : VFX) :
	var sprite_pool : Array[AnimatedSprite2D]
	match vfx :
		VFX.STEP_SMOKE :
			sprite_pool = step_smoke_pool
		VFX.SLIDE_SMOKE : 
			sprite_pool = slide_smoke_pool
		_ : 
			printerr("Invalid vfx type : " + str(vfx))
			return
			
	var sprite = get_vfx_animated_sprite(sprite_pool)
	if sprite == null : 
		printerr("No available vfx instance of type " + str(vfx) + " in pool of size " + str(sprite_pool.size()))
		return
		
	instantiate_vfx(position, direction, sprite)

func instantiate_vfx(position : Vector2, direction : int, animation : AnimatedSprite2D) : 
	animation.connect("animation_finished", stop_vfx.bind(animation))
	animation.position = position
	animation.scale.x = abs(gm.player_physics_body.scale.x) * direction
	animation.set_process(true)
	animation.visible = true
	animation.play(animation.animation)

func get_vfx_animated_sprite(sprite_array : Array[AnimatedSprite2D]) -> AnimatedSprite2D :
	for sprite in sprite_array :
		if !sprite.visible :
			return sprite
	return null

func stop_vfx(animation : AnimatedSprite2D) : 
	animation.disconnect("animation_finished", stop_vfx.bind(animation))
	animation.stop()
	animation.set_process(false)
	animation.visible = false
