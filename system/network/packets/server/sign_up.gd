class_name ServerSignUpPacket
extends RefCounted


var packet_id: int = Packets.SIGN_UP


func handle(email: String, password: String, version: Vector3, _scene: SceneTree, peer_id: int) -> void:
	if version != ServerConstants.version:
		Network.server.send_to(peer_id, packet_id, ["", "O cliente está desatualizado!"])
		return

	if email.is_empty() or password.is_empty():
		Network.server.send_to(peer_id, packet_id, ["", "Email e senha são obrigatórios!"])
		return

	if Temp.accounts.has(email):
		Network.server.send_to(peer_id, packet_id, ["", "Email informado já está cadastrado!"])
		return

	Temp.accounts[email] = {
		"password": password,
	}

	Temp.actors[email] = []

	print("sucesso")

	Network.server.send_to(peer_id, packet_id, ["Sucesso ao se cadastrar no jogo!", ""])
