extends Node
class_name ServerNode


var network = NetworkedMultiplayerENet.new()
var network_api = MultiplayerAPI.new()
export var port = 1910
export var max_players = 100
export var autostart = false

signal server_started(peer_id)
signal peer_connected(peer_id)
signal peer_disconnected(peer_id)


func start_server():
	network.create_server(port, max_players)
	set_custom_multiplayer(network_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("server started!")
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("connection_failed", self, "_on_peer_disconnected")


func _on_peer_connected(peer_id):
	emit_signal("peer_connected",peer_id)
	print("peer " + str(peer_id) + " connected!")


func _on_peer_disconnected(peer_id):
	emit_signal("peer_disconnected", peer_id)
	print("peer " + str(peer_id) + " disconnected!")


func _ready():
	if autostart:
		start_server()


func _process(delta):
	if get_custom_multiplayer()==null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
