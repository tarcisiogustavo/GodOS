extends Node


var confirmation: ConfirmationUI = null


func show(message: String) -> void:
	var confirmation_scene: PackedScene = load("res://database/ui/confirmation/confirmation.tscn")
	confirmation = confirmation_scene.instantiate()
	confirmation.set_message(message)

	var shared_canvas: CanvasLayer = get_tree().root.get_node("Main/SharedCanvas")
	shared_canvas.add_child(confirmation)
