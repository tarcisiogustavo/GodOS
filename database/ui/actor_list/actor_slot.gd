class_name ActorSlotUI
extends PanelContainer


@export_group("Labels")
@export var _name: Label
@export_group("Textures")
@export var _sprite: TextureRect

var _data: Dictionary = {}


func update_data(data: Dictionary) -> void:
	_data = data
	_name.text = data["name"]
	_update_sprite(data["sprite"])


func _on_access_button_pressed() -> void:
	pass


func _on_delete_button_pressed() -> void:
	Client.send(Packets.DELETE_ACTOR, [int(_data["id"])])


func _update_sprite(sprite_filename: String) -> void:
	var texture := load("res://assets/graphics/entities/" + sprite_filename) as CompressedTexture2D

	var original := _sprite.texture as AtlasTexture
	var atlas_texture := AtlasTexture.new()

	atlas_texture.region = original.region
	atlas_texture.margin = original.margin
	atlas_texture.filter_clip = original.filter_clip

	atlas_texture.atlas = texture
	_sprite.texture = atlas_texture
