class_name Server
extends RefCounted


signal accepted_connection(peer_id: int)
signal connection_finished(peer_id: int)
signal packet_received(connection_id: int, packet_data: PackedByteArray)


var _socket: ENetConnection


func start() -> void:
	const max_peers: int = ServerConstants.max_peers

	ServerGlobals.connections.resize(max_peers)

	for i: int in range(max_peers):
		ServerGlobals.connections[i] = {}

	_socket = ENetConnection.new()

	const host: String = ServerConstants.host
	const port: int = ServerConstants.port
	const version: Vector3 = ServerConstants.version

	var error: Error = _socket.create_host_bound(host, port, max_peers)
	if error != OK:
		return


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


func _add_peer(peer: ENetPacketPeer) -> int:
	var index: int = ServerGlobals.connections.find({})
	if index == -1 : return -1

	ServerGlobals.connections[index] = {
		"id": index,
		"peer": peer,
	}

	return index


func _remove_peer(peer_id: int) -> void:
	if peer_id >= 0 and peer_id < ServerGlobals.connections.size():
		ServerGlobals.connections[peer_id] = {}


func _on_connected(peer: ENetPacketPeer) -> void:
	var peer_id: int = _add_peer(peer)
	if peer_id == -1:
		return

	accepted_connection.emit()


func _find_id(peer: ENetPacketPeer) -> Dictionary:
	for i: Dictionary in ServerGlobals.connections:
		if i.get("peer") == peer:
			return i

	return {}


func _on_disconnected(_peer: ENetPacketPeer) -> void:
	pass


func _on_packet_received(peer: ENetPacketPeer) -> void:
	pass
