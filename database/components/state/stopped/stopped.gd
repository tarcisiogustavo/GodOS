extends State

var _entity: Entity

func _ready() -> void:
	_entity = get_parent().get_parent()

func _on_enter() -> void:
	print("Entrando na Stopped!")

	var dir = _entity.get_input_direction()

	if dir.x < 0:
		_entity.play_animation_if_not_playing("stopped_left")
	elif dir.x > 0:
		_entity.play_animation_if_not_playing("stopped_right")
	elif dir.y < 0:
		_entity.play_animation_if_not_playing("stopped_up")
	elif dir.y > 0:
		_entity.play_animation_if_not_playing("stopped_down")

func _on_next_transitions() -> void:
	if _entity.is_moving():
		transition.emit("walking")

func _on_physics_process(_delta: float) -> void:
	pass

func _on_exit() -> void:
	_entity.get_animation().stop()
