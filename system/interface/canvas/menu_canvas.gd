class_name MenuCanvas
extends CanvasLayer


@export var interfaces: Array[Control]


func _ready() -> void:
	for i in interfaces:
		ClientGlobals.menu_interface.add_interface(i)
