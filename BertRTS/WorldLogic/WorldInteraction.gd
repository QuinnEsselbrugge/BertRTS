extends Node

#Utils
var WorldGenUtils = load("res://WorldLogic/WorldUtils.gd")

var cross = load("res://Utils/Cross.tscn")
var UIUtils = load("res://Utils/UIUtils.gd")

var warehouse_scale = Vector3(0.113, 0.15, 0.1)

var main_scene
var ui_utils
var worldgen_utils
var GUI
var bounding_box
var context_menu
var viewport

# Interaction values
var currently_selected = false

#Generic functions

func init_interaction(gui, boundingBox, contextMenu, viewPort, mainScene):
	ui_utils = UIUtils.new()
	worldgen_utils = WorldGenUtils.new()
	GUI = gui
	bounding_box = boundingBox
	context_menu = contextMenu
	viewport = viewPort
	main_scene = mainScene

func check_ui_updates(bounding_box):
	check_bounding_box(bounding_box)
	check_selected_count()

func check_bounding_box(bounding_box):

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

	main_scene.add_child(new_cross)

#Build selected building
func build_selected():
	var selected_list_item = ui_utils.get_selected_item_building_list(GUI) as String
	var can_build = worldgen_utils.can_build(General.currently_selected_tile, selected_list_item)
	
	if (can_build == true):
			
		var asset = load(General.asset_list[selected_list_item]).instance()
		var new_asset = worldgen_utils.generate_positioned_element(asset, General.currently_selected_pos, warehouse_scale)
		
		General.currently_selected_tile.building_present = true
		ui_utils.update_material_labels(GUI)
		
		main_scene.add_child(new_asset)

# Interactions and signals
func _worker_Selected(pos, worker):
	General.all_selected_entities.append(worker)

func on_tile_click(pos):
	General.camera_movement_enabled = true
	context_menu.visible = false
	
	play_cross(pos)
	
	ui_utils.set_bounding_box_pos(bounding_box, viewport.get_mouse_position(), pos)

	for n in General.all_selected_entities.size():
		var entity = General.all_selected_entities[n]
		
		if (entity is KinematicBody):
			entity.move(pos)
			
func on_tile_interact(pos, tile):
	context_menu.visible = !context_menu.visible
	var viewport_pos = viewport.get_mouse_position()
	
	context_menu.rect_position.x = viewport_pos.x
	context_menu.rect_position.y = viewport_pos.y
	
	General.camera_movement_enabled = !General.camera_movement_enabled
	General.currently_selected_tile = tile
	General.currently_selected_pos = pos
