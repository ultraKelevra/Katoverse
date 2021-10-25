extends ClientNode

func _init():
	port = 1912
	start_client()

remote func fetch_token(auth_token):
	print("authentication token arrived")
	PeerWaitList.verify_token(auth_token)
