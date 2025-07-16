class_name Map
extends Node2D


@export var spawn: Node2D


var id: int
var identifier: String

var actors: Dictionary


func add_actor(peer_id: int, actor: Actor) -> void:
	if actors.has(peer_id):
		return

	spawn.add_child(actor)
	actors[peer_id] = actor


func remove_actor(peer_id: int) -> void:
	if not actors.has(peer_id):
		return

	var actor_instance: Actor = actors[peer_id]
	actor_instance.queue_free()

	actors.erase(peer_id)


func move_actor(peer_id: int, direction: Vector2) -> Vector2:
	if not actors.has(peer_id):
		return Vector2.ZERO
	
	var actor_instance: Actor = actors[peer_id]
	var old_position = actor_instance.global_position
	
	actor_instance.move(direction)
	
	return actor_instance.global_position
