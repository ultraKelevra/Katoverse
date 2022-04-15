extends Node



var peer_wait_list = {}
var expected_tokens = []
var expecting_players = []



func _ready():
	var check_timer = Timer.new()
	add_child(check_timer)
	check_timer.start(1)
	check_timer.connect("timeout", self, "token_expiration_check")
	check_timer.connect("timeout", self, "peer_expiration_check")
	check_timer.connect("timeout", self, "waiting_expiration_check")


func append_peer_to_wait_list(peer_id):
	expecting_players.append(peer_id)


func verify_peer(peer_id, token):
	print(expected_tokens)
	if expected_tokens.has(token):
		expected_tokens.erase(token)
		WorldServer.authorize_peer(peer_id)
		print("peer: " + str(peer_id) +"'s token has already arrived and it's login is accepted")
		
	else:
		peer_wait_list[peer_id] = OS.get_unix_time()
		print("peer: " + str(peer_id) +"'s token haven't arrived yet, going to the wait list")


func verify_token(token):
	for i in peer_wait_list:
		var peer_token = peer_wait_list[i]
		if(peer_token == token):
			WorldServer.authorize_peer(i)
			peer_wait_list.erase(i)
			print("token: " + str(token) +"'s peer has already been confirmed and it's login is accepted")
			return
	expected_tokens.append(token)
	print("token arrived but no suitable peer has connected yet. Going to the wait list")


func token_expiration_check():
	var time = OS.get_unix_time()
	for i in range(expected_tokens.size() - 1, -1, -1):
		var token_time = int(expected_tokens[i].right(64))
		if(time - token_time > 30):
			print("token: " + str(expected_tokens[i]) + " has passed 30 seconds expecting for suitable peer\nrtoken erased")
			expected_tokens.remove(i)


func waiting_expiration_check():
	for i in range(expecting_players.size() - 1, -1, -1):
		WorldServer.request_peer_token(expecting_players[i])
		print("checking peer: " + str(expecting_players[i]))
		expecting_players.remove(i)


func peer_expiration_check():
	var time = OS.get_unix_time()
	for i in peer_wait_list:
		var peer_time = peer_wait_list[i]
		if(time - peer_time > 30):
			peer_wait_list.erase(i)
			WorldServer.deny_peer(i)
			print("peer: " + str(i) + " has passed 30 seconds expecting for token\nlogin denied")
