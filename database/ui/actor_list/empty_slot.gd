class_name EmptySlotActorUI
extends PanelContainer


func _on_new_button_pressed() -> void:
	var create_actor_ui: CreateActorUI = get_tree().root.get_node("Main/MenuCanvas/CreateActor")
	create_actor_ui.show()

	var actor_list_ui: ActorListUI = get_tree().root.get_node("Main/MenuCanvas/ActorList")
	actor_list_ui.hide()
