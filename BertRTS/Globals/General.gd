extends Spatial

var left_mouse_down = false
var right_mouse_down = false

var bounding_box_selected = false
var camera_movement_enabled = true

var left_mouse_button_pos = Vector3.ZERO

var bounding_box_selected_bounds = [Vector3(), Vector3()]
var current_mouse_position = Vector3.ZERO

var all_selected_entities: Array
var all_entities: Array
var all_tiles: Array

var color_dict = {
	"Grass": Color( 0, 0.392157, 0, 1 ),
	"Forest": Color( 0.133333, 0.545098, 0.133333, 1 ),
	"Water": Color( 0, 0, 1, 1 )
}

var asset_list = {
	"Warehouse": "res://Assets/wareHouse.gltf",
	"Tree": "res://Assets/TWEEEEE.gltf",
}
