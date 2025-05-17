extends Area2D
class_name CornerInteraction

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body) :
	if body == self.get_parent() : return
	print("detected body " + body.name)
	#for child in body.get_children() :
		#if !child is CollisionShape2D : return
		#
		#var collider = child.shape
		#if collider is RectangleShape2D : 
