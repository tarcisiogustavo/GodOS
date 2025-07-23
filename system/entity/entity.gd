class_name Entity
extends Node2D

enum AnimationState {
	STOPPED,
}

@export_group("Settings")
@export var identifier: String = ""
@export var map_position: Vector2i = Vector2i(1, 1)

@export_group("Nodes")
@export var sprite: Sprite2D
@export var animation: AnimationPlayer
@export var current_map: Map = null

@export_group("Animation")
@export var animation_prefixes := {
	"STOPPED": "stopped"
}

var current_direction: Vector2 = Vector2.ZERO
var previous_direction: Vector2 = Vector2.DOWN
var current_animation: AnimationState = AnimationState.STOPPED
var is_animation_locked: bool = false


func _process(_delta: float) -> void:
	update_animation()


func update_animation() -> void:
	if not animation or is_animation_locked:
		return

	var direction_to_use = current_direction if current_direction != Vector2.ZERO else previous_direction
	var new_animation := _get_animation_name(current_animation)

	if current_direction != Vector2.ZERO:
		previous_direction = current_direction

	if animation.current_animation != new_animation and animation.has_animation(new_animation):
		animation.play(new_animation)


func _get_animation_name(state: AnimationState) -> String:
	var direction_suffix = _get_direction_suffix()
	var key: String = AnimationState.keys()[int(state)]

	var prefix = animation_prefixes.get(key, "stopped")
	return prefix + "_" + direction_suffix


func _get_direction_suffix() -> String:
	var direction_to_use = current_direction if current_direction != Vector2.ZERO else previous_direction

	if abs(direction_to_use.x) > abs(direction_to_use.y):
		return "right" if direction_to_use.x > 0 else "left"
	else:
		return "down" if direction_to_use.y > 0 else "top"
