class_name ServerActorListPacket
extends RefCounted


var packet_id: int = Packets.ACTOR_LIST


func handle(_scene: SceneTree, peer_id: int) -> void:
	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Server.send_to(peer_id, packet_id, [-1, [], ["Não foi possível te localizar no servidor!"]])
		return

	var max_actors: int = user.get("maxActors", null)
	if max_actors == null:
		Server.send_to(peer_id, packet_id, [-1, [], ["Aconteceu um erro ao tentar obter o número máximo de personagens!"]])
		return

	var actors: Array = user.get("actors", null)
	if actors == null:
		Server.send_to(peer_id, packet_id, [-1, [], ["Aconteceu um erro ao tentar obter a lista de personagens!"]])
		return
	Server.send_to(peer_id, packet_id, [max_actors, actors, []])
