class_name Controller
extends Node2D


var _entity: Entity


func _ready() -> void:
	_entity = get_parent() as Entity


func _physics_process(_delta: float) -> void:
	if not _entity or not _entity.controllable:
		return

	_handle_action_inputs()

	if _entity.is_animation_locked:
		return

	if _entity.is_moving:
		return

	var direction := _get_input_direction()

	#if direction != Vector2.ZERO:
		#_entity.move_to(direction)


func _handle_action_inputs() -> void:
	if Input.is_action_just_pressed("attack"):
		_entity.attack()


func _get_input_direction() -> Vector2:
	if Input.is_action_pressed("walking_left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("walking_right"):
		return Vector2.RIGHT
	elif Input.is_action_pressed("walking_up"):
		return Vector2.UP
	elif Input.is_action_pressed("walking_down"):
		return Vector2.DOWN

	return Vector2.ZERO
