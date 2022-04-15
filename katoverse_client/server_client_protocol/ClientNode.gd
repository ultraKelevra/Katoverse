extends Node
class_name ClientNode


var network = NetworkedMultiplayerENet.new()
var network_api = MultiplayerAPI.new()
export var port = 1910
export var ip = "127.0.0.1"


func start_client():
	network = NetworkedMultiplayerENet.new()
	network_api = MultiplayerAPI.new()
	network.create_client(ip, port)
	set_custom_multiplayer(network_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

func get_peer():
	return custom_multiplayer.get_network_unique_id()

func _process(delta):
	if get_custom_multiplayer()==null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
