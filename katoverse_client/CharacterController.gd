extends Node


onready var player = get_node("/root/")
onready var map_node = $"/root/MapController"
onready var map = get_node("/root/ServerSimulation/World/Navigation")
func _ready():
	
