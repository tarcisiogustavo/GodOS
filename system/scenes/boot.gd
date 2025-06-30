class_name BootScene
extends Control

@export var _client_scene: PackedScene
@export var _server_scene: PackedScene

@export var _client_button: Button
@export var _server_button: Button


func _init() -> void:
  _client_scene = preload("res://system/scenes/client.tscn")
  _server_scene = preload("res://system/scenes/server.tscn")


func _ready() -> void:
  _client_button.pressed.connect(_on_client_button_pressed)

  _server_button.pressed.connect(_on_server_button_pressed)


func _on_client_button_pressed() -> void:
  var scene: Control = _client_scene.instantiate()
  scene.name = "client"

  get_tree().root.add_child(scene)
  queue_free()


func _on_server_button_pressed() -> void:
  var scene: Control = _server_scene.instantiate()
  scene.name = "server"

  get_tree().root.add_child(scene)
  queue_free()
