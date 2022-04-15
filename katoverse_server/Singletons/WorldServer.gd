extends ServerNode



#communication_interface-------------------------------------------------------
remote func update_player_state(state):
	MapController.update_player_state(get_peer(), state)


#server_time-------------------------------------------------------------------
remote func request_server_time(client_time):
	rpc_id(get_peer(), "fetch_server_time", Time.time, client_time)


#update world state------------------------------------------------------------
func updateWorld():
	rpc_unreliable("update_map_state", MapController.get_map_state())


#player_authentication---------------------------------------------------------
func request_peer_token(peer_id):
	rpc_id(peer_id, "token_request")


remote func fetch_token(token):
	var peer_id = get_peer()
	PeerWaitList.verify_peer(peer_id, token)


func authorize_peer(peer_id):
	rpc_id(peer_id, "verification_result", true)


func deny_peer(peer_id):
	rpc_id(peer_id, "verification_result", false)


func _ready():
	port = 1913
	start_server()
	network.connect("peer_connected", PeerWaitList, "append_peer_to_wait_list")
	
	#make a timer for sending the world state to all players, 8 times per second
	var map_update_timer = Timer.new()
	add_child(map_update_timer)
	map_update_timer.start(1/8.0)
	map_update_timer.connect("timeout", self, "updateWorld")
