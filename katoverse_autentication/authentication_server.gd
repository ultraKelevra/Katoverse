extends ServerNode


func _ready():
	port = 1910
	start_server()


remote func request_authentication(peer_id, username, password):
	print("someone is trying to authenticate")
	var gateway_id = custom_multiplayer.get_rpc_sender_id()
	var result = false
	
	#TODO: USAR UNA BASE DE DATOS
	if username == "pepe" && password == "123*":
		print("accepted")
		result = true
	else :
		print("denegated")
		
	var token = authentication_utils.generate_token_for_request()
	world_servers.distribute_server_token(token)
	
	rpc_id(gateway_id, "fetch_authentication", peer_id, result, token)
	
