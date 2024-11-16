extends Node

enum State {IDLE, JUMP, FALL, SLIDE}

@onready
var physicsBody = $"../Character body"
var state = State.IDLE 

func _process(delta: float) -> void:
	if (!physicsBody.is_on_floor()) and physicsBody.velocity.y < 0:
		state = State.JUMP
	elif (!physicsBody.is_on_floor()) and physicsBody.velocity.y > 0:
		state = State.FALL
	else:
		state = State.IDLE
	pass
