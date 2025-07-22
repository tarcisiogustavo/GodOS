class_name Entity
extends Node2D

@export_group("Settings")
@export var _identifier: String = ""
@export var map_position: Vector2i = Vector2i(1, 1)
@export var _controllable: bool = false
@export var move_speed: float = 150.0

@export_group("Nodes")
@export var _sprite: Sprite2D
@export var _animation: AnimationPlayer
@export var _camera: Camera2D
@export var current_map: Map = null

var is_moving: bool = false
var current_direction: Vector2 = Vector2.ZERO
var animation_state: String = "idle"


func _ready() -> void:
	if _controllable:
		_camera.enabled = true


func _process(_delta: float) -> void:
	update_animation()


func update_animation() -> void:
	if not _animation:
		return

	var new_animation: String = ""

	if is_moving:
		# Determina a direção da animação baseada no movimento
		if abs(current_direction.x) > abs(current_direction.y):
			new_animation = "walking_right" if current_direction.x > 0 else "walking_left"
		else:
			new_animation = "walking_down" if current_direction.y > 0 else "walking_top"
	else:
		if abs(current_direction.x) > abs(current_direction.y):
			new_animation = "stopped_right" if current_direction.x > 0 else "stopped_left"
		else:
			new_animation = "stopped_down" if current_direction.y > 0 else "stopped_top"

	if animation_state != new_animation and _animation.has_animation(new_animation):
		animation_state = new_animation
		_animation.play(new_animation)


func get_animation() -> AnimationPlayer:
	return _animation


func set_identifier(identifier: String) -> void:
	_identifier = identifier


func set_sprite(sprite: String) -> void:
	var texture: CompressedTexture2D = load("res://assets/graphics/entities/" + sprite)
	_sprite.texture = texture


func set_map_position(new_position: Vector2i) -> void:
	map_position = new_position


func set_map(map: Map) -> void:
	current_map = map


func set_controllable(controllable: bool) -> void:
	_controllable = controllable
	_camera.enabled = controllable


func move_to(direction: Vector2) -> void:
	if not current_map:
		return

	if not is_moving:
		var movement_direction: Vector2i = Vector2i(direction)
		var new_map_position = current_map.move_entity(self, movement_direction)

		if new_map_position != position:
			is_moving = true
			current_direction = direction

			var distance = (new_map_position - position).length()
			var duration = distance / move_speed

			var tween = create_tween()
			tween.tween_property(self, "position", new_map_position, duration)
			tween.tween_callback(func():
				is_moving = false
				current_direction = direction
			)


func handle_input() -> void:
	if is_moving:
		return

	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("walking_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("walking_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("walking_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("walking_down"):
		direction = Vector2.DOWN

	if direction != Vector2.ZERO:
		move_to(direction)
