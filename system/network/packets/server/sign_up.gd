class_name ServerSignUpPacket
extends RefCounted


var packet_id: int = Packets.SIGN_UP


func handle(email: String, password: String, version: Vector3, _scene: SceneTree, peer_id: int) -> void:
	if version != ServerConstants.version:
		Network.server.send_to(peer_id, packet_id, ["", ["O cliente está desatualizado!"]])
		return

	if email.is_empty() or password.is_empty():
		Network.server.send_to(peer_id, packet_id, ["", ["Email e senha são obrigatórios!"]])
		return

	var endpoint = ServerConstants.backend_endpoint + "account/sign-up"
	var headers := { "Content-Type": "application/json" }
	var body := {
		"email": email,
		"password": password,
		"rePassword": password,
	}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_POST, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 201:
		Network.server.send_to(peer_id, packet_id, ["", Fetch.format_errors(response_data)])
		return

	Network.server.send_to(peer_id, packet_id, ["Sucesso ao se cadastrar no jogo!", []])
