class_name ClientCreateActorPacket
extends RefCounted


var packet_id: int = Packets.CREATE_ACTOR


func handle(message: String, error: Array, scene: SceneTree) -> void:
	if not error.is_empty():
		Notification.show(error)
		return

	var create_actor_interface: CreateActorInterface = scene.root.get_node("Client/MenuCanvas/CreateActor")
	create_actor_interface.hide()

	Notification.show([message])

	Network.client.send(Packets.ACTOR_LIST)
