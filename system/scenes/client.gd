class_name ClientScene
extends Control


var _client: ClientSocket
var _handler: Handler


func _init() -> void:
	_client = Client.socket
	_handler = Handler.new([
		ClientSignInPacket.new(),
		ClientSignUpPacket.new(),
		ClientActorListPacket.new(),
		ClientDeleteActorPacket.new(),
		ClientCreateActorPacket.new(),
	])


func _ready() -> void:
	_client.connect_to_server()
	print("Cliente iniciado na porta: ", ClientConstants.port)

	_client.peer_connected.connect(_peer_connected)
	_client.peer_disconnected.connect(_peer_disconnected)
	_client.packet_received.connect(_packet_received)


func _process(_delta: float) -> void:
	_client.update()


func _peer_connected() -> void:
	print("Conectado ao servidor.")


func _peer_disconnected() -> void:
	print("Desconectado do servidor.")


func _packet_received(packet_data: PackedByteArray) -> void:
	_handler.handle(get_tree(), packet_data)
