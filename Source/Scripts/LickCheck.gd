extends Area2D

func _is_licking():
	for body in get_overlapping_bodies():
		var layer = body.get_collision_layer()
		if layer == 4:
			return 2
		if layer == 8:
			return 1
	return 0

func _get_licked_body():
	if _is_licking() == 0:
		return null
	else:
		for body in get_overlapping_bodies():
			return body
