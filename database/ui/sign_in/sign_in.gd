class_name SignInUI
extends PanelContainer


@export_group("Edits")
@export var _email: LineEdit
@export var _password: LineEdit
@export_group("Buttons")
@export var _sign_up: Button
@export var _sign_in: Button
@export_group("References")
@export var _sign_up_ui: SignUpUI


func _on_sign_in_button_pressed() -> void:
	var email: String = _email.text
	if email.length() <= ClientConstants.min_email_length:
		Notification.show(["O email precisa ter ao menos 6 caracteres."])
		return

	var password: String = _password.text
	if password.length() < ClientConstants.min_password_length:
		Notification.show(["A senha precisa ter ao menos 3 caracteres."])
		return

	var version: Vector3 = ClientConstants.version

	_email.editable = false
	_password.editable = false
	_sign_up.disabled = true
	_sign_in.disabled = true

	Client.send(Packets.SIGN_IN, [email, password, version])


func _on_sign_up_button_pressed() -> void:
	_sign_up_ui.show()
	hide()


func _reset_state() -> void:
	_email.clear()
	_email.editable = true

	_password.clear()
	_password.editable = true

	_sign_up.disabled = false
	_sign_in.disabled = false
