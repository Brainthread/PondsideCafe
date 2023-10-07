extends Area2D

func _is_licking():
	for body in get_overlapping_bodies():
		var layer = body.get_collision_layer()
		if layer == 2 || layer == 3:
			return 2
		if layer == 4:
			return 1
	return 0
	
