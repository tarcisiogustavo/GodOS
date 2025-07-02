extends Node


func show(message: String) -> void:
	var notification_scene: PackedScene = preload(
		"res://database/interfaces/notification/notification.tscn"
	)

	var notification_scene_instance: NotificationInterface = notification_scene.instantiate()
	notification_scene_instance.message.text = message

	var shared_canvas: CanvasLayer = get_tree().root.get_node("Client/SharedCanvas")
	shared_canvas.add_child(notification_scene_instance)
