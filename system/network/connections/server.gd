class_name Server
extends RefCounted


signal peer_connected(peer_id: int)
signal peer_disconnected(peer_id: int)
signal packet_received(peer_id: int, packet_data: PackedByteArray)


var _server_connection: ENetConnection


func start() -> void:
	const max_peers: int = ServerConstants.max_peers

	ServerGlobals.connections.resize(max_peers)

	for i: int in range(max_peers):
		ServerGlobals.connections[i] = {}

	_server_connection = ENetConnection.new()

	const host: String = ServerConstants.host
	const port: int = ServerConstants.port

	var error: Error = _server_connection.create_host_bound(host, port, max_peers)
	if error != OK:
		return


func update() -> void:
	if _server_connection == null: return

	var event: Array = _server_connection.service()
	if event.size() == 0: return

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
	if index == -1: return -1

	ServerGlobals.connections[index] = {
		"id": index,
		"peer": peer,
	}

	return index


func _remove_peer(peer_id: int) -> void:
	if peer_id >= 0 and peer_id < ServerGlobals.connections.size():
		ServerGlobals.connections[peer_id] = {}


func _find_connection(peer: ENetPacketPeer) -> Dictionary:
	for connection: Dictionary in ServerGlobals.connections:
		if connection.has("peer") and connection["peer"] == peer:
			return connection

	return {}


func disconnect_peer(peer_id: int) -> void:
	if peer_id < 0 or peer_id >= ServerGlobals.connections.size():
		return
	
	var connection: Dictionary = ServerGlobals.connections[peer_id]
	if connection.is_empty(): return
	if not connection.has("peer"): return
	
	var peer: ENetPacketPeer = connection["peer"]
	peer.peer_disconnect_later()
	
	_remove_peer(peer_id)
	peer_disconnected.emit(peer_id)


func _on_connected(peer: ENetPacketPeer) -> void:
	var peer_id: int = _add_peer(peer)
	if peer_id == -1: return

	peer_connected.emit(peer_id)


func _on_disconnected(peer: ENetPacketPeer) -> void:
	var connection: Dictionary = _find_connection(peer)
	var id: int = connection.get("id", -1)
	if id == -1:
		return
	
	_remove_peer(id)
	peer_disconnected.emit(id)


func _on_packet_received(peer: ENetPacketPeer) -> void:
	var connection: Dictionary = _find_connection(peer)
	var id: int = connection.get("id", -1)
	if id == -1:
		return

	var packet_data: PackedByteArray = peer.get_packet()
	if packet_data.size() > 0:
			packet_received.emit(id, packet_data)


func send_to(peer_id: int, packet_id: int, packet_data := [], channel: int = 0) -> void:
	if peer_id < 0 or peer_id >= ServerGlobals.connections.size():
		return
	
	var connection: Dictionary = ServerGlobals.connections[peer_id]
	if connection.is_empty():
		return
	
	if not connection.has("peer"):
		return
	
	var peer: ENetPacketPeer = connection["peer"]
	peer.send(channel, var_to_bytes([packet_id, packet_data]), ENetPacketPeer.FLAG_RELIABLE)


func send_to_many(peer_ids: Array[int], packet_id: int, packet_data := [], channel: int = 0) -> void:
	for peer_id: int in peer_ids:
		send_to(peer_id, packet_id, packet_data, channel)
