class_name CreateActorInterface
extends PanelContainer


@export var name_input: LineEdit
@export var create_button: Button
@export var back_button: Button


func _ready() -> void:
	create_button.pressed.connect(_on_create_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)


func _on_create_button_pressed() -> void:
	var name: String = name_input.text

	if name.length() <= 3:
		Notification.show(["O nome precisa ter ao menos 4 caracteres."])
		return

	Network.client.send(Packets.CREATE_ACTOR, [name])


func _on_back_button_pressed() -> void:
	ClientGlobals.menu_interface.show_interface("ActorList")
	ClientGlobals.menu_interface.hide_interface("CreateActor")
