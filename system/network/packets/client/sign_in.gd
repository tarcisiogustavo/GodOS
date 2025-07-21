class_name ClientSignInPacket
extends RefCounted


var packet_id: int = Packets.SIGN_IN


func handle(_success: Dictionary, errors: Array, scene: SceneTree) -> void:
	var sign_in_ui: SignInUI = scene.root.get_node("Main/MenuCanvas/SignIn")

	if errors.size() > 0:
		var messages := []
		for e in errors:
			if typeof(e) == TYPE_STRING:
				messages.append(e)

		sign_in_ui.reset()
		Notification.show(messages)
		return

	sign_in_ui.hide()
	sign_in_ui.reset()

	Notification.show(["Sucesso ao acessar o jogo!"])
	Client.send(Packets.ACTOR_LIST)
