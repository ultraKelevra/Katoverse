extends Node


onready var player_prefab = preload("res://Player/Player.tscn")
onready var map = get_node("/root/ServerSimulation/World/Players")
onready var map_state = {
	"t": Time.time,
	"entities": {}
}
var players_states = {}
var spawn_position = Vector3(0, 1.5, 0)



func _ready():
	pass


func _physics_process(delta):
	map_state["t"] = Time.time
	for id in players_states:
		var player_state = players_states[id]
		map_state["entities"][id]["p"] = player_state["p"]
		#for physics later
		player_state["node"].transform.origin = player_state["p"]


func update_player_state(peer_id, state):
	if players_states.has(peer_id):
		if players_states[peer_id]["t"] > state["t"]:
			print("had to return on update because of timestamp being wrong")
			return
	else:
		print("a new player is asking to update. Adding " + str(peer_id) + " to the world")
		add_player(peer_id)
		
	update_player(peer_id, state)


func get_map_state():
	return map_state


func add_player(peer_id):
	var player_node = player_prefab.instance()
	player_node.transform.origin = spawn_position
	map.add_child(player_node)
	
	players_states[peer_id] = {
		"node": player_node,
		"p": spawn_position,
		"t": Time.time
	}
	
	map_state["entities"][peer_id] = {
		"p": spawn_position
	}


func update_player(peer_id, state):
	players_states[peer_id]["t"] = state["t"]
	players_states[peer_id]["p"] = state["p"]


func remove_player(peer_id):
	map_state["entities"].erase(peer_id)
	players_states[peer_id]["node"].queue_free()
	players_states.erase(peer_id)
