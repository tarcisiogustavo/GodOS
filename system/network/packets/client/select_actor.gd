class_name ClientSelectActorPacket
extends RefCounted


var packet_id: int = Packets.SELECT_ACTOR


func handle(success: Dictionary, error: Array, scene: SceneTree) -> void:
	if not error.is_empty():
		Notification.show(error)
		return

	const actor: PackedScene = preload("res://database/entities/actor/actor.tscn")
	var actor_instance: Actor = actor.instantiate()
	actor_instance.name = str(int(ClientGlobals.peer_id))
	actor_instance.id = success["id"]
	actor_instance.identifier = success["name"]
	actor_instance.direction = success["direction"]
	#actor_instance.map = success["map"]
	actor_instance.position = success["position"]
#
	var game: Node2D = scene.root.get_node("Client/Game")
	var map: Map = game.get_node("Map")
	map.add_actor(int(ClientGlobals.peer_id), actor_instance)

	var menu_canvas: CanvasLayer = scene.root.get_node("Client/MenuCanvas")
	menu_canvas.hide()
