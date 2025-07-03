class_name ServerActorListPacket
extends RefCounted


var packet_id: int = Packets.ACTOR_LIST


func handle(scene: SceneTree, peer_id: int) -> void:
	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Network.server.send_to(peer_id, packet_id, [0, [], ["Não foi possível te localizar no servidor!"]])
		return

	var max_actors: int = user["maxActors"]

	var endpoint = ServerConstants.backend_endpoint + "actor/account/" + str(int(user["id"]))
	var headers := {"Content-Type": "application/json"}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_GET, endpoint, {}, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 200:
		Network.server.send_to(peer_id, packet_id, [0, [], Fetch.format_errors(response_data)])
		return

	var actors: Array = []
	for actor in response_data:
		actors.append({
			"id": actor["id"],
			"name": actor["name"],
			"direction": Vector2(actor["directionX"], actor["directionY"]),
			"position": Vector2(actor["positionX"], actor["positionY"]),
			"mapId": actor["mapId"],
		})

	Network.server.send_to(peer_id, packet_id, [max_actors, actors, []]);
