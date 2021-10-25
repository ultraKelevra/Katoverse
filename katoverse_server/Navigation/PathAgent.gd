extends KinematicBody
class_name PathAgent


var debug_lines : ImmediateGeometry
var path = []
var target: Vector3
var min_distance : float = 0.025
onready var navigation : Navigation = get_parent()
export var speed = 1
onready var waypoint_prefab = preload("res://Navigation/Waypoint.tscn")
var waypoint_obj
var path_index : int


func _physics_process(delta):
	var path_size = path.size()
	var pos = global_transform.origin
	var walk_dist = speed*delta
	while path_index < path_size:
		var waypoint = path[path_index]
		var distance_to_waypoint = pos.distance_to(waypoint)
		#if your speed isn't enough to get to the waypoint, just move
		if distance_to_waypoint > walk_dist and walk_dist > 0.0:
			move_and_slide((waypoint - pos).normalized()*speed)
			break
		elif walk_dist < 0.0:
			global_transform.origin = waypoint
			set_physics_process(false)
			break
		#otherwhise you have passed it
		walk_dist -= distance_to_waypoint
		pos = waypoint
		path_index += 1

func calc_IA():
	var pos = global_transform.origin
	if target.distance_to(pos) > min_distance:
		path = navigation.get_simple_path(pos, target)
		path_index = 0
		waypoint_obj.global_transform.origin = target
		set_physics_process(true)


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
	print_debug_lines()


func _ready():
	waypoint_obj = waypoint_prefab.instance()
	get_node("/root").add_child(waypoint_obj)
	debug_lines = ImmediateGeometry.new()
	add_child(debug_lines)

