extends Camera


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		var m_pos = get_viewport().get_mouse_position()
		var hit = raycast_from_mouse(m_pos, 1)
		if hit:
			WorldClient.move_player_to(hit.position)
			print("sent move message to: " + str(hit.position))


func raycast_from_mouse(m_pos, collision_mask):
	var ro = project_ray_origin(m_pos)
	var rd = project_ray_normal(m_pos)
	var ray_length = 50
	
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ro, rd*ray_length, [], collision_mask)
	
