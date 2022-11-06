extends Node

#World
onready var tile = preload("res://WorldLogic/Tile.tscn") 
onready var tree = preload("res://Assets/TWEEEEE.gltf")

#Entities
onready var worker = preload("res://EntityLogic/EntityScenes/Worker.tscn")

#Utils
onready var cross = preload("res://Utils/Cross.tscn")

#Scripts
const WorldGenUtils = preload("res://WorldLogic/WorldGenUtils.gd")

export var map_size_x = 20
export var map_size_z = 20

var tile_amount = (map_size_x * map_size_z) + map_size_z # We have extras at 0 position, dont question it too much or else we're short some tiles
var tile_x_size = 10
var tile_z_size = 10
var tile_bounds_offset = 1

var all_tiles: Array

# World values
var trees_per_tile = 12
var forest_chance_per_tile_base = 15
var forest_chance_per_tile = forest_chance_per_tile_base

var tree_scale = Vector3(0.219, 0.224, 0.187) #x y z

# Interaction values
var currently_selected = false

# End world values
var noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()


func build_tiles(var tile_amount):
		
		var utils = WorldGenUtils.new()
		
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
			new_tile.noise_val = noise.get_noise_2d(float(target_pos.x + OS.get_time().second), float(target_pos.z) + OS.get_time().second)
			new_tile.connect("new_position", self, "_on_New_Position_Received")
			
			all_tiles.append(new_tile)
			
			add_child(new_tile)
			utils.set_tile_bounds(new_tile, tile_x_size, tile_z_size, tile_bounds_offset)


func try_create_forest(var chance, var tile):
	
	rng.randomize()
	
	if (chance >= forest_chance_per_tile):
		forest_chance_per_tile = forest_chance_per_tile_base #reset
		return -1
	
	var tree_amount = rng.randf_range(0, trees_per_tile)
	var utils = WorldGenUtils.new()
	
	for n in tree_amount:
		var add_tree = tree.instance()
		var new_tree = utils.generate_randomly_positioned_element(
		 tile,
		 add_tree,
		 tree_scale
		)
		
		add_child(new_tree)
		
	if (forest_chance_per_tile == forest_chance_per_tile_base):
		forest_chance_per_tile = 80
	
	forest_chance_per_tile -= 10 # decrease by 10%
	
	return 0

func build_noised_biomes():
	
	# Every grass tile has a 5% chance to have a "forest" with a random amount of trees ranging to a max of 5 trees per tile. The tile next to it (right) and the tile below (under)
	# Get an increased chance to have trees, building down from 80%. This chance goes down the longer the chain goes on!
	rng.randomize()
	
	for n in tile_amount:
		var noise_val = all_tiles[n].noise_val
		var random_forest_chance = rng.randf_range(0, 100);
		
		if (noise_val <= 0):

			all_tiles[n].tile_type = "Grass"
			try_create_forest(random_forest_chance, all_tiles[n])
			
		if (noise_val >= 0):
			all_tiles[n].tile_type = "Water"
		
		all_tiles[n].set_tile_color()
	

func build_world():
	
	build_tiles(tile_amount)
	build_noised_biomes()

	
func _ready():
	
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8	
	
	build_world();

func _worker_Selected(pos, worker):
	currently_selected = worker

func _on_New_Position_Received(pos):
	var new_cross = cross.instance()
	new_cross.transform.origin = pos
	new_cross.get_node("ClickPlayer").play("Exist")

	add_child(new_cross)

	var new_worker = worker.instance()

	var target_tile = all_tiles[0]
	
	new_worker.transform.origin = target_tile.global_transform.origin
	new_worker.connect("worker_selected", self, "_worker_Selected")
	
	add_child(new_worker)
	
	new_worker.move(pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
