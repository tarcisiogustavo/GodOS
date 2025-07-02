class_name Client
extends RefCounted


signal peer_connected()
signal peer_disconnected()
signal packet_received(packet_data: PackedByteArray)


var _client_connection: ENetConnection
var _peer: ENetPacketPeer


func _is_connected() -> bool:
	return _client_connection != null and _peer != null and _peer.get_state() == ENetPacketPeer.STATE_CONNECTED


func connect_to_server() -> void:
	if _is_connected():
		return

	_client_connection = ENetConnection.new()

	var error: Error = _client_connection.create_host()
	if error != OK: return

	const host: String = ClientConstants.host
	const port: int = ClientConstants.port

	_peer = _client_connection.connect_to_host(host, port)


func update() -> void:
	if _client_connection == null: return

	var event: Array = _client_connection.service()
	if event.size() == 0: return

	match event[0]:
		ENetConnection.EventType.EVENT_ERROR:
			return

		ENetConnection.EventType.EVENT_CONNECT:
			_on_connected()

		ENetConnection.EventType.EVENT_DISCONNECT:
			_on_disconnected()

		ENetConnection.EventType.EVENT_RECEIVE:
			_on_packet_received(event[1])


func _on_connected() -> void:
	peer_connected.emit()


func _on_disconnected() -> void:
	peer_disconnected.emit()


func _on_packet_received(peer: ENetPacketPeer) -> void:
	if peer.get_available_packet_count() == 0:
		return

	var packet = peer.get_packet()
	packet_received.emit(packet)


func send(packet_id: int, packet_args := [], channel: int = 0) -> void:
	if not _is_connected():
		return

	var peer: ENetPacketPeer = _peer
	var data: PackedByteArray = var_to_bytes([packet_id, packet_args])
	var flag: int = ENetPacketPeer.FLAG_RELIABLE

	var error: Error = peer.send(channel, data, flag)
	if error != OK:
		peer.peer_disconnect_later()
