extends Sprite2D
class_name PlayerSpriteController

#Sprites
var idleSprite
var jumpSprite
var fallSprite
var slideSprite

func _ready() -> void:
	idleSprite = load("res://assets/sprites/Character_Idle.png")
	jumpSprite = load("res://assets/sprites/Character_Jump.png")
	fallSprite = load("res://assets/sprites/Character_Fall.png")
	slideSprite = load("res://assets/sprites/Character_Slide.png") 

func set_sprite(sprite : Resource):
	texture = sprite
