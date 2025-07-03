class_name ClientSignInPacket
extends RefCounted


var packet_id: int = Packets.SIGN_IN


func handle(success: String, error: Array, scene: SceneTree) -> void:
	if not error.is_empty():
		Notification.show(error)
		return

	var sign_in_interface: SignInInterface = scene.root.get_node("Client/MenuCanvas/SignIn")

	sign_in_interface.hide()
	sign_in_interface.reset_form()

	Notification.show([success])

	Network.client.send(Packets.ACTOR_LIST)
