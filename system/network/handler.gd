class_name Handler
extends RefCounted


var _packets: Dictionary[int, Object] = {}


func _init(packets: Array[Object] = []) -> void:
	for packet in packets:
		if packet.has_method("handle"):
			_packets[packet.packet_id] = packet


func handle(scene: SceneTree, packet_data: PackedByteArray, peer_id: int = -1) -> void:
	var data: Array = bytes_to_var(packet_data)

	if typeof(data) != TYPE_ARRAY or data.size() < 2:
		return

	var packet_id = data[0]
	var arguments = data[1]

	if typeof(packet_id) != TYPE_INT or typeof(arguments) != TYPE_ARRAY:
		return

	if not _packets.has(packet_id):
		return

	var packet = _packets[packet_id]
	if not packet.has_method("handle"):
		return

	arguments.append(scene)

	if peer_id != -1:
		arguments.append(peer_id)

	var expected_args = packet.get_method_argument_count("handle")
	if expected_args != arguments.size():
		return

	packet.callv("handle", arguments)
