class_name SignUpInterface
extends PanelContainer


@export var email_input: LineEdit
@export var password_input: LineEdit
@export var re_password_input: LineEdit
@export var back_button: Button
@export var sign_up_button: Button


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	sign_up_button.pressed.connect(_on_sign_up_button_pressed)


func _on_sign_up_button_pressed() -> void:
	var email: String = email_input.text
	var password: String = password_input.text
	var re_password: String = re_password_input.text

	if email.length() <= 6:
		Notification.show("O email precisa ter ao menos 6 caracteres.")
		return

	if password.length() < 3:
		Notification.show("A senha precisa ter ao menos 3 caracteres.")
		return

	if password != re_password:
		Notification.show("A senha informada não corresponde à confirmação.")
		return

	back_button.disabled = true
	sign_up_button.disabled = true

	Network.client.send(Packets.SIGN_UP, [email, password, ClientConstants.version])


func _on_back_button_pressed() -> void:
	ClientGlobals.menu_interface.show_interface("SignIn")
	ClientGlobals.menu_interface.hide_interface("SignUp")


func reset_buttons_state() -> void:
	back_button.disabled = false
	sign_up_button.disabled = false
