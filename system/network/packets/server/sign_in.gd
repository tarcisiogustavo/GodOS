class_name ServerSignInPacket
extends RefCounted


var packet_id: int = Packets.SIGN_IN


func handle(email: String, password: String, version: Vector3, _scene: SceneTree, peer_id: int) -> void:
	if version != ServerConstants.version:
		Network.server.send_to(peer_id, packet_id, [-1, "O cliente está desatualizado!"])
		return

	if email.is_empty() or password.is_empty():
		Network.server.send_to(peer_id, packet_id, [-1, "Email e senha são obrigatórios!"])
		return

	var endpoint = ServerConstants.backend_endpoint + "account/sign-in"
	var headers := {"Content-Type": "application/json"}
	var body := {
		"email": email,
		"password": password
	}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_POST, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 201:
		Network.server.send_to(peer_id, packet_id, [-1, Fetch.format_errors(response_data)])
		return

	if ServerGlobals.users.has(peer_id):
		Network.server.send_to(peer_id, packet_id, [-1, ["Você já está autenticado no servidor!"]])
		return

	var user_id = response_data.get("id", null)
	for user in ServerGlobals.users.values():
		if user.get("id", null) == user_id:
			Network.server.send_to(peer_id, packet_id, [-1, ["Essa conta já está conectada ao servidor por outro dispositivo!"]])
			return

	print(response_data)

	ServerGlobals.users[peer_id] = response_data

	Network.server.send_to(peer_id, packet_id, [peer_id, []])
