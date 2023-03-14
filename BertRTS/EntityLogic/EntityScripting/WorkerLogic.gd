extends KinematicBody

# Exported speed var for use in editor
export var speed = float(30)
export var type = "Worker"

# Worker selected
signal worker_selected(position)

# Target pos VECTOR3
var target_pos = Vector3.ZERO
var current_direction = Vector3.ZERO

# Locally used movement assitance vars
var moving = false
var dist = 0

var time_spent_moving = 0
var move_duration = 0

var step_x = 0
var step_z = 0

func move(var pos):
	time_spent_moving = 0
	move_duration = 0
	
	target_pos = pos
	calculate_movement_values(speed, target_pos)
	look_at_from_position(transform.origin, target_pos, Vector3.UP)
	
	moving = true

func calculate_movement_values(speed, target):
	var dist = 	transform.origin.distance_to(target)
	
	move_duration = (dist / speed)
	
	step_x = (move_duration / (target.x - transform.origin.x))
	step_z = (move_duration / (target.z - transform.origin.z))

func _physics_process(delta):
	
	if (time_spent_moving >= move_duration):
		moving = false
		move_duration = time_spent_moving + 1 # ensure we dont do any useless operations, like always resetting moving var
		
	if (moving == true):
		time_spent_moving += delta

		transform.origin.x += (delta / step_x)
		transform.origin.z += (delta / step_z)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Worker_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		emit_signal("worker_selected", position, self)
