extends KinematicBody
class_name PathAgent


var debug_lines : ImmediateGeometry
var path = []
var target: Vector3
var min_distance : float = 0.025
onready var navigation : Navigation = get_node("/root/World/WorldCollision/Navigation")
export var speed = 1
onready var waypoint_prefab = preload("res://Waypoint.tscn")
var waypoint_obj
var path_index : int


func _physics_process(delta):
	
	var path_size = path.size()
	if not path_index < path_size:
		return
	
	var pos = global_transform.origin
	var waypoint = path[path_index]
	var dir:Vector3 = waypoint - pos
	var dir_length = dir.length_squared()
	if dir_length < min_distance*min_distance:
		path_index += 1
		if path_index < path_size:
			waypoint = path[path_index]
			dir = waypoint - pos
			dir_length = dir.length_squared()
	else:
		move_and_slide(dir.normalized() * speed)


func calc_IA():
	var pos = global_transform.origin
	if target.distance_to(pos) > min_distance:
		path = navigation.get_simple_path(pos, target)
		path_index = 0
		waypoint_obj.global_transform.origin = target


func move_to(position: Vector3):
	target = position
	calc_IA()


func print_debug_lines():
	debug_lines.global_transform.origin = global_transform.origin
	debug_lines.clear()
	debug_lines.begin(Mesh.PRIMITIVE_LINES)
	debug_lines.set_color(Color.honeydew)
	var prev_waypoint: Vector3
	var first_time: bool = true
	for waypoint in path:
		if not first_time:
			debug_lines.add_vertex(prev_waypoint - global_transform.origin)
			debug_lines.add_vertex(waypoint - global_transform.origin)
		prev_waypoint = waypoint
		first_time = false
	debug_lines.end()


func _process(delta):
	#calc_IA()
	print_debug_lines()


func _ready():
	waypoint_obj = waypoint_prefab.instance()
	get_node("/root/World/WorldCollision/").add_child(waypoint_obj)
	debug_lines = ImmediateGeometry.new()
	add_child(debug_lines)
	#var IA_Counter = Timer.new()
	#add_child(IA_Counter)
	#IA_Counter.start(1/16.0)
	#IA_Counter.connect("timeout", self, "calc_IA")

