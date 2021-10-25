extends ClientNode


export var _username = ""
export var _password = ""


func _ready():
	port = 1911


func request_login():
	print("requesting_login")
	rpc_id(1, "request_login", _username, _password)
	_username = ""
	_password = ""


remote func fetch_login(result, token):
	if not result:
		emit_signal("login_failed")
		print("login_failed")
		return
	
	emit_signal("login_succeeded", token)
	print("login_succeeded")
	print("arrived positive login with token: " + str(token))


func try_login(username, password):
	_username = username
	_password = password
	print("trying loging")
	start_client()
	network.connect("connection_succeeded", self, "request_login")


signal login_succeeded(token)
signal login_failed()
