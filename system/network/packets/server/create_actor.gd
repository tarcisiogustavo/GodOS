class_name ServerCreateActorPacket
extends RefCounted


var packet_id: int = Packets.CREATE_ACTOR


func handle(name: String, _scene: SceneTree, peer_id: int) -> void:
	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Network.server.send_to(peer_id, packet_id, ["", "Não foi possível te localizar no servidor!"])
		return

	if name.is_empty():
		Network.server.send_to(peer_id, packet_id, ["", ["O nome do usuário é obrigatório!"]])
		return

	var endpoint = ServerConstants.backend_endpoint + "actor"
	var headers := {"Content-Type": "application/json"}
	var body := {
		"accountId": user["id"],
		"name": name,
		"mapId": 1,
		"positionX": 32,
		"positionY": 32
	}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_POST, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 201:
		Network.server.send_to(peer_id, packet_id, ["", Fetch.format_errors(response_data)])
		return

	Network.server.send_to(peer_id, packet_id, ["Sucesso ao criar o personagem!", []]);
