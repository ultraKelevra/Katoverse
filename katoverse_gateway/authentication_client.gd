extends ClientNode


func _ready():
	port = 1910
	start_client()


func request_authentication(peer_id, username, password):
	print("requesting authentication to the auth_server")
	rpc_id(1, "request_authentication", peer_id, username, password)
	
	
remote func fetch_authentication(peer_id, result, token):
	gateway.fetch_login(peer_id, result, token)
