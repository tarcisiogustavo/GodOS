class_name WindowManager
extends CanvasLayer


var interfaces: Array[Control] = []


func add_interface(interface: Control) -> void:
	if not interface:
		return

	interfaces.append(interface)


func show_interface(name: String) -> void:
	if name.is_empty():
		return

	for interface in interfaces:
		if interface.name == name:
			interface.show()
			interface.set_process(true)
			return


func hide_interface(name: String) -> void:
	if name.is_empty():
		return

	for interface in interfaces:
		if interface.name == name:
			interface.hide()
			interface.set_process(false)
			return


func get_interface(name: String) -> Control:
	if name.is_empty():
		return null

	for interface in interfaces:
		if interface.name == name:
			return interface

	return null
