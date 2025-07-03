class_name Controller
extends Node2D

var _last_direction: Vector2 = Vector2.RIGHT
var _entity: Entity


func _ready() -> void:
	_entity = get_parent() as Entity


func _physics_process(_delta: float) -> void:
	#if not _should_process_input():
		#return

	var input_direction = _get_movement_input()
	_entity.move(input_direction)
	# Chama o movimento no servidor


#func _should_process_input() -> bool:
	#return _entity and _entity.name.to_int() == multiplayer.get_unique_id()


func _get_movement_input() -> Vector2:
	var direction = Input.get_vector("walking_left", "walking_right", "walking_up", "walking_down")

	if direction != Vector2.ZERO:
		_last_direction = direction.normalized()
	else:
		_last_direction = Vector2.ZERO

	return direction
