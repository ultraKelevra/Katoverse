extends Node

var map_timer : Timer
var server_timestamp = 0
var map_entities = {}
var map_state_buffer = [1]

#the map render will use a 100 ms delay
var render_time_backtrack = 200

onready var player = preload("res://PlayerScenes/character_playable.tscn")
onready var token_player = preload("res://PlayerScenes/character_player_token.tscn")
onready var map_node = $"/root/Game/World/Players"



func update_map(map_state):
	map_state["entities"].erase(WorldClient.get_peer())
	map_state_buffer.append(map_state)
	map_state_buffer[0] = map_state
	var state_entities = map_state["entities"]
	for entity in state_entities:
		if !map_entities.has(entity):
			create_entity(state_entities[entity], entity)
	for client_entity in map_entities:
		if !state_entities.has(client_entity):
			remove_entity(client_entity)
	
	for id in map_entities:
		update_entity_state(id, state_entities[id])


func update_entity_state(id, state):
	var entity = map_entities[id]
	var node = entity["node"]
	var p = state["p"]
	entity["p"] = p
	node.transform.origin = p


func create_entity(entity_data, id):
	var player_instance = token_player.instance()
	player_instance.name = str(id)
	map_node.add_child(player_instance)
	map_entities[id] = {
		"node": player_instance,
		"p": entity_data["p"]
	}


func remove_entity(id):
	var entity = map_entities[id]
	entity["node"].queue_free()


func _process(delta):
	update_entities()


func update_entities():
	if map_state_buffer.size() < 2:
		return;
	
	var render_time = Time.time - render_time_backtrack
	while map_state_buffer.size() > 2 && render_time > map_state_buffer[1]["t"]:
		map_state_buffer.remove(0)
	
	var t = inverse_lerp(map_state_buffer[0]["t"],map_state_buffer[1]["t"], render_time)
	
	for id in map_entities:
		update_entity(id, t)


func update_entity(id, t):
	if map_state_buffer[0]["entities"].has(id) && map_state_buffer[1]["entities"].has(id):
		var state_a = map_state_buffer[0]["entities"][id]
		var state_b = map_state_buffer[1]["entities"][id]
		
		var lerped_origin = lerp(state_a["p"], state_b["p"], t)
		
		var entity = map_entities[id]
		var node = entity["node"]
		node.transform.origin = lerped_origin
