extends Node


var notification: NotificationUI = null


func show(messages: Array) -> void:
	var filtered_messages: Array[String] = []
	for message in messages:
		if typeof(message) == TYPE_STRING:
			filtered_messages.append(message)

	var notification_scene: PackedScene = load("res://database/ui/notification/notification.tscn")
	notification = notification_scene.instantiate()
	notification.set_messages(filtered_messages)

	var shared_canvas: CanvasLayer = get_tree().root.get_node("Main/SharedCanvas")
	shared_canvas.add_child(notification)
