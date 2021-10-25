extends ClientNode


func move_player_to(position : Vector3):
	rpc_id(1, "move_player_to", position)


func move_ring_to(position : Vector3):
	rpc_id(1, "move_ring_to", position)


remote func update_map_state(map_state):
	MapController.update_map(map_state)
#synchronization---------------------------------------------------------------
func request_server_time():
	rpc_id(1, "request_server_time", OS.get_system_time_msecs())
	
	
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
		print("server_login_sucessful")
	else:
		emit_signal("server_login_failed")
		print("server_login_failed")
