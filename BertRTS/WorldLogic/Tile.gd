extends Spatial

onready var WaterShader = preload("res://Shaders/Water.gdshader")

export var tile_type = "Grass" #def
export var noise_val = 0
export var tile_resource = 0
export var bounds = [Vector3(), Vector3()]

signal new_position(position)

var color_dict = {
	"Grass": Color( 0, 0.392157, 0, 1 ),
	"Forest": Color( 0.133333, 0.545098, 0.133333, 1 ),
	"Water": WaterShader
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_tile_color():
	if (color_dict[tile_type] is Color):
		var material = SpatialMaterial.new()
		material.params_diffuse_mode = SpatialMaterial.DIFFUSE_TOON
		material.params_specular_mode = SpatialMaterial.SPECULAR_TOON
		material.albedo_color = color_dict[tile_type]
		material.roughness = 0
		material.metallic = 0.4

		$StaticBody/Floor.set_surface_material(0, material)
#	else:
#		var mat = ShaderMaterial.new()
#		mat.shader = color_dict[tile_type]
#
#		$StaticBody/Floor.set_surface_material(0, mat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StaticBody_input_event(camera, event, position, normal, shape_idx):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		emit_signal("new_position", position)
