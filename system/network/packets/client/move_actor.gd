class_name ClientMoveActorPacket
extends RefCounted


var packet_id: int = Packets.MOVE_ACTOR


func handle(success: Dictionary, error: Array, scene: SceneTree) -> void:
	if not error.is_empty():
		Notification.show(error)
		return
	
	var new_position = success["position"]
	
	var game: Node2D = scene.root.get_node("Client/Game")
	var map: Map = game.get_node("Map")
	
	var actor: Actor = map.actors[ClientGlobals.peer_id]
	if actor:
		actor.global_position = new_position
