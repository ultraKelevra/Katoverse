extends ServerNode



#communication_interface--------------------------------------------------------------------
remote func move_player_to(position):
	MapController.move_player_to(get_peer(), position)

remote func move_ring_to(position):
	MapController.move_ring(get_peer())

#server_time--------------------------------------------------------------------
remote func request_server_time(client_time):
	rpc_id(get_peer(), "fetch_server_time", Time.time, client_time)

#return world state---------------------------------------------------------------------
func updateWorld():
	rpc("update_map_state", MapController.get_map_state())

#player_authentication----------------------------------------------------------
func request_peer_token(peer_id):
	rpc_id(peer_id, "token_request")


remote func fetch_token(token):
	var peer_id = get_peer()
	PeerWaitList.verify_peer(peer_id, token)


func authorize_peer(peer_id):
	rpc_id(peer_id, "verification_result", true)
	MapController.add_player(peer_id)


func deny_peer(peer_id):
	rpc_id(peer_id, "verification_result", false)


func _ready():
	port = 1913
	start_server()
	network.connect("peer_connected", PeerWaitList, "append_peer_to_wait_list")
	
	var map_update_timer = Timer.new()
	add_child(map_update_timer)
	map_update_timer.start(1/8.0)
	map_update_timer.connect("timeout", self, "updateWorld")
	
