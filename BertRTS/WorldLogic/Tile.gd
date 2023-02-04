extends Spatial

onready var WaterShader = preload("res://Shaders/Water.gdshader")

export var tile_type = "Grass" #def
export var noise_val = 0
export var building_allowed = false
export var building_present = false
export var bounds = [Vector3(), Vector3()]

signal new_position(position)
signal new_interaction(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_tile_color():
	var material = SpatialMaterial.new()
	material.params_diffuse_mode = SpatialMaterial.DIFFUSE_TOON
	material.params_specular_mode = SpatialMaterial.SPECULAR_TOON
	material.albedo_color = General.color_dict[tile_type]
	material.roughness = 0
	material.metallic = 0.4

	$StaticBody/Floor.set_surface_material(0, material)
#		var mat = ShaderMaterial.new()
#		mat.shader = color_dict[tile_type]
#
#		$StaticBody/Floor.set_surface_material(0, mat)

func _input(event):
	if  (event is InputEventMouseButton and event.button_index == 1 and not event.is_pressed()):
		General.left_mouse_down = false
			
func _on_StaticBody_input_event(camera, event, position, normal, shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_index == 1):
		emit_signal("new_position", position)
		General.left_mouse_down = true
	
	if (event is InputEventMouseButton and event.pressed and event.button_index == 2):
		emit_signal("new_interaction", position, self)
		General.right_mouse_down = true
		
	General.current_mouse_position = position
