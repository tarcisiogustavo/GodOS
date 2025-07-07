extends State


@export var entity: Entity
@export var sprite: Sprite2D
@export var animation: AnimationPlayer


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	# Parado para a esquerda
	if entity.last_direction.x < 0:
		animation.play("stopped_left")

	# Parado para cima
	elif entity.last_direction == Vector2.UP:
		animation.play("stopped_up")

	# Parado para a direita
	elif entity.last_direction.x > 0:
		animation.play("stopped_right")

	# Parado para baixo
	elif entity.last_direction.y > 0:
		animation.play("stopped_down")


func _on_next_transitions() -> void:
	if entity.velocity != Vector2.ZERO:
		transition.emit("walking")


func _on_enter() -> void:
	print("Entrou no estado de Stopped")


func _on_exit() -> void:
	animation.stop()
