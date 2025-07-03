class_name ClientActorListPacket
extends RefCounted


var packet_id: int = Packets.ACTOR_LIST


func handle(max_actors: int, actors: Array, error: Array, scene: SceneTree) -> void:
	if not error.is_empty():
		Notification.show(error)
		return

	var actor_list_interface: ActorListInterface = scene.root.get_node("Client/MenuCanvas/ActorList")

	actor_list_interface.show()
	actor_list_interface.update_slot(max_actors, actors)
