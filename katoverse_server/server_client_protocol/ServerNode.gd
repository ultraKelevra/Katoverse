extends Node
class_name ServerNode


var network = NetworkedMultiplayerENet.new()
var network_api = MultiplayerAPI.new()
export var port = 1910
export var max_players = 100
export var autostart = false

func get_peer():
	return custom_multiplayer.get_rpc_sender_id()

func start_server():
	network.create_server(port, max_players)
	set_custom_multiplayer(network_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)


func _ready():
	if autostart:
		start_server()


func _process(delta):
	if get_custom_multiplayer()==null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
