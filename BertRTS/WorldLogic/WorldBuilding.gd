extends Node


var worldgen_utils

#World
var tile = preload("res://WorldLogic/Tile.tscn") 
var tree = preload("res://Assets/TWEEEEE.gltf")

export var map_size_x = 20
export var map_size_z = 20

var tile_amount = (map_size_x * map_size_z) + map_size_z # We have extras at 0 position, dont question it too much or else we're short some tiles
var tile_x_size = 10
var tile_z_size = 10
var tile_bounds_offset = 1

var trees_per_tile = 12
var forest_chance_per_tile_base = 15
var forest_chance_per_tile = forest_chance_per_tile_base

var tree_scale = Vector3(0.219, 0.224, 0.187) #x y z
var warehouse_scale = Vector3(0.113, 0.15, 0.1)

# End world values
var noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

func init_building(worldgenUtils):
	worldgen_utils = worldgenUtils


func setup_noise():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8	

func build_tiles(tile_amount, scene):
		var x_offset = 0
		var z_offset = 0
	
		for n in tile_amount:
			var target_pos = Vector3.ZERO
			var new_tile = tile.instance()

			target_pos.x = (x_offset * tile_x_size) 
			target_pos.z = (z_offset * tile_z_size)
			
			x_offset = x_offset + 1
			
			if (x_offset > map_size_x):
				z_offset = z_offset + 1
				x_offset = 0

			new_tile.global_translation = target_pos
			new_tile.noise_val = noise.get_noise_2d(
				float(target_pos.x + OS.get_time().second),
				float(target_pos.z) + OS.get_time().second)
			
			new_tile.connect("new_position", self, "on_tile_click")
			new_tile.connect("new_interaction", self, "on_tile_interact")
			
			General.all_tiles.append(new_tile)
			
			scene.add_child(new_tile)
			worldgen_utils.set_tile_bounds(new_tile, tile_x_size, tile_z_size, tile_bounds_offset)


func try_create_forest(chance, tile, scene):
	
	rng.randomize()
	
	if (chance >= forest_chance_per_tile):
		forest_chance_per_tile = forest_chance_per_tile_base #reset
		return -1
	
	var tree_amount = rng.randf_range(1, trees_per_tile)
	tile.building_allowed = false
	
	for n in tree_amount:
		var add_tree = tree.instance()
		var new_tree = worldgen_utils.generate_randomly_positioned_element(
		 tile,
		 add_tree,
		 tree_scale
		)
		
		scene.add_child(new_tree)
		General.all_entities.append(new_tree)
		
	if (forest_chance_per_tile == forest_chance_per_tile_base):
		forest_chance_per_tile = 80
	
	forest_chance_per_tile -= 10 # decrease by 10%
	
	return 0

func build_noised_biomes(scene):
	
	# Every grass tile has a 5% chance to have a "forest" with a random amount of trees ranging to a max of 5 trees per tile. The tile next to it (right) and the tile below (under)
	# Get an increased chance to have trees, building down from 80%. This chance goes down the longer the chain goes on!
	rng.randomize()
	
	for n in tile_amount:
		var noise_val = General.all_tiles[n].noise_val
		var random_forest_chance = rng.randf_range(0, 100);
		
		if (noise_val <= 0):

			General.all_tiles[n].tile_type = "Grass"
			General.all_tiles[n].building_allowed = true
			
			try_create_forest(random_forest_chance, General.all_tiles[n], scene)
			
		if (noise_val >= 0):
			General.all_tiles[n].tile_type = "Water"
			General.all_tiles[n].building_allowed = false
		
		General.all_tiles[n].set_tile_color()

func build_world(scene):
	build_tiles(tile_amount, scene)
	build_noised_biomes(scene)

