class_name ClientSignUpPacket
extends RefCounted


var packet_id: int = Packets.SIGN_UP


func handle(success: String, errors: Array, scene: SceneTree) -> void:
	var sign_up_ui: SignUpUI = scene.root.get_node("Main/MenuCanvas/SignUp")
	var sign_in_ui: SignInUI = scene.root.get_node("Main/MenuCanvas/SignIn")

	if errors.size() > 0:
		var messages := []
		for e in errors:
			if typeof(e) == TYPE_STRING:
				messages.append(e)

		sign_up_ui.reset()
		Notification.show(messages)
		return

	sign_up_ui.hide()
	sign_up_ui.reset()

	Notification.show([success])
	sign_in_ui.show()
