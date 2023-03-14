extends Node

onready var WorldInteraction = load("res://WorldLogic/WorldInteraction.gd")

var gui
var main_node
var world_interaction

var bounding_box_ingame_start_pos = Vector3.ZERO
var bounding_box_viewport_start_pos = Vector2.ZERO

func setup_ui(gui_node, context_menu, worldInteraction):
	world_interaction = worldInteraction
	gui = gui_node

	var wood_label = gui.get_node(UiDefinitions.ui_dict["WoodLabel"])
	var metal_label = gui.get_node(UiDefinitions.ui_dict["MetalLabel"])
	var food_label = gui.get_node(UiDefinitions.ui_dict["FoodLabel"])
	
	wood_label.text = ResourceVariables.wood as String
	metal_label.text = ResourceVariables.metal as String
	food_label.text = ResourceVariables.food as String 	
	
	var length = UiDefinitions.building_list.size()
	var building_list = gui.get_node("HSplitContainer/GameContext/BuildingList") as ItemList
	
	for n in length:
		building_list.add_item(UiDefinitions.building_list[n])
	#TODO: Implement uses of the buttons
	
	var button_build = context_menu.get_node("Panel/Build") as Button
	button_build.connect("pressed", self, "_button_build_pressed")


		
func set_bounding_box_pos(box, init_viewport_pos, in_game_pos):
	bounding_box_ingame_start_pos = in_game_pos
	bounding_box_viewport_start_pos = init_viewport_pos
	
	var bounding_box = box as ColorRect
	
	bounding_box.rect_position.x = bounding_box_viewport_start_pos.x
	bounding_box.rect_position.y = bounding_box_viewport_start_pos.y
	

func run_bounding_box_check(box, viewport_mouse_pos):
	var bounding_box = box as ColorRect
	
	if (General.left_mouse_down == true):
		General.camera_movement_enabled = false
		
		var val_x = viewport_mouse_pos.x
		var val_y = viewport_mouse_pos.y
		
		var bounding_start_x = bounding_box_viewport_start_pos.x
		var bounding_start_y = bounding_box_viewport_start_pos.y
		
		if (val_x > bounding_start_x and val_y > bounding_start_y):
			bounding_box.rect_rotation = 0
			bounding_box.rect_size.x = val_x - bounding_start_x
			bounding_box.rect_size.y = val_y - bounding_start_y
			
		if (val_x < bounding_start_x and val_y > bounding_start_y):
			bounding_box.rect_rotation = 90
			bounding_box.rect_size.y = bounding_start_x - val_x
			bounding_box.rect_size.x =  val_y - bounding_start_y
			
		if (val_x < bounding_start_x and val_y < bounding_start_y):
			bounding_box.rect_rotation = 180
			bounding_box.rect_size.x = bounding_start_x - val_x
			bounding_box.rect_size.y =  bounding_start_y - val_y
		
		if (val_x > bounding_start_x and val_y < bounding_start_y):
			bounding_box.rect_rotation = 270
			bounding_box.rect_size.y = val_x - bounding_start_x
			bounding_box.rect_size.x =  bounding_start_y - val_y
		
		General.bounding_box_selected_bounds = [bounding_box_ingame_start_pos, General.current_mouse_position]
		General.bounding_box_selected = true
		
		return
		
	bounding_box.rect_size.x = 0
	bounding_box.rect_size.y = 0

func get_selected_item_building_list(gui):
	var list = gui.get_node(UiDefinitions.ui_dict["BuildingList"]) as ItemList
	
	if (list.is_anything_selected()):
		var selected = list.get_selected_items()
		var text = list.get_item_text(selected[0])
		
		return text
		
	return ""
	
func update_selected_label(gui, val):
	var selected_label = gui.get_node(UiDefinitions.ui_dict["SelectedLabel"])
	selected_label.text = "Selected: " + val as String


func update_material_labels(GUI):
	var wood_label = GUI.get_node(UiDefinitions.ui_dict["WoodLabel"])
	var metal_label = GUI.get_node(UiDefinitions.ui_dict["MetalLabel"])
	var food_label = GUI.get_node(UiDefinitions.ui_dict["FoodLabel"])
	
	wood_label.text = ResourceVariables.wood as String
	metal_label.text = ResourceVariables.metal as String
	food_label.text = ResourceVariables.food as String
	
func _button_build_pressed():
	world_interaction.build_selected()
