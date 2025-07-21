class_name ServerActorListPacket
extends RefCounted


var packet_id: int = Packets.ACTOR_LIST


func handle(_scene: SceneTree, peer_id: int) -> void:
	var user: Dictionary = ServerGlobals.users.get(peer_id, null)
	if user == null:
		Server.send_to(peer_id, packet_id, [[], ["Não foi possível te localizar no servidor!"]])
		return

	var max_actors: int = user.get("maxActors", 3)
	var actors: Array = user.get("actors", [])
	Server.send_to(peer_id, packet_id, [max_actors, actors, []])
