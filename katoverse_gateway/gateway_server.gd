extends ServerNode


func _ready():
	port = 1911
	start_server()

remote func request_login(username, password):
	print("someone is trying to login!")
	var peer_id = custom_multiplayer.get_rpc_sender_id()
	authentication.request_authentication(peer_id, username, password)


func fetch_login(peer_id, result, token):
	print("returning login")
	rpc_id(peer_id, "fetch_login", result, token)
	network.disconnect_peer(peer_id)
