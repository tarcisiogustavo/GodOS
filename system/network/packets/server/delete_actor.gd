class_name ServerDeleteActorPacket
extends RefCounted


var packet_id: int = Packets.DELETE_ACTOR


func handle(actor_id: int, scene: SceneTree, peer_id: int) -> void:
	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Network.server.send_to(peer_id, packet_id, ["Não foi possível te localizar no servidor!"])
		return

	var endpoint = ServerConstants.backend_endpoint + "actor"
	var headers := {"Content-Type": "application/json"}
	var body := {
		"id": actor_id,
		"accountId": user["id"],
	}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_DELETE, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 200:
		Network.server.send_to(peer_id, packet_id, [ "", Fetch.format_errors(response_data)])
		return

	Network.server.send_to(peer_id, packet_id, ["Sucesso ao apagar o personagem!", []])
