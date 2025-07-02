class_name ServerSelectActorPacket
extends RefCounted


var packet_id: int = Packets.SELECT_ACTOR


func handle(actor_id: int, scene: SceneTree, peer_id: int) -> void:
	print("ActorId: ", actor_id)
