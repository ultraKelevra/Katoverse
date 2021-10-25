extends ServerNode


var player_per_server = 100
var server_list = [1]
var server_available = false


func _ready():
	port = 1912
	start_server()
	connect("peer_connected", self, "add_server_to_list")
	connect("peer_disconnected", self, "add_server_to_list")


func distribute_server_token(token):
	var peer_id = server_list[0]
	rpc_id(peer_id, "fetch_token", token)
	#TODO: load balance and such


func add_server_to_list(peer_id):
	#server_list.append(peer_id)
	server_list[0] = peer_id
	server_available = true
	print(server_list)


func remove_server_from_list(peer_id):
	server_list.delete(peer_id)
	print(server_list)
