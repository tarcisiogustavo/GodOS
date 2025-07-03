class_name ClientDeleteActorPacket
extends RefCounted


var packet_id: int = Packets.DELETE_ACTOR


func handle(message: String, error: Array, scene: SceneTree) -> void:
	if not error.is_empty():
		Notification.show(error)
		return

	Notification.show([message])

	Network.client.send(Packets.ACTOR_LIST)
