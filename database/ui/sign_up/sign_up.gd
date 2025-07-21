class_name SignUpUI
extends PanelContainer


@export_group("Edits")
@export var _email: LineEdit
@export var _password: LineEdit
@export var _re_password: LineEdit
@export_group("Buttons")
@export var _back: Button
@export var _sign_up: Button
@export_group("References")
@export var _sign_in_ui: SignInUI


func _on_sign_up_button_pressed() -> void:
	var email: String = _email.text
	if email.length() <= ClientConstants.min_email_length:
		Notification.show(["O email precisa ter ao menos 6 caracteres."])
		return

	var password: String = _password.text
	if password.length() < ClientConstants.min_password_length:
		Notification.show(["A senha precisa ter ao menos 3 caracteres."])
		return

	var re_password: String = _re_password.text
	if re_password.length() < ClientConstants.min_password_length:
		Notification.show(["A repetiçãs da sßæßenha precisa ter ao menos 3 caracteres."])
		return

	var version: Vector3 = ClientConstants.version

	_email.editable = false
	_password.editable = false
	_re_password.editable = false
	_sign_up.disabled = true
	_back.disabled = true

	Client.send(Packets.SIGN_UP, [email, password, version])


func _on_back_button_pressed() -> void:
	_sign_in_ui.show()
	hide()


func reset() -> void:
	_email.clear()
	_email.editable = true

	_password.clear()
	_password.editable = true

	_sign_up.disabled = false
	_back.disabled = false
