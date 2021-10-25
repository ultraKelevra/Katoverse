extends Node

var map_timer : Timer
var server_timestamp = 0
var map_entities = {}
var map_state_buffer = []

onready var player = preload("res://VisualPlayer.tscn")
onready var map_node = $"/root/MapController"

func update_map(map_state):
	map_state["timestamp"] = map_timer.tim
	map_state_buffer.append(map_state)
	var entities = map_state["entities"]
	for entity in entities:
		if !map_entities.has(entity):
			create_entity(entities[entity], entity)
	for entity in map_entities:
		if !entities.has(entity):
			remove_entity(entity)
	
	for id in map_state["entities"]:
		if map_entities.keys().has(id):
			update_entity(id, entities[id])
	

func update_entity(id, state):
	#print(state)
	var entity = map_entities[id]
	var pos = state["position"]
	entity["position"] = pos
	var node = entity["node"]
	node.transform.origin = pos

func create_entity(entity_data, id):
	var player_instance = player.instance()
	player_instance.name = str(id)
	map_node.add_child(player_instance)
	map_entities[id] = {
		"node": player_instance,
		"position": entity_data["position"]
	}

func remove_entity(id):
	var entity = map_entities[id]
	entity["node"].queue_free()


func _process(delta):
	if map_entities.size() < 3:
		return;
	
	for id in map_entities:
		var entity_story = [
			map_state_buffer[0]["entities"][id],
			map_state_buffer[1]["entities"][id],
			map_state_buffer[2]["entities"][id]
			]
		if entity_story[0] && entity_story[1] && entity_story[2]:
			var entity = map_entities[id]
			var node = entity["node"]
			node.transform.origin
			#node.origin = lerp()
		
