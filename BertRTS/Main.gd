extends Node

#Entities
onready var worker = preload("res://EntityLogic/EntityScenes/Worker.tscn")

#Utils
onready var UIUtils = preload("res://Utils/UIUtils.gd")
onready var WorldGenUtils = preload("res://WorldLogic/WorldUtils.gd")

onready var WorldBuilding = preload("res://WorldLogic/WorldBuilding.gd")
onready var WorldInteraction = preload("res://WorldLogic/WorldInteraction.gd")

var ui_utils

var world_building
var world_interaction

func setup_utils():
	ui_utils = UIUtils.new()
	ui_utils.setup_ui($GUI, $ContextMenu, world_interaction)

func _ready():
	
	world_building = WorldBuilding.new()
	world_interaction = WorldInteraction.new()
	
	setup_utils()
	
	world_building.init_building()
	world_building.setup_noise()
	world_building.build_world(self, world_interaction)
	
	world_interaction.init_interaction($GUI, $BoundingBox, $ContextMenu, get_viewport(), self)

	var new_worker = worker.instance()
	var target_tile = General.all_tiles[1]

	new_worker.transform.origin = target_tile.global_transform.origin
	new_worker.connect("worker_selected", world_interaction, "_worker_Selected")

	add_child(new_worker)
	General.all_entities.append(new_worker)
	
func _process(delta):
	world_interaction.check_ui_updates($BoundingBox)
