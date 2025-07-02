class_name ServerSignInPacket
extends RefCounted


var packet_id: int = Packets.SIGN_IN


func handle(email: String, password: String, version: Vector3, _scene: SceneTree, peer_id: int) -> void:
	if version != ServerConstants.version:
		Network.server.send_to(peer_id, packet_id, ["", "O cliente está desatualizado!"])
		return

	if email.is_empty() or password.is_empty():
		Network.server.send_to(peer_id, packet_id, ["", "Email e senha são obrigatórios!"])
		return

	if not Temp.accounts.has(email):
		Network.server.send_to(peer_id, packet_id, ["", "Email não encontrado!"])
		return

	var account = Temp.accounts[email]
	if account["password"] != password:
		Network.server.send_to(peer_id, packet_id, ["", "Senha incorreta!"])
		return

	var user_actors = []
	if Temp.actors.has(email):
		user_actors = Temp.actors[email]

	print(user_actors)

	var success_data = {
		"email": email,
		"actors": user_actors
	}

	Network.server.send_to(peer_id, packet_id, [success_data, ""])
