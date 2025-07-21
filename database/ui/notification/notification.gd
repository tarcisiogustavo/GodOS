class_name NotificationUI
extends PanelContainer


@export_group("Labels")
@export var _message: Label
@export_group("Buttons")
@export var _close: Button


func set_messages(messages: Array) -> void:
	_message.text = "\n".join(messages)


func _on_close_button_pressed() -> void:
	queue_free()
