class_name Entity
extends Node2D

signal movement_finished

enum AnimationState {
	STOPPED,
	WALKING,
	ATTACKING
}

@export_group("Settings")
@export var identifier: String = ""
@export var map_position: Vector2i = Vector2i(1, 1)
@export var controllable: bool = false
@export var move_speed: float = 150.0

@export_group("Nodes")
@export var sprite: Sprite2D
@export var animation: AnimationPlayer
@export var current_map: Map = null

var is_moving: bool = false
var current_direction: Vector2 = Vector2.ZERO
var current_animation: AnimationState = AnimationState.STOPPED
var previous_direction: Vector2 = Vector2.DOWN
var is_animation_locked: bool = false
var current_tween: Tween


func _process(delta: float) -> void:
	update_animation()


func update_animation() -> void:
	if not animation or is_animation_locked:
		return

	var new_state: AnimationState
	var direction_to_use = current_direction if current_direction != Vector2.ZERO else previous_direction

	if is_moving:
		new_state = AnimationState.WALKING
	else:
		new_state = AnimationState.STOPPED

	var new_animation := _get_animation_name(new_state)

	var should_change = false

	if current_animation != new_state:
		current_animation = new_state
		should_change = true
	elif is_moving and direction_to_use != previous_direction:
		should_change = true
	elif animation.current_animation != new_animation:
		should_change = true

	if current_direction != Vector2.ZERO:
		previous_direction = current_direction

	if should_change and animation.has_animation(new_animation):
		animation.play(new_animation)


func _get_animation_name(state: AnimationState) -> String:
	var direction_suffix = _get_direction_suffix()

	match state:
		AnimationState.STOPPED:
			return "stopped_" + direction_suffix
		AnimationState.WALKING:
			return "walking_" + direction_suffix
		_:
			return "stopped_" + direction_suffix  # ATTACKING e outros ignorados na base


func _get_direction_suffix() -> String:
	var direction_to_use = current_direction if current_direction != Vector2.ZERO else previous_direction

	if abs(direction_to_use.x) > abs(direction_to_use.y):
		return "right" if direction_to_use.x > 0 else "left"
	else:
		return "down" if direction_to_use.y > 0 else "top"


func move_to(direction: Vector2) -> void:
	if not current_map or is_animation_locked:
		return

	if not is_moving:
		var movement_direction: Vector2i = Vector2i(direction)
		var new_map_position = current_map.move_entity(self, movement_direction)

		if new_map_position != position:
			is_moving = true
			current_direction = direction
			previous_direction = direction

			var distance = (new_map_position - position).length()
			var duration = distance / move_speed

			current_tween = create_tween()
			current_tween.tween_property(self, "position", new_map_position, duration)
			current_tween.tween_callback(func():
				is_moving = false
				movement_finished.emit()
			)


func _stop_movement() -> void:
	is_moving = false

	if current_tween:
		current_tween.kill()
		current_tween = null
