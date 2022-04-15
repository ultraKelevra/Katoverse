extends Node


onready var player_prefab = preload("res://PlayerScenes/character_playable.tscn")
onready var map_node = $"/root/Game/World/Players"
onready var map = get_node("/root/Game/World/Players")

var player_instance
var initialized = false



func _ready():
	LoginProtocol.connect("login_successful", self, "on_login")


func _physics_process(delta):
	if initialized:
		var player_state = {"t": Time.time, "p": player_instance.transform.origin}
		WorldClient.update_player_state(player_state) 


func on_login():
	create_player()
	initialized = true


func create_player():
	player_instance = player_prefab.instance()
	player_instance.transform.origin = Vector3.ZERO
	player_instance.name = "current_player" + str(WorldClient.get_peer())
	map_node.add_child(player_instance)
