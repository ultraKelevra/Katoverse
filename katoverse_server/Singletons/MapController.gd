extends Node


var processing_players = {}
var players = {}
onready var player_prefab = preload("res://Navigation/Player.tscn")
onready var map_navigation = get_node("/root/ServerSimulation/World/Navigation")
onready var map_state = {
	"timestamp": 0,
	"entities": players
}

var debug_line : ImmediateGeometry
var spawn_position = Vector3(1, 1.5,-2.75)


func _process(delta):
	map_state["timestamp"] = Time.time
	for id in processing_players:
		var player = processing_players[id]
		var node = player["node"]
		players[id]["position"] = node.transform.origin


func move_player_to(peer_id, move_to):
	processing_players[peer_id]["node"].move_to(move_to)


func get_map_state():
	return map_state


func add_player(peer_id):
	players[peer_id] = {"position": Vector3.ZERO}
	var player_node = player_prefab.instance()

	player_node.transform.origin = spawn_position
	map_navigation.add_child(player_node)
	
	processing_players[peer_id] = {
		"node": player_node,
		}


func remove_player(peer_id):
	players.erase(peer_id)
	processing_players[peer_id]["node"].queue_free()
	processing_players.erase(peer_id)
	#erase fomr all AI references as it's cheaper do it this way
	#than asking for an existing player each time
