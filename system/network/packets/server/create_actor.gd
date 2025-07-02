class_name ServerCreateActorPacket
extends RefCounted


var packet_id: int = Packets.CREATE_ACTOR


func handle(name: String, scene: SceneTree, peer_id: int) -> void:
    print("Name: ", name)
