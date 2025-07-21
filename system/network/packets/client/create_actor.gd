class_name ClientCreateActorPacket
extends RefCounted


var packet_id: int = Packets.CREATE_ACTOR


func handle(success: String, errors: Array, scene: SceneTree) -> void:
	if errors.size() > 0:
		var messages := []
		for e in errors:
			if typeof(e) == TYPE_STRING:
				messages.append(e)

		Notification.show(messages)
		return

	var create_actor_ui: CreateActorUI = scene.root.get_node("Main/MenuCanvas/CreateActor")
	create_actor_ui.reset()
	create_actor_ui.hide()

	Notification.show([success])
	Client.send(Packets.ACTOR_LIST)
