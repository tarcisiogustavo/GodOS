class_name ServerMoveActorPacket
extends RefCounted


var packet_id: int = Packets.MOVE_ACTOR


func handle(actor_id: int, new_direction: Vector2, new_position: Vector2, scene: SceneTree, peer_id: int) -> void:
	var actor: Actor = ServerGlobals.actors.get(peer_id, null)
	if actor == null:
		Network.server.send_to(peer_id, packet_id, [{}, "Não foi possível te localizar no servidor!"])
		return

	var map: Map = scene.root.get_node("Server/Game/Map")
	map.move_actor(actor_id, new_direction, new_position)


	#Network.server.send_to(peer_id, packet_id, [{"dicrection": new_direction}, []])
