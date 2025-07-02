class_name NotificationInterface
extends PanelContainer


@export var message: Label
@export var close_button: Button


func _ready() -> void:
	close_button.pressed.connect(func(): queue_free())
