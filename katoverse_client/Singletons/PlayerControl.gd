extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		var m_pos = get_viewport().get_mouse_position()
		var hit = raycast_from_mouse(m_pos, 1)
		if hit:
			WorldClient.move_player_to(hit.position)
			print("sent move message to: " + str(hit.position))
	
onready var cam = get_node("/root/GAME_SCENE/Camera")

func raycast_from_mouse(m_pos, collision_mask):
	print(cam)
	var ro = cam.project_ray_origin(m_pos, collision_mask)
	var rd = cam.project_ray_normal(m_pos)
	var ray_length = 50
	
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ro, rd*ray_length, [], collision_mask)
	
