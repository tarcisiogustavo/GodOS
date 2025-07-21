class_name ServerDeleteActorPacket
extends RefCounted


var packet_id: int = Packets.DELETE_ACTOR


func handle(actor_id: int, _scene: SceneTree, peer_id: int) -> void:
	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Server.send_to(peer_id, packet_id, [{}, ["Não foi possível te localizar no servidor!"]])
		return

	var endpoint = ServerConstants.backend_endpoint + "actor/" + str(actor_id)
	var headers := {"Content-Type": "application/json"}
	var body := {
		"accountId": user["id"],
	}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_DELETE, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 200:
		Server.send_to(peer_id, packet_id, [{}, Fetch.format_errors(response_data)])
		return

	for i in user["actors"].size():
		if user["actors"][i]["id"] == actor_id:
			user["actors"].remove_at(i)
			break

	Server.send_to(peer_id, packet_id, ["Personagem apagado com sucesso!", []])
