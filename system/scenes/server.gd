class_name ServerScene
extends Control


var _server: Server
var _handler: Handler


func _init() -> void:
	_server = Network.server
	_handler = Handler.new([
		ServerSignInPacket.new(),
		ServerSignUpPacket.new(),
		ServerCreateActorPacket.new(),
		ServerDeleteActorPacket.new(),
		ServerSelectActorPacket.new(),
	])


func _ready() -> void:
	_server.start()

	_server.peer_connected.connect(_peer_connected)
	_server.peer_disconnected.connect(_peer_disconnected)
	_server.packet_received.connect(_packet_received)

	print("Servidor iniciado na porta: ", ServerConstants.port)


func _process(_delta: float) -> void:
	_server.update()


func _peer_connected(peer_id: int) -> void:
	print("Cliente conectado: ", str(peer_id))


func _peer_disconnected(peer_id: int) -> void:
	print("Cliente desconectado: ", str(peer_id))


func _packet_received(peer_id: int, packet_data: PackedByteArray) -> void:
	_handler.handle(get_tree(), packet_data, peer_id)
