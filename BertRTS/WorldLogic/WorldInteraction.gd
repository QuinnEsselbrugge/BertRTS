extends Node

#Utils
onready var WorldGenUtils = preload("res://WorldLogic/WorldUtils.gd")
onready var cross = preload("res://Utils/Cross.tscn")
onready var UIUtils = preload("res://Utils/UIUtils.gd")

var ui_utils
var worldgen_utils
var GUI
var bounding_box

# Interaction values
var currently_selected = false

func init_interaction(worldgenUtils, uiUtils, gui, boundingBox):
	ui_utils = uiUtils
	worldgen_utils = worldgenUtils
	GUI = gui
	bounding_box = boundingBox

func check_ui_updates(viewport, bounding_box):
	check_bounding_box(viewport, bounding_box)
	check_selected_count()

func check_bounding_box(viewport, bounding_box):

	ui_utils.run_bounding_box_check(bounding_box, viewport.get_mouse_position())
	
	if (General.bounding_box_selected == true):
		
		General.all_selected_entities = worldgen_utils.get_entities_in_bounds(General.bounding_box_selected_bounds, General.all_entities)
		
		General.camera_movement_enabled = true
		General.bounding_box_selected = false

func check_selected_count():
	ui_utils.update_selected_label(GUI, General.all_selected_entities.size())

func play_cross(pos):
	var new_cross = cross.instance()
	new_cross.transform.origin = pos
	new_cross.get_node("ClickPlayer").play("Exist")

	add_child(new_cross)

func _worker_Selected(pos, worker):
	General.all_selected_entities.append(worker)

func on_tile_click(pos):
	play_cross(pos)
	
	ui_utils.set_bounding_box_pos(bounding_box, get_viewport().get_mouse_position(), pos)

	for n in General.all_selected_entities.size():
		var entity = General.all_selected_entities[n]
		
		if (entity is KinematicBody):
			entity.move(pos)
			
func on_tile_interact(pos, tile):
	var selected_list_item = ui_utils.get_selected_item_building_list(GUI) as String

	if (!selected_list_item.empty() and tile.building_allowed == true and tile.building_present == false):
		var asset = load(selected_list_item).instance()
#		var new_asset = worldgen_utils.generate_positioned_element(asset, pos, warehouse_scale)
		
		tile.building_present = true
		
#		add_child(new_asset)
	
