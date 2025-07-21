class_name ActorListUI
extends PanelContainer


@export_group("HBox's")
@export var _slots_location: HBoxContainer
@export_group("References")
@export var _empty_slot: PackedScene
@export var _actor_slot: PackedScene


func update_slots(max_actors: int, actors: Array) -> void:
	for child in _slots_location.get_children():
		child.queue_free()

	for i in range(actors.size()):
		var data: Dictionary = actors[i]

		var slot: ActorSlotUI = _actor_slot.instantiate()
		slot.update_data(data)

		_slots_location.add_child(slot)

	for i in range(max_actors - actors.size()):
		var slot: EmptySlotActorUI = _empty_slot.instantiate()
		_slots_location.add_child(slot)
