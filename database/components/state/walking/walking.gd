extends State

var _entity: Entity

func _ready() -> void:
	_entity = get_parent().get_parent()

func _on_enter() -> void:
	print("Entrando na Walking!")

	var dir = _entity.get_input_direction()

	if dir.x < 0:
		_entity.play_animation_if_not_playing("walking_left")
	elif dir.x > 0:
		_entity.play_animation_if_not_playing("walking_right")
	elif dir.y < 0:
		_entity.play_animation_if_not_playing("walking_up")
	elif dir.y > 0:
		_entity.play_animation_if_not_playing("walking_down")

func _on_next_transitions() -> void:
	if not _entity.is_moving():
		transition.emit("stopped")

func _on_physics_process(_delta: float) -> void:
	pass

func _on_exit() -> void:
	_entity.get_animation().stop()
