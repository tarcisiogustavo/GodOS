class_name ConfirmationUI
extends PanelContainer


signal on_confirm_button_pressed()


@export_group("Labels")
@export var _message: Label
@export_group("Buttons")
@export var _confirm: Button
@export var _back: Button


func set_message(message: String) -> void:
	_message.text = message


func _on_back_button_pressed() -> void:
	queue_free()


func _on_confirm_button_pressed() -> void:
	on_confirm_button_pressed.emit()
	queue_free()
