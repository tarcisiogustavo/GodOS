extends Node


var client: Client
var server: Server


func _init() -> void:
  client = Client.new()
  server = Server.new()