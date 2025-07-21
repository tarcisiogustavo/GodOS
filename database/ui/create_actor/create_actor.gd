class_name CreateActorUI
extends PanelContainer


@export_group("Edits")
@export var _name: LineEdit
@export_group("Textures")
@export var _sprite: TextureRect
@export_group("Buttons")
@export var _previous: Button
@export var _next: Button
@export var _back: Button
@export var _new: Button
@export_group("Sprites")
@export var _sprites: Array[CompressedTexture2D]
@export_group("References")
@export var _actor_list_ui: ActorListUI


var _current_sprite: int
var _selected_sprite: String = ""


func _ready() -> void:
	if not _sprites.is_empty():
		_current_sprite = 0
		_update_sprite_display()


func _on_previous_button_pressed() -> void:
	if _sprites.is_empty():
		return

	_current_sprite = (_current_sprite - 1 + _sprites.size()) % _sprites.size()
	_update_sprite_display()


func _on_next_button_pressed() -> void:
	if _sprites.is_empty():
		return

	if _sprites.is_empty():
		return

	_current_sprite = (_current_sprite + 1) % _sprites.size()
	_update_sprite_display()


func _update_sprite_display() -> void:
	var texture := _sprites[_current_sprite]

	var atlas: AtlasTexture
	atlas = _sprite.texture.duplicate() as AtlasTexture
	atlas.atlas = texture

	_sprite.texture = atlas

	var path := texture.resource_path
	_selected_sprite = path.get_file()


func _on_back_button_pressed() -> void:
	_actor_list_ui.show()
	hide()


func _on_new_button_pressed() -> void:
	var actor_name: String = _name.text
	if actor_name.length() <= 3:
		Notification.show(["O nome precisa ter ao menos 4 caracteres."])
		return

	_name.editable = false
	_previous.disabled = true
	_next.disabled = true
	_back.disabled = true
	_new.disabled = true

	Client.send(Packets.CREATE_ACTOR, [actor_name, _selected_sprite])


func _reset() -> void:
	_name.clear()
	_name.editable = true

	_previous.disabled = false
	_next.disabled = false
	_back.disabled = false
	_new.disabled = false
