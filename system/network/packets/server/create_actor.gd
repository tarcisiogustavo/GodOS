class_name ServerCreateActorPacket
extends RefCounted


var packet_id: int = Packets.CREATE_ACTOR


func handle(actor_name: String, actor_sprite: String, _scene: SceneTree, peer_id: int) -> void:
	if actor_name.length() < ServerConstants.min_actor_name_length:
		Server.send_to(peer_id, packet_id, ["", ["O nome precisa ter ao menos 4 caracteres."]])
		return

	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Server.send_to(peer_id, packet_id, ["", ["Não foi possível te localizar no servidor!"]])
		return

	var account_id: int = user.get("id", null)
	if account_id == null:
		Server.send_to(peer_id, packet_id, ["", ["Não foi possível obter os dados da sua conta!"]])
		return

	var endpoint = ServerConstants.backend_endpoint + "actor"
	var headers := {"Content-Type": "application/json"}
	var body := {
		"accountId": account_id,
		"name": actor_name,
		"sprite": actor_sprite,
		"mapId": 1,
		"positionX": 2,
		"positionY": 2
	}

	var result := await Fetch.fetch_json(HTTPClient.METHOD_POST, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 201:
		Server.send_to(peer_id, packet_id, ["", Fetch.format_errors(response_data)])
		return

	var actors: Array = user.get("actors", null)
	if actors == null:
		Server.send_to(peer_id, packet_id, ["", ["Aconteceu um erro ao tentar obter a lista de personagens!"]])
		return

	user["actors"].append(response_data)
	Server.send_to(peer_id, packet_id, ["Sucesso ao criar o personagem!", []])
