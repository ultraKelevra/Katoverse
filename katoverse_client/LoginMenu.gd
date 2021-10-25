extends Control


var username = "pepe"
var password = "123*"

onready var btn_login = $NinePatchRect/VBoxContainer/btn_login
onready var field_password = $NinePatchRect/VBoxContainer/field_password


func on_login_failed():
	btn_login.disabled = false


func clear_interface():
	field_password.text = ""


func try_login():
	print("trying to login")
	btn_login.disabled = true
	clear_interface()
	LoginProtocol.login(username, password)
	LoginProtocol.connect("authentication_failed", self, "display_wrong_data_error")
	LoginProtocol.connect("login_failed", self, "display_server_full_error")
	LoginProtocol.connect("login_successful", self, "hide_login_menu")
	display_login_loader()


func hide_login_menu():
	self.queue_free()


func display_login_loader():
	pass

func display_connection_lost_error():
	on_login_failed()
	pass

func display_wrong_data_error():
	on_login_failed()
	pass

func display_server_full_error():
	on_login_failed()
	pass
