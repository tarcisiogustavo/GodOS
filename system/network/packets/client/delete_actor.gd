class_name ClientDeleteActorPacket
extends RefCounted


var packet_id: int = Packets.DELETE_ACTOR


func handle(success: String, errors: Array, _scene: SceneTree) -> void:
	if errors.size() > 0:
		var messages := []
		for e in errors:
			if typeof(e) == TYPE_STRING:
				messages.append(e)

		Notification.show(messages)
		return

	Notification.show([success])
	Client.send(Packets.ACTOR_LIST)
