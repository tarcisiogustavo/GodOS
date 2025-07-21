extends Node


var socket: ClientSocket = ClientSocket.new()


func send(packet_id: int, packet_args := [], channel: int = 0) -> void:
	socket.send(packet_id, packet_args, channel)
