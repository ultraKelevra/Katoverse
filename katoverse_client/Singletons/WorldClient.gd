extends ClientNode


#player_state__________________________________________________________________
func update_player_state(state):
	rpc_unreliable_id(1, "update_player_state", state)


#from_server___________________________________________________________________
remote func update_map_state(map_state):
	MapController.update_map(map_state)


#synchronization---------------------------------------------------------------
func request_server_time():
	rpc_id(1, "request_server_time", Time.time)

remote func fetch_server_time(server_time, client_time):
	ServerTime.update_server_time(server_time, client_time)


#authentication----------------------------------------------------------------
var authentication_token

signal server_login_succesful()
signal server_login_failed()


func _ready():
	port = 1913


func connect_to_server(token):
	authentication_token = token
	start_client()


remote func token_request():
	print("server asking for token")
	rpc_id(1, "fetch_token",authentication_token)


remote func verification_result(result):
	if result:
		emit_signal("server_login_succesful")
	else:
		emit_signal("server_login_failed")
