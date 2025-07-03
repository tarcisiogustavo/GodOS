class_name ActorListInterface
extends PanelContainer


@export var slots_location: HBoxContainer


func update_slot(max_actors: int, actors: Array) -> void:
	if typeof(actors) != TYPE_ARRAY:
		return

	var empty_slot: PackedScene = preload("res://database/interfaces/actor_list/empty_slot.tscn")
	var actor_slot: PackedScene = preload("res://database/interfaces/actor_list/actor_slot.tscn")

	for child in slots_location.get_children():
		child.queue_free()

	for i in range(actors.size()):
		var data: Dictionary = actors[i]

		var slot: ActorSlotInterface = actor_slot.instantiate()
		slot.update_data(data)

		slots_location.add_child(slot)

	var remaining_slots = max_actors - actors.size()
	for i in range(remaining_slots):
		var slot: EmptyActorSlotInterface = empty_slot.instantiate()
		slots_location.add_child(slot)
