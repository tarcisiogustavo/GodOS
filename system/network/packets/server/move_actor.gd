class_name ServerMoveActorPacket
extends RefCounted


var packet_id: int = Packets.MOVE_ACTOR


func handle(new_direction: Vector2, scene: SceneTree, peer_id: int) -> void:
	var actor: Actor = ServerGlobals.actors.get(peer_id, null)
	if actor == null:
		# feedback de erro
		return

	var map: Map = scene.root.get_node("Server/Game/Map")
	var new_position = map.move_actor(peer_id, new_direction)

	Network.server.send_to(peer_id, packet_id, [{"position": new_position}, []])
	
