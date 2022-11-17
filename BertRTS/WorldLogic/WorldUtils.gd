extends Node

var rng = RandomNumberGenerator.new()

func generate_randomly_positioned_element(var tile, var element, var scale):
	var target_pos = Vector3.ZERO
	var target_rotation = Vector3.ZERO
	
	var random_position_in_bounds = get_random_2d_position_in_bounds(tile.bounds, rng) # VECTOR 3
	target_rotation.y = rng.randf_range(-180, 180)
	
	
	element.translation = random_position_in_bounds
	element.rotation = target_rotation
	element.scale = scale
	
	return element
		

func get_tile_bounds(var tile_center, var tile_x_size, var tile_z_size):
	var bounds = [] # TOP LEFT, TOP RIGHT, BOTTOM LEFT, BOTTOM RIGHT
	
	var upper_bound = tile_center.z - (tile_z_size / 2) 
	var left_bound = tile_center.x - (tile_x_size / 2)
	var right_bound = tile_center.x + (tile_x_size / 2)
	var lower_bound = tile_center.z + (tile_z_size / 2)

	bounds.append(Vector3(left_bound, 0, right_bound))
	bounds.append(Vector3(upper_bound, 0, lower_bound))
	
	return bounds
	
func set_tile_bounds(var tile, var tile_x_size, var tile_z_size, tile_bounds_offset):
	var tile_center = tile.global_transform.origin
	
	var tile_bounds = get_tile_bounds(
		 tile_center,
		 tile_x_size - tile_bounds_offset,
		 tile_z_size - tile_bounds_offset
	) # ORDER : LEFT TO RIGHT, TOP TO BOTTOM
	

	tile.bounds = tile_bounds
	

func get_random_2d_position_in_bounds(var bounds, var rng):
	var x_bounds = bounds[0]
	var z_bounds = bounds[1]
	
	rng.randomize()
	
	var random_x = rng.randf_range(x_bounds[0], x_bounds[2])
	var random_z = rng.randf_range(z_bounds[0], z_bounds[2])
	
	return Vector3(random_x, 0, random_z)
	
func get_entities_in_bounds(var bounds, var entities):
	var first_point = bounds[0]
	var second_point = bounds[1]
	
	for n in entities.size():
		var entity_pos = entities[n].transform.origin
		#TODO : IMPROVE A LOT, MAKE THIS FUNCTION NOT BE CALLED AS MUCH WHEN THE SIGNAL IS EMITTED
		
		if (entity_pos.x > first_point.x and entity_pos.z > first_point.z and entity_pos.x < second_point.x and entity_pos.z < second_point.z):
			print(entities[n])
	
	
