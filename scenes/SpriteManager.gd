extends Sprite2D

@onready
var stateManager = $"../../State manager"

#Sprites
var idleSprite
var jumpSprite
var fallSprite
var slideSprite

func _ready() -> void:
	idleSprite = load("res://Character_Idle.png")
	jumpSprite = load("res://Character_Jump.png")
	fallSprite = load("res://Character_Fall.png")
	slideSprite = load("res://Character_Slide.png")
	pass 


func _process(delta: float) -> void:
	match stateManager.state:
		stateManager.State.IDLE:
			texture = idleSprite
		stateManager.State.JUMP:
			texture = jumpSprite
		stateManager.State.FALL:
			texture = fallSprite
		stateManager.State.SLIDE:
			texture = slideSprite 	
	pass
