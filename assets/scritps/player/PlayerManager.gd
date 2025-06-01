extends Node
class_name PlayerManager

@onready var gm = $"../Game manager"

func respawn() : 
	gm.player_physics_body.respawn()
