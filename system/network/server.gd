extends Node


var socket: ServerSocket = ServerSocket.new()


func send_to(peer_id: int, packet_id: int, packet_data := [], channel: int = 0) -> void:
	socket.send_to(peer_id, packet_id, packet_data, channel)


func send_to_many(peer_ids: Array[int], packet_id: int, packet_data := [], channel: int = 0) -> void:
	socket.send_to_many(peer_ids, packet_id, packet_data, channel)
