class_name ActorList
extends PanelContainer


@export var slots_location: HBoxContainer


func update_slot(max_actors: int, actors: Array) -> void:
	if slots_location == null:
		return

	if typeof(actors) != TYPE_ARRAY:
		return

	var slot_scene: PackedScene = preload("res://database/interfaces/actor_list/actor_slot.tscn")

	for child in slots_location.get_children():
		child.queue_free()

	for i in range(max_actors):
		var slot_instance = slot_scene.instantiate()
		var has_character = i < actors.size() and actors[i] != null

		if has_character:
			slot_instance.name_label.text = actors[i]["name"]
		else:
			slot_instance.name_label.text = ""

		if slot_instance.has_method("set_has_character"):
			slot_instance.set_has_character(has_character)

		slots_location.add_child(slot_instance)
