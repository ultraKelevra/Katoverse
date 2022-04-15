extends ServerNode


var player_per_server = 100
var server_list = []
var server_available = false


func _ready():
	port = 1912
	start_server()
	connect("peer_connected", self, "add_server_to_list")
	connect("peer_disconnected", self, "remove_server_from_list")

func distribute_server_token(token):
	for i in server_list:
		var peer_id = i
		rpc_id(peer_id, "fetch_token", token)

func add_server_to_list(peer_id):
	print("new server conected, adding to list")
	server_list.append(peer_id)
	server_available = true
	print(server_list)

func remove_server_from_list(peer_id):
	print("server disconected, removing from list")
	var i = server_list.find(peer_id)
	server_list.remove(i)
	#server_list.erase(peer_id)
	#server_list.delete(peer_id)
	if server_list.size == 0:
		server_available = false;
