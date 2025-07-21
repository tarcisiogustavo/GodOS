class_name ClientActorListPacket
extends RefCounted


var packet_id: int = Packets.ACTOR_LIST


func handle(max_actors: int, success: Array, errors: Array, scene: SceneTree) -> void:
	var actor_list_ui: ActorListUI = scene.root.get_node("Main/MenuCanvas/ActorList")

	if errors.size() > 0:
		var messages := []
		for e in errors:
			if typeof(e) == TYPE_STRING:
				messages.append(e)

		Notification.show(messages)
		return

	actor_list_ui.update_slots(max_actors, success)
	actor_list_ui.show()
