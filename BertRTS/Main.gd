extends Node

#Entities
onready var worker = preload("res://EntityLogic/EntityScenes/Worker.tscn")

#Utils
onready var cross = preload("res://Utils/Cross.tscn")
onready var UIUtils = preload("res://Utils/UIUtils.gd")
onready var WorldGenUtils = preload("res://WorldLogic/WorldUtils.gd")

onready var WorldBuilding = preload("res://WorldLogic/WorldBuilding.gd")
onready var WorldInteraction = preload("res://WorldLogic/WorldInteraction.gd")

var ui_utils
var worldgen_utils

var world_building
var world_interaction

func setup_utils():
	ui_utils = UIUtils.new()
	ui_utils.setup_ui($GUI)
	
	worldgen_utils = WorldGenUtils.new()

func _ready():
	setup_utils()
	
	world_building = WorldBuilding.new()
	world_interaction = WorldInteraction.new()
#
	world_building.init_building(worldgen_utils)
	world_interaction.init_interaction(worldgen_utils, ui_utils, $GUI, $BoundingBox)
#
	world_building.setup_noise()

	world_building.build_world(self)
#	world_building.setup_resources()

	var new_worker = worker.instance()
	var target_tile = General.all_tiles[1]

	new_worker.transform.origin = target_tile.global_transform.origin
	new_worker.connect("worker_selected", self, "_worker_Selected")

	add_child(new_worker)
	General.all_entities.append(new_worker)

func _process(delta):

	world_interaction.check_ui_updates(get_viewport(), $BoundingBox)
