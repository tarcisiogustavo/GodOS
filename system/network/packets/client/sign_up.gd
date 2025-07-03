class_name ClientSignUpPacket
extends RefCounted


var packet_id: int = Packets.SIGN_UP


func handle(success: String, error: Array, scene: SceneTree) -> void:
	var sign_up_interface: SignUpInterface = scene.root.get_node("Client/MenuCanvas/SignUp")
	var sign_in_interface: SignInInterface = scene.root.get_node("Client/MenuCanvas/SignIn")

	if not error.is_empty():
		sign_up_interface.reset_form()

		Notification.show(error)
		return

	sign_up_interface.hide()
	sign_up_interface.reset_form()

	sign_in_interface.show()

	Notification.show([success])
