extends State


@export var entity: Entity
@export var sprite: Sprite2D
@export var animation: AnimationPlayer


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	# Movendo para a esquerda
	if entity.velocity.x < 0:
		animation.play("walking_left")

	# Movendo para cima
	elif entity.velocity.y < 0:
		animation.play("walking_up")

	# Movendo para a direita
	elif entity.velocity.x > 0:
		animation.play("walking_right")

	# Movendo para baixo
	elif entity.velocity.y > 0:
		animation.play("walking_down")


func _on_next_transitions() -> void:
	if entity.velocity == Vector2.ZERO:
		transition.emit("stopped")


func _on_enter() -> void:
	print("Entrou no estado de Walking")


func _on_exit() -> void:
	animation.stop()
