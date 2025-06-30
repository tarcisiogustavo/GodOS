class_name Client
extends RefCounted


signal connected()
signal disconnected()
signal packet_received(buffer: PackedByteArray)


var _socket: ENetConnection
var _peer: ENetPacketPeer


func _is_connected() -> bool:
	return _socket != null and _peer != null and _peer.get_state() == ENetPacketPeer.STATE_CONNECTED


func connect_to_server() -> void:
	if _is_connected():
		return
	
	_socket = ENetConnection.new()
	
	var error: Error = _socket.create_host()
	if error != OK: return
	
	_peer = _socket.connect_to_host(ClientConstants.host, ClientConstants.port)


func process() -> void:
	if _socket == null : return

	var event: Array = _socket.service()
	if event.size() == 0 : return

	match event[0]:
		ENetConnection.EventType.EVENT_ERROR:
			return

		ENetConnection.EventType.EVENT_CONNECT:
			_on_connected(event[1])

		ENetConnection.EventType.EVENT_DISCONNECT:
			_on_disconnected(event[1])

		ENetConnection.EventType.EVENT_RECEIVE:
			_on_packet_received(event[1])


func _on_connected(_peer: ENetPacketPeer) -> void:
	connected.emit()


func _on_disconnected(_peer: ENetPacketPeer) -> void:
	disconnected.emit()


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
