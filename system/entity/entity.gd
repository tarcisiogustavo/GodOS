class_name Entity
extends CharacterBody2D


@export var sprite: Sprite2D
@export var animation: AnimationPlayer
@export var states: StateMachine


@export var identifier: String
@export var move_speed: int = 100


var direction: Vector2 = Vector2.DOWN
var last_direction: Vector2
var last_velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	move_and_slide()


func move(new_direction: Vector2, speed_bonus: int = 0) -> void:
	direction = new_direction.normalized()
	var entity_velocity = new_direction.normalized() * (move_speed + speed_bonus)
	velocity = entity_velocity
