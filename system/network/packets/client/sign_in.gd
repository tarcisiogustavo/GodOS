class_name ClientSignInPacket
extends RefCounted


var packet_id: int = Packets.SIGN_IN


func handle(success: Dictionary, error: String, scene: SceneTree) -> void:
	if error != "":
		#Notification.show(error)
		return

	var sign_in_interface: SignInInterface = scene.root.get_node("Client/MenuCanvas/SignIn")
	var actor_list_interface: ActorListInterface = scene.root.get_node("Client/MenuCanvas/ActorList")

	sign_in_interface.hide()
	sign_in_interface.reset_form()

	actor_list_interface.show()
	var actors: Array = success.get("actors", [])
	actor_list_interface.update_slot(actors.size() || 3, actors)
