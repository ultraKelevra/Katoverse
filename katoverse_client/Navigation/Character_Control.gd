extends Camera


onready var player = get_node("/root/World/Player")
var raycast_from

var ray_length = 50
var reserved_raycast : bool = false
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		raycast_from = event.position * get_viewport().global_canvas_transform.get_scale()
		reserved_raycast = true

func _physics_process(delta):
	if reserved_raycast:
		raycast_from_mouse(raycast_from, 1)
		reserved_raycast = false

func raycast_from_mouse(m_pos, collision_mask):
	var screen = get_viewport().get_visible_rect().size
	var normalized_m_pos = m_pos/screen
	#tunr from [0-1] to [-1,1]
	normalized_m_pos -= Vector2(0.5,0.5)
	normalized_m_pos *= 2
	#rescale
	normalized_m_pos *= 1.5
	#tunr back to [0,1]
	normalized_m_pos += Vector2(1,1)
	normalized_m_pos *= 0.5
	
	#unnormalize
	m_pos = normalized_m_pos * screen
	
	var ro = project_position(m_pos,1)#project_ray_origin(m_pos)
	var rd = project_position(m_pos,2) - ro#project_ray_normal(m_pos)
	
	
	var space_state = get_world().direct_space_state
	var hit = space_state.intersect_ray(ro, rd*ray_length, [], collision_mask)
	if hit:
		WorldClient.move_player_to(hit.position)

