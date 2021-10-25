extends Node


func login(username, password):
	print("trying to login")
	GatewayClient.try_login(username, password)
	GatewayClient.connect("login_succeeded", self, "on_authentication_succesful")
	GatewayClient.connect("login_failed", self, "on_login_failed")


signal authentication_successful()
signal authentication_failed()
signal login_successful()
signal login_failed()


func on_authentication_succesful(token):
	print("authentication correct!")
	emit_signal("authentication_successful")
	WorldClient.connect_to_server(token)
	WorldClient.connect("server_login_succesful", self, "on_server_login_succesful")
	WorldClient.connect("server_login_failed", self, "on_server_login_failed")
	

func on_authentication_failed():
	print("authentication failed!")
	
	emit_signal("authentication_failed")


func on_server_login_succesful():
	print("server login correct!")
	
	emit_signal("login_successful")
	

func on_server_login_failed():
	emit_signal("login_failed")
	
