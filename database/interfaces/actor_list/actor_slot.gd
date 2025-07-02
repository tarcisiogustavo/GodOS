class_name ActorSlotInterface
extends PanelContainer


@export var name_label: Label
@export var access_button: Button
@export var new_button: Button
@export var delete_button: Button


func _ready() -> void:
	access_button.pressed.connect(_on_access_button_pressed)
	new_button.pressed.connect(_on_new_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)


func set_has_character(has_character: bool) -> void:
	access_button.visible = has_character


func _on_access_button_pressed() -> void:
	pass


func _on_new_button_pressed() -> void:
	pass


func _on_delete_button_pressed() -> void:
	pass
