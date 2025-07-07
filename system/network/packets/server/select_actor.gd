class_name ServerSelectActorPacket
extends RefCounted


var packet_id: int = Packets.SELECT_ACTOR


func handle(actor_id: int, scene: SceneTree, peer_id: int) -> void:
	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Network.server.send_to(peer_id, packet_id, [{}, ["Não foi possível te localizar no servidor!"]])
		return

	if peer_id in ServerGlobals.actors:
		Network.server.send_to(peer_id, packet_id, [{}, ["Esse personagem já está sendo utilizado!"]])

	var endpoint = ServerConstants.backend_endpoint + "actor/" + str(actor_id)
	var headers := {"Content-Type": "application/json"}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_GET, endpoint, {}, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 200:
		Network.server.send_to(peer_id, packet_id, [{}, Fetch.format_errors(response_data)])
		return

	var actor_data: Dictionary = {
		"id": response_data["id"],
		"name": response_data["name"],
		"direction": Vector2(response_data["directionX"], response_data["directionY"]),
		"map": response_data["mapId"],
		"position": Vector2(response_data["positionX"], response_data["positionY"]),
	}

	const actor: PackedScene = preload("res://database/entities/actor/actor.tscn")
	var actor_instance: Actor = actor.instantiate()
	actor_instance.id = actor_data["id"]
	actor_instance.identifier = actor_data["name"]
	actor_instance.direction = actor_data["direction"]
	#actor_instance.map = actor_data["map"]
	actor_instance.position = actor_data["position"]
	actor_instance.camera.queue_free()
	actor_instance.controller.queue_free()

	# Adicionar no mundo (LÓGICA TEMPORÁRIA)
	var game: Map = scene.root.get_node("Server/Game/Map")
	game.add_actor(actor_instance)

	ServerGlobals.actors[peer_id] = actor_instance

	Network.server.send_to(peer_id, packet_id, [actor_data, []])
