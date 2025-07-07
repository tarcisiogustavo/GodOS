class_name Map
extends Node2D


@export var spawn: Node2D


var id: int
var identifier: String

var actors: Dictionary


func add_actor(actor: Actor) -> void:
	if actors.has(actor.id):
		return

	spawn.add_child(actor)
	actors[actor.id] = actor


func remove_actor(actor_id: int) -> void:
	if not actors.has(actor_id):
		return

	var actor_instance: Actor = actors[actor_id]
	actor_instance.queue_free()

	actors.erase(actor_id)


func move_actor(actor_id: int, new_direction: Vector2, new_position: Vector2) -> void:
	if not actors.has(actor_id):
		return

	var actor_instance: Actor = actors[actor_id]
	actor_instance.move(new_direction)
	actor_instance.global_position = new_position
