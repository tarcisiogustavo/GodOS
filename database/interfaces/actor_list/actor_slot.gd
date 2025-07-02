class_name ActorSlotInterface
extends PanelContainer


@export var name_label: Label
@export var access_button: Button
@export var new_button: Button
@export var delete_button: Button


var actor_data: Dictionary = {}


func _ready() -> void:
	access_button.pressed.connect(_on_access_button_pressed)
	new_button.pressed.connect(_on_new_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)


func set_has_character(has_character: bool) -> void:
	access_button.visible = has_character


func _on_access_button_pressed() -> void:
	Network.client.send(Packets.SELECT_ACTOR, [actor_data["id"]])


func _on_new_button_pressed() -> void:
	ClientGlobals.menu_interface.show_interface("CreateActor")
	ClientGlobals.menu_interface.hide_interface("ActorList")


func _on_delete_button_pressed() -> void:
	Network.client.send(Packets.DELETE_ACTOR, [actor_data["id"]])
