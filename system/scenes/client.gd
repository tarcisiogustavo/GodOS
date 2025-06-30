class_name ClientScene
extends Control


var _client: Client
var _handler: Handler


func _init() -> void:
  _client = Network.client
  _handler = Handler.new([])


func _ready() -> void:
  _client.connect_to_server()

  _client.peer_connected.connect(_peer_connected)
  _client.peer_disconnected.connect(_peer_disconnected)
  _client.packet_received.connect(_packet_received)

  print("Cliente iniciado na porta: ", ClientConstants.port)


func _process(_delta: float) -> void:
  _client.update()


func _peer_connected() -> void:
  pass


func _peer_disconnected() -> void:
  pass

  
func _packet_received(packet_data: PackedByteArray) -> void:
  _handler.handle(get_tree(), packet_data)