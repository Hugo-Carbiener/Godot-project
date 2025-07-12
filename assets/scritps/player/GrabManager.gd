extends Node
class_name GrabManager

@onready var gm = $"../../Game manager"

@export_group("Ledge detection")
@export var vertical_ledge_detection_span : int
@export var debug_sprite : Sprite2D
var nearest_detected_ledge : Vector2
var was_above_ledge : bool
var ready_to_grab : bool

func _ready() -> void:
	ready_to_grab = false

func _process(_delta: float) -> void:
	if gm.state_machine.current_state is PlayerWallHang : return
	
	if !gm.player_physics_body.is_on_wall() && nearest_detected_ledge != Vector2.ZERO :
		nearest_detected_ledge = Vector2.ZERO
		debug_sprite.position = Vector2.ZERO
	
	detect_ledge()

func detect_ledge() : 
	if nearest_detected_ledge == Vector2.ZERO && gm.player_physics_body.is_on_wall():
		nearest_detected_ledge = get_ledge_position()
		debug_sprite.position = nearest_detected_ledge
		
	if nearest_detected_ledge == Vector2.ZERO : return
	
	var player_collider_position = gm.player_physics_body.main_collider.global_position
	var is_above_ledge = player_collider_position.y > nearest_detected_ledge.y
	
	if was_above_ledge != is_above_ledge && gm.input_manager.grab_action_is_pressed :
		grab_ledge(nearest_detected_ledge)

func grab_ledge(ledge_corner_position : Vector2) :
	gm.player_physics_body.velocity = Vector2.ZERO
	gm.state_machine.transition_to("wall hang")

func get_ledge_position() -> Vector2 :  
	if !gm.player_physics_body.is_on_wall() : return Vector2.ZERO
	
	var direction = gm.player_physics_body.get_wall_normal().x * -1
	var player_collider_position = gm.player_physics_body.main_collider.global_position
	var right_offset = 1 if direction > 0 else 0
	var x = floor(player_collider_position.x) + (gm.player_physics_body.main_collider.shape.size.x / 2 * direction) + right_offset
	var starting_y = floor(player_collider_position.y) - (vertical_ledge_detection_span / 2)
	var ending_y = floor(player_collider_position.y) + (vertical_ledge_detection_span / 2)
	
	var current_position = Vector2(x, starting_y)
	var was_colliding_at_pos = is_colliding_at_position(current_position)
	var is_colliding_at_pos = is_colliding_at_position(current_position)
	for y in range(starting_y, ending_y) :
		was_colliding_at_pos = is_colliding_at_pos
		current_position = Vector2(x, y)
		is_colliding_at_pos = is_colliding_at_position(current_position)
		
		if !was_colliding_at_pos && is_colliding_at_pos :
			return Vector2(x, y)
	return Vector2.ZERO

func is_colliding_at_position(position: Vector2) -> bool:
	var space_state = get_viewport().get_world_2d().direct_space_state
	var ray_query_param = PhysicsPointQueryParameters2D.new()
	ray_query_param.collision_mask = 1
	ray_query_param.position = position
	var result = space_state.intersect_point(ray_query_param)

	return result.size() > 0
